//
//  MapPresenter.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 28/11/22.
//
import Foundation
import MapKit

public protocol MapInteractorOutputProtocol: AnyObject {
    func fetchedMakerData(pinMakers: [MakerAnotation]?, error: Errors?)
    func fetchedProductCategoriesData(productCategories: [ProductCategory]?, error: Errors?)
}

public protocol RegistrationModuleDelegate: AnyObject {
    func fetchedNewMakerData(pinMakers: [MakerAnotation])
}

public protocol GetProductMapDelegate: AnyObject {
    func IsWrittenMakerAnnotation(pinMakers: [MakerAnotation])
}


public protocol MapViewOutputProtocol: AnyObject {
    func viewDidLoaded()
    func newRegistrationIsTapped(touchCoordinate: CLLocationCoordinate2D)
    func isTappedMakerImageView(touchCoordinate: CLLocationCoordinate2D, makerAnotation: MakerAnotation?)
    func getMakerImage(pathImage: String?)
    func isLongTappedOnMapView(sender: UIGestureRecognizer)
    func isClickedFilterCategoriesButton()
    var numberOfRowsInSectionCategoriesView: Int { get }
}

public class MapPresenter {
    public weak var view: MapViewInputProtocol?
    public var router: MapRouterInputProtocol
    public var interactor: MapInteractorInputProtocol
    lazy var imageManager = ImageManager()
    // var numberOfRowsInSectionCategoriesView: Int?
    lazy var productCategories = [ProductCategory]()
    var numberOfCategories: Int?
    var categoriesViewModel: [(String, Bool)] = []
    lazy var touchCoordinateTappedImageMaker = CLLocationCoordinate2D()
    var makerAnotationTappedImageMaker: MakerAnotation?
    
    public init(interactor: MapInteractorInputProtocol, router: MapRouterInputProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    deinit{
        print("MapPresenter deinit")
    }
    
    //create ViewModel for tableView    -ТУТ НУЖНО ПРОВЕРКУ ДЕЛАТЬ, КАКИЕ ПУНКТЫ РАНЕЕ ВЫБИРАЛ ПОЛЬЗОВАТЕЛЬ
    func makeCategoriesViewModel(productCategories: [ProductCategory]) -> [(String, Bool)] {
    //    var isChanged = false
        return productCategories.map { productCategory in
            var categoryName = String()
            var check = false//Bool()
//            if let category = productCategory.category_name {
//                categoryName = category
//                check = arrayCategoriesMakers.contains(categoryName)
////                if check == true {
////                    isChanged = true
////                }
//            }
            return (categoryName, check)
        }
    }
    
    
}

extension MapPresenter: MapInteractorOutputProtocol {
    public func fetchedMakerData(pinMakers: [MakerAnotation]?, error: Errors?) {
        
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
    
    public func fetchedProductCategoriesData(productCategories: [ProductCategory]?, error: Errors?) {
        
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
        categoriesViewModel = makeCategoriesViewModel(productCategories: productCategories)
      //  DispatchQueue.main.async { [unowned self] in
         //   self.view?.updateViewWithProductCategories(productCategories: [productCategories])
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.view?.updateSliderFilterCategoriesView(productCategories: self.categoriesViewModel)
          //  self.view?.stopActivityIndicator()
        }
      //  }
    }
    
}

extension MapPresenter: MapViewOutputProtocol {
   
    public var numberOfRowsInSectionCategoriesView: Int {
        return numberOfCategories ?? 0
    }
    
    public func viewDidLoaded() {
        interactor.fetchMakerData()
    }
    
    //запрос данных
    func ispressedProductCategoriesButton() {
        interactor.fetchCategoriesData()
    }
    
    public func newRegistrationIsTapped(touchCoordinate: CLLocationCoordinate2D) {
        router.openRegistrtionScreen(for: touchCoordinate, makerAnotation: nil)
    }
    
    public func getMakerImage(pathImage: String?) {
        
        var imageMaker = UIImage()
        
        if let path = pathImage {
            if let image = imageManager.getImage(pathImage: path) {
                imageMaker = image
            }
        
//            let tempDirectoryUrl = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(path)
//
//            if let image = UIImage(fileURLWithPath: tempDirectoryUrl) {
//                imageMaker = image
//            }
        }
        
        else {
            if let image = UIImage(named: "undefinedImage", in: .module, compatibleWith: nil) {
                imageMaker = image
            }
        }
        
        view?.setMakerImageView(imageMAker: imageMaker)
        
    }
    public func isTappedMakerImageView(touchCoordinate: CLLocationCoordinate2D, makerAnotation: MakerAnotation?) {
        touchCoordinateTappedImageMaker = touchCoordinate
        makerAnotationTappedImageMaker = makerAnotation
        router.openRegistrtionScreen(for: touchCoordinate, makerAnotation: makerAnotation)
    }
    
    public func isLongTappedOnMapView(sender: UIGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: view?.mapView)
            let touchCoordinate = view?.mapView.convert(touchPoint, toCoordinateFrom: view?.mapView)
            
            view?.showAlertLocation(title: "Регистрация", message: "Хотите добавить нового поставщика услуг?", url: nil, titleAction: "Да", touchCoordinate: touchCoordinate)
        }
    }
    
    public func isClickedFilterCategoriesButton() {
        router.openFilterCategoriesScreen()
    }
}

extension MapPresenter: RegistrationModuleDelegate{
    public func fetchedNewMakerData(pinMakers: [MakerAnotation]) {
        
//        for annotation in self.view?.mapView.annotations{
//            self.view?.mapView.removeAnnotation(annotation)
//        }
       
//        for pinMaker in pinMakers {
//
//
//            self.view?.mapView.addAnnotation(pinMaker)
//
//           // self.view?.mapView.reloadInputViews()
//        }
        if let makerAnotation = makerAnotationTappedImageMaker {
            self.view?.removePinMakers(pinMakers: makerAnotation)
        }
        
        self.view?.showDate(pinMakers: pinMakers)
        view?.setupBottomViewMakerData()
    }
}

extension MapPresenter: GetProductMapDelegate{
    
    public func IsWrittenMakerAnnotation(pinMakers: [MakerAnotation]) {
      //  self.view?.removePinMakers(pinMakers: pinMakers)
        if let makerAnotation = makerAnotationTappedImageMaker {
            self.view?.removePinMakers(pinMakers: makerAnotation)
        }
        
        self.view?.showDate(pinMakers: pinMakers)
        view?.setupBottomViewMakerData()
    }
}
