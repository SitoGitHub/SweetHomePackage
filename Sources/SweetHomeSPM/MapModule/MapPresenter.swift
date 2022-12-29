//
//  MapPresenter.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 28/11/22.
//
import Foundation
import MapKit

protocol MapInteractorOutputProtocol: AnyObject {
    func fetchedMakerData(pinMakers: [MakerAnotation]?, error: Errors?)
    func fetchedProductCategoriesData(productCategories: [ProductCategory]?, error: Errors?)
}

protocol RegistrationModuleDelegate: AnyObject {
    func fetchedNewMakerData(pinMakers: [MakerAnotation])
}

protocol GetProductMapDelegate: AnyObject {
    func IsWrittenMakerAnnotation(pinMakers: [MakerAnotation])
}

protocol MapViewOutputProtocol: AnyObject {
    func viewDidLoaded()
    func newRegistrationIsTapped(touchCoordinate: CLLocationCoordinate2D)
    func isTappedMakerImageView(touchCoordinate: CLLocationCoordinate2D, makerAnotation: MakerAnotation?)
    func getMakerImage(pathImage: String?)
    func isLongTappedOnMapView(sender: UIGestureRecognizer)
    func isClickedFilterCategoriesButton()
    var numberOfRowsInSectionCategoriesView: Int { get }
}

final class MapPresenter {
    weak var view: MapViewInputProtocol?
    var router: MapRouterInputProtocol
    var interactor: MapInteractorInputProtocol
    var imageManager: ImageManagerProtocol
    lazy var productCategories = [ProductCategory]()
    var numberOfCategories: Int?
    lazy var categoriesViewModel: [(String, Bool)] = []
    lazy var touchCoordinateTappedImageMaker = CLLocationCoordinate2D()
    var makerAnotationTappedImageMaker: MakerAnotation?
    
    init(interactor: MapInteractorInputProtocol, router: MapRouterInputProtocol, imageManager: ImageManagerProtocol) {
        self.interactor = interactor
        self.router = router
        self.imageManager = imageManager
    }
    
    //обновляем данные на карте
    func refreshMakerData(pinMakers: [MakerAnotation]) {
        if let makerAnotation = makerAnotationTappedImageMaker {
            self.view?.removePinMakers(pinMakers: makerAnotation)
        }
        
        self.view?.showDate(pinMakers: pinMakers)
        view?.setupBottomViewMakerData()
    }
}

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
        DispatchQueue.main.async { [unowned self] in
            self.view?.showDate(pinMakers: pinMakers)
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
        router.openFilterCategoriesScreen()
    }
}

extension MapPresenter: RegistrationModuleDelegate{
    //обновляем данные на карте
    func fetchedNewMakerData(pinMakers: [MakerAnotation]) {
        refreshMakerData(pinMakers: pinMakers)
    }
}

extension MapPresenter: GetProductMapDelegate{
    //обновляем на карте данные
    func IsWrittenMakerAnnotation(pinMakers: [MakerAnotation]) {
        refreshMakerData(pinMakers: pinMakers)
    }
}
