//
//  MapPresenter.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 28/11/22.
//
import Foundation
import MapKit
import MessageUI

// MARK: - MapInteractorOutputProtocol
protocol MapInteractorOutputProtocol: AnyObject {
    func fetchedMakerData(pinMakers: [MakerAnotation]?, error: Errors?)
    func fetchedProductCategoriesData(productCategories: [ProductCategory]?, error: Errors?)
   // func fetchedAnnotationData(pinMakers: [MakerAnotation]?, error: Errors?)
}
// MARK: - RegistrationModuleDelegate
protocol RegistrationModuleDelegate: AnyObject {
    func fetchedNewMakerData(pinMakers: [MakerAnotation])
}
// MARK: - FilterCategoriesModuleDelegate
protocol FilterCategoriesModuleDelegate: AnyObject {
    func fetchedFilterCategoriesData(filterListCategories: [String])
}
// MARK: - GetProductMapDelegate
protocol GetProductMapDelegate: AnyObject {
    func IsWrittenMakerAnnotation(pinMakers: [MakerAnotation])
}
// MARK: - MapViewOutputProtocol
protocol MapViewOutputProtocol: AnyObject {
    func viewDidLoaded()
    func newRegistrationIsTapped(touchCoordinate: CLLocationCoordinate2D)
    func isTappedMakerImageView(touchCoordinate: CLLocationCoordinate2D, makerAnotation: MakerAnotation?)
    func isClickedFZoomInButton()
    func isClickedFZoomOutButton()
    func getMakerImage(pathImage: String?)
    func isLongTappedOnMapView(sender: UIGestureRecognizer)
    func isClickedFilterCategoriesButton()
    func isShortViewMapTapped()
    func isClickedPhoneButton(makerAnotation: MakerAnotation)
    func isClickedEmailButton(makerAnotation: MakerAnotation)
    
    var numberOfRowsInSectionCategoriesView: Int { get }
}
// MARK: - MapPresenter
final class MapPresenter {
    // MARK: - properties
    weak var view: MapViewInputProtocol?
    var router: MapRouterInputProtocol
    var interactor: MapInteractorInputProtocol
    var imageManager: ImageManagerProtocol
    lazy var productCategories = [ProductCategory]()
    var numberOfCategories: Int?
    lazy var categoriesViewModel: [(String, Bool)] = []
    lazy var touchCoordinateTappedImageMaker = CLLocationCoordinate2D()
    var makerAnotationTappedImageMaker: MakerAnotation?
    var filterCategoriesViewIsOpened = false
    var filterListCategories: [String] = []
    
    // MARK: - init
    init(interactor: MapInteractorInputProtocol, router: MapRouterInputProtocol, imageManager: ImageManagerProtocol) {
        self.interactor = interactor
        self.router = router
        self.imageManager = imageManager
    }
    
    // MARK: - Private functions
    //обновляем данные на карте
    func refreshMakerData(pinMakers: [MakerAnotation]) {
        if let makerAnotation = makerAnotationTappedImageMaker {
            self.view?.removePinMakers(pinMakers: makerAnotation)
        }
        
        self.view?.showDate(pinMakers: pinMakers)
        view?.setupBottomViewMakerData()
    }
    
    func getZoom() -> Double {
        if let view = view {
            var angleCamera = view.mapView.camera.heading
            if angleCamera > 270 {
                angleCamera = 360 - angleCamera
            } else if angleCamera > 90 {
                angleCamera = fabs(angleCamera - 180)
            }
            let angleRad = Double.pi * angleCamera / 180
            let width = Double(view.mapView.frame.size.width)
            let height = Double(view.mapView.frame.size.height)
            let heightOffset : Double = 20
            let spanStraight = width * view.mapView.region.span.longitudeDelta / (width * cos(angleRad) + (height - heightOffset) * sin(angleRad))
            return log2(360 * ((width / 256) / spanStraight)) + 1;
        } else {
            return 0
        }
    }
}
// MARK: - MapInteractorOutputProtocol
extension MapPresenter: MapInteractorOutputProtocol {
    func fetchedMakerData(pinMakers: [MakerAnotation]?, error: Errors?) {
        
        guard let pinMakers = pinMakers, error == nil else {
            switch error {
            case .loadCountriesError:
                router.presentWarnMessage(title: "Возникла ошибка базы данных",
                                          descriptionText: "Возникла ошибка при извлечении названий стран")
            case .loadCitiesError:
                router.presentWarnMessage(title: "Возникла ошибка базы данных",
                                          descriptionText: "Возникла ошибка при извлечении названий городов")
            case .loadMakersError:
                router.presentWarnMessage(title: "Возникла ошибка базы данных",
                                          descriptionText: "Возникла ошибка при извлечении поставщиков услуг")
            default:
                return
            }
            return
        }
        var pin: [MakerAnotation] = []
        if self.filterListCategories.isEmpty {
            pin = pinMakers
        } else {
            for anotation in pinMakers {
                guard let productCategoriesMaker = anotation.productCategoriesMaker else { return }
                for productCategory in productCategoriesMaker {
                    guard let productCategoryName = productCategory.category_name else { return }
                    if self.filterListCategories.contains(productCategoryName) {
                        pin.append(anotation)
                        break
                    }
                }
            }
        }
        
        DispatchQueue.main.async { [unowned self] in
            self.view?.showDate(pinMakers: pin)
        }
    }
    
    func fetchedProductCategoriesData(productCategories: [ProductCategory]?, error: Errors?) {
        
        guard let productCategories = productCategories, error == nil else {
            switch error {
            case .loadProdactCategoryError:
                router.presentWarnMessage(title: "Возникла ошибка базы данных",
                                          descriptionText: "Возникла ошибка при извлечении категорий продуктов")
            default:
                return
            }
            return
        }
        numberOfCategories = productCategories.count
        self.productCategories = productCategories
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.view?.updateSliderFilterCategoriesView(productCategories: self.categoriesViewModel)
        }
    }
}
// MARK: - MapViewOutputProtocol
extension MapPresenter: MapViewOutputProtocol {
    
    var numberOfRowsInSectionCategoriesView: Int {
        return numberOfCategories ?? 0
    }
    
    func viewDidLoaded() {
        interactor.fetchMakerData()
    }
    
    //запрос данных
    func ispressedProductCategoriesButton() {
        interactor.fetchCategoriesData()
    }
    
    func newRegistrationIsTapped(touchCoordinate: CLLocationCoordinate2D) {
        router.openRegistrtionScreen(for: touchCoordinate, makerAnotation: nil)
    }
    
    func getMakerImage(pathImage: String?) {
        
        var imageMaker = UIImage()
        
        if let path = pathImage {
            if let image = imageManager.getImage(pathImage: path) {
                imageMaker = image
            } else {
                if let image = UIImage(named: "undefinedImage", in: .module, compatibleWith: nil) {
                    imageMaker = image
                }
            }
        }
        else {
            if let image = UIImage(named: "undefinedImage", in: .module, compatibleWith: nil) {
                imageMaker = image
            }
        }
        view?.setMakerImageView(imageMAker: imageMaker)
        
    }
    func isTappedMakerImageView(touchCoordinate: CLLocationCoordinate2D, makerAnotation: MakerAnotation?) {
        touchCoordinateTappedImageMaker = touchCoordinate
        makerAnotationTappedImageMaker = makerAnotation
        router.openRegistrtionScreen(for: touchCoordinate, makerAnotation: makerAnotation)
    }
    
    func isLongTappedOnMapView(sender: UIGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: view?.mapView)
            let touchCoordinate = view?.mapView.convert(touchPoint, toCoordinateFrom: view?.mapView)
            
            view?.showAlertLocation(title: "Регистрация", message: "Хотите добавить нового поставщика услуг?", url: nil, titleAction: "Да", touchCoordinate: touchCoordinate)
        }
    }
    
    func isClickedFilterCategoriesButton() {
        if !filterCategoriesViewIsOpened {
            view?.mapView.alpha = 0.5
            router.openFilterCategoriesScreen()
        } else {
            view?.mapView.alpha = 1
            router.removeFilterCategoriesScreen()
        }
        filterCategoriesViewIsOpened = !filterCategoriesViewIsOpened
    }
    //скрываем filterCategoriesView
    func isShortViewMapTapped() {
        view?.mapView.alpha = 1
        router.removeFilterCategoriesScreen()
        filterCategoriesViewIsOpened = !filterCategoriesViewIsOpened
    }
    
    func isClickedFZoomInButton() {
        if let view = view {
            let region = MKCoordinateRegion(center: view.mapView.region.center, span: MKCoordinateSpan(latitudeDelta: view.mapView.region.span.latitudeDelta*0.7, longitudeDelta: view.mapView.region.span.longitudeDelta*0.7))
            view.mapView.setRegion(region, animated: true)
            isShortViewMapTapped()
        }
    }
    func isClickedFZoomOutButton() {
        if let view = view {
            let zoom = getZoom() // to get the value of zoom of your map.
            if zoom > 3.5{ // **here i have used the condition that avoid the mapview to zoom less then 3.5 to avoid crash.**
                
                let region = MKCoordinateRegion(center: view.mapView.region.center, span: MKCoordinateSpan(latitudeDelta: view.mapView.region.span.latitudeDelta/0.7, longitudeDelta: view.mapView.region.span.longitudeDelta/0.7))
                view.mapView.setRegion(region, animated: true)
            }
            isShortViewMapTapped()
        }
    }
    //делаем исходящий звонок
    func isClickedPhoneButton(makerAnotation: MakerAnotation) {
        
        if let url = URL(string: "tel://\(makerAnotation.phoneNumberMaker)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            
        } else {
            print("This app is not allowed to query for scheme tel")
        }
    }
    
    //отправляем email
    func isClickedEmailButton(makerAnotation: MakerAnotation) {
        if let emailURL = URL(string: "mailto:\(makerAnotation.emailMaker)"), UIApplication.shared.canOpenURL(emailURL)
        {
            UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
        }
    }
}
// MARK: - RegistrationModuleDelegate
extension MapPresenter: RegistrationModuleDelegate{
    //обновляем данные на карте
    func fetchedNewMakerData(pinMakers: [MakerAnotation]) {
        refreshMakerData(pinMakers: pinMakers)
    }
}
// MARK: - GetProductMapDelegate
extension MapPresenter: GetProductMapDelegate{
    //обновляем на карте данные
    func IsWrittenMakerAnnotation(pinMakers: [MakerAnotation]) {
        refreshMakerData(pinMakers: pinMakers)
    }
}

// MARK: - FilterCategoriesDelegate
extension MapPresenter: FilterCategoriesModuleDelegate{
   
    //обновляем на карте данные
    func fetchedFilterCategoriesData(filterListCategories: [String]) {
    
        self.filterListCategories = filterListCategories
        if let view = view {
            view.mapView.removeAnnotations(view.mapView.annotations)
        }
        interactor.fetchMakerData()
    }
}
