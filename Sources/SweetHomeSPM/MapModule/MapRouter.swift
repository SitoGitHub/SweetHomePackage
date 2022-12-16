//
//  MapRouter.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 28/11/22.
//

import MapKit

public protocol MapRouterProtocol {
    func openRegistrtionScreen(for touchCoordinate: CLLocationCoordinate2D)
}

public class MapRouter: MapRouterProtocol {
    weak var viewController: MapViewController?
    
    public func openRegistrtionScreen(for touchCoordinate: CLLocationCoordinate2D) {
        let vc = RegistrationModuleBuilder.build(touchCoordinate: touchCoordinate)
        viewController?.present(vc, animated: true, completion: nil)
    }
    
}
