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
     //RegistrationViewController
     {
        let view = RegistrationViewController()
        let interactor = RegistrationInteractor()
        let router = RegistrationRouter()
        
       //  var mapPresenter: RegistrationPresenterOutputProtocol? //= MapPresenter(interactor: MapInteractor(), router: MapRouter())
//         let mapView = MapViewController()
//         let mapInteractor = MapInteractor()
//         let mapRouter = MapRouter()
         
         let presenter = RegistrationPresenter(interactor: interactor, router: router,/* mapPresenter: mapPresenter, */  touchCoordinate: touchCoordinate, makerAnotation: makerAnotation)
         view.presenter = presenter
         presenter.delegate = delegate
         presenter.view = view
        // presenter.mapPresenter = mapPresenter
        interactor.presenter = presenter
        router.viewController = view
        return factory(view)
         //view
    }
}


// let mapPresenter = MapPresenter(interactor: mapInteractor, router: mapRouter)
// mapPresenter.view = mapView
//  mapView.presenter = mapPresenter
//  mapInteractor.presenter = mapPresenter
//  mapRouter.viewController = mapView
 
 // let mapPresenter = MapPresenter(interactor: <#MapInteractorInputProtocol#>, router: <#MapRouterInputProtocol#>)

