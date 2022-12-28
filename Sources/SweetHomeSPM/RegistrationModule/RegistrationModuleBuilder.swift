//
//  RegistrationModuleBuilder.swift
//  
//
//  Created by Aleksei Grachev on 13/12/22.
//
import MapKit

class RegistrationModuleBuilder {
    //@discardableResult
    static func build(factory: NavigationFactory, delegate: RegistrationModuleDelegate?, touchCoordinate: CLLocationCoordinate2D, makerAnotation: MakerAnotation?) ->
    UINavigationController
    {
        let view = RegistrationViewController()
        let interactor = RegistrationInteractor()
        let router = RegistrationRouter()
        let presenter = RegistrationPresenter(interactor: interactor, router: router, touchCoordinate: touchCoordinate, makerAnotation: makerAnotation)
        view.presenter = presenter
        presenter.delegate = delegate
        presenter.view = view
        
        interactor.presenter = presenter
        router.viewController = view
        return factory(view)
    }
}
