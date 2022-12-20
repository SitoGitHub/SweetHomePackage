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
        
       //  let mapInteractor = MapInteractor()
       //  let mapRouter = MapRouter()
        // let mapPresenter = MapPresenter(interactor: mapInteractor, router: mapRouter)
        
         // let mapPresenter = MapPresenter(interactor: <#MapInteractorInputProtocol#>, router: <#MapRouterInputProtocol#>)
         let presenter = RegistrationPresenter(interactor: interactor, router: router,/* mapPresenter: mapPresenter, */  touchCoordinate: touchCoordinate)
         view.presenter = presenter
         presenter.view = view
        // presenter.mapPresenter = mapPresenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
}


