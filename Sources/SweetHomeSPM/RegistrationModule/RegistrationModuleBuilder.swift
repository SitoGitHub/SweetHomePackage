//
//  RegistrationModuleBuilder.swift
//  
//
//  Created by Aleksei Grachev on 13/12/22.
//
import MapKit
// MARK: -  RegistrationModuleBuilder
final class RegistrationModuleBuilder {
    //@discardableResult
    static func build(factory: NavigationFactory, delegate: RegistrationModuleDelegate?, touchCoordinate: CLLocationCoordinate2D, makerAnotation: MakerAnotation?) ->
    UINavigationController
    {
        let coreDataManager = CoreDataManager.shared
        let locationManager = LocationManager()
        let validData = ValidDataManager()
        let view = RegistrationViewController()
        let interactor = RegistrationInteractor(coreDataManager: coreDataManager, locationManager: locationManager)
        let router = RegistrationRouter()
        let presenter = RegistrationPresenter(interactor: interactor, router: router, validData: validData, touchCoordinate: touchCoordinate, makerAnotation: makerAnotation)
        view.presenter = presenter
        presenter.delegate = delegate
        presenter.view = view
        interactor.presenter = presenter
        router.viewController = view
        return factory(view)
    }
}
