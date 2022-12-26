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
}

public class MapPresenter {
    public weak var view: MapViewInputProtocol?
    public var router: MapRouterInputProtocol
    public var interactor: MapInteractorInputProtocol
    lazy var imageManager = ImageManager()
    
    public init(interactor: MapInteractorInputProtocol, router: MapRouterInputProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    deinit{
        print("MapPresenter deinit")
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
    
}

extension MapPresenter: MapViewOutputProtocol {
    public func viewDidLoaded() {
        interactor.fetchMakerData()
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
        router.openRegistrtionScreen(for: touchCoordinate, makerAnotation: makerAnotation)
    }
    
    public func isLongTappedOnMapView(sender: UIGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: view?.mapView)
            let touchCoordinate = view?.mapView.convert(touchPoint, toCoordinateFrom: view?.mapView)
            
            view?.showAlertLocation(title: "Регистрация", message: "Хотите добавить нового поставщика услуг?", url: nil, titleAction: "Да", touchCoordinate: touchCoordinate)
        }
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
        self.view?.showDate(pinMakers: pinMakers)
        view?.setupBottomViewMakerData()
    }
}
