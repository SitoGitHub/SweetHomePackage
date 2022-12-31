//
//  MapRouter.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 28/11/22.
//

import MapKit
import UIKit
// MARK: - MapRouterInputProtocol
protocol MapRouterInputProtocol {
    func openRegistrtionScreen(for touchCoordinate: CLLocationCoordinate2D, makerAnotation: MakerAnotation?)
    func presentWarnMessage(title: String?, descriptionText: String?)
    func openFilterCategoriesScreen()
}
// MARK: - MapRouter
final class MapRouter {
    weak var viewController: MapViewController?
    
}
// MARK: - MapRouterInputProtocol
extension MapRouter: MapRouterInputProtocol {
    
    func openRegistrtionScreen(for touchCoordinate: CLLocationCoordinate2D, makerAnotation: MakerAnotation?) {
        let vc = RegistrationModuleBuilder.build(factory: NavigationBuilder.build, delegate: viewController?.presenter as? RegistrationModuleDelegate, touchCoordinate: touchCoordinate, makerAnotation: makerAnotation)
        viewController?.present(vc, animated: true, completion: nil)
        
    }
    
    func openFilterCategoriesScreen() {
        let vc = FilterCategoriesModuleBuilder.build()
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
        viewController?.present(vc, animated: true, completion: nil)
        
    }
    
    func presentWarnMessage(title: String?, descriptionText: String?) {
        
        let alertController = UIAlertController(title: title,
                                                message: descriptionText,
                                                preferredStyle: .alert)
        
        let okBtn = UIAlertAction(title: "OK",
                                  style: .default,
                                  handler: nil)
        
        alertController.addAction(okBtn)
        
        viewController?.present(alertController,
                                animated: true,
                                completion: nil)
    }
}
