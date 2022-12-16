//
//  RegistrationModuleBuilder.swift
//  
//
//  Created by Aleksei Grachev on 13/12/22.
//
import MapKit

 class RegistrationModuleBuilder {
    //@discardableResult
     static func build(touchCoordinate: CLLocationCoordinate2D) -> RegistrationViewController {
        let view = RegistrationViewController()
        let interactor = RegistrationInteractor()
        let router = RegistrationRouter()
         let presenter = RegistrationPresenter(interactor: interactor, router: router, touchCoordinate: touchCoordinate)
         view.presenter = presenter
         presenter.view = view
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
}


