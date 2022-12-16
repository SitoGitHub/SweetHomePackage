//
//  MapPresenter.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 28/11/22.
//
import Foundation
import MapKit

public protocol MapPresenterProtocol: AnyObject {
    func viewDidLoaded()
    func fetchedMakerData(pinMakers: [MakerAnotation]?, error: Errors?)
    func newRegistrationIsTapped(touchCoordinate: CLLocationCoordinate2D)
}

public class MapPresenter {
    public weak var view: MapViewProtocol?
    public var router: MapRouterProtocol
    public var interactor: MapInteractorProtocol
    
    public init(interactor: MapInteractorProtocol, router: MapRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension MapPresenter: MapPresenterProtocol {
    public func viewDidLoaded() {
        interactor.fetchMakerData()
        
    }
    
    public func fetchedMakerData(pinMakers: [MakerAnotation]?, error: Errors?) {
        
        guard let pinMakers = pinMakers, error == nil else {
            switch error {
            case .loadCountriesError:
                view?.presentWarnMessage(title: "Возникла ошибка базы данных",
                                         descriptionText: "Возникла ошибка при извлечении транзакций")
            case .loadCitiesError:
                view?.presentWarnMessage(title: "Возникла ошибка базы данных",
                                         descriptionText: "Возникла ошибка при извлечении кошельков")
            case .loadMakersError:
                view?.presentWarnMessage(title: "Возникла ошибка базы данных",
                                         descriptionText: "Возникла ошибка при извлечении бюджетов")
            default:
                return
            }
            return
        }
        DispatchQueue.main.async { [unowned self] in
            self.view?.showDate(pinMakers: pinMakers)
        }
    }
    
    public func newRegistrationIsTapped(touchCoordinate: CLLocationCoordinate2D) {
        router.openRegistrtionScreen(for: touchCoordinate)
    }
}
