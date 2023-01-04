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
    func removeFilterCategoriesScreen()
}
// MARK: - MapRouter
final class MapRouter {
    weak var viewController: MapViewController?
    lazy var filterCategoriesViewController = FilterCategoriesModuleBuilder.build(delegate: viewController?.presenter as? FilterCategoriesModuleDelegate)
    
    lazy var indentOfRightForSliderFilterCategoriesView: CGFloat = 80
    
}
// MARK: - MapRouterInputProtocol
extension MapRouter: MapRouterInputProtocol {
    
    func openRegistrtionScreen(for touchCoordinate: CLLocationCoordinate2D, makerAnotation: MakerAnotation?) {
        let vc = RegistrationModuleBuilder.build(factory: NavigationBuilder.build, delegate: viewController?.presenter as? RegistrationModuleDelegate, touchCoordinate: touchCoordinate, makerAnotation: makerAnotation)
        viewController?.present(vc, animated: true, completion: nil)
        
    }
    
    func openFilterCategoriesScreen() {

        viewController?.addChild(filterCategoriesViewController)
        viewController?.view.addSubview(filterCategoriesViewController.view)
        filterCategoriesViewController.didMove(toParent: viewController)
        let viewWidth = viewController?.view.bounds.width
        if let parentVC = viewController {
            filterCategoriesViewController.view.snp.makeConstraints { (make) -> Void in
                make.left.equalToSuperview()
                make.top.equalTo(parentVC.filterCategoriesButton.snp.bottom)
                make.bottom.equalToSuperview()
                make.width.equalTo(viewWidth! - indentOfRightForSliderFilterCategoriesView)
            }
        }
    }
    
    func removeFilterCategoriesScreen() {
        filterCategoriesViewController.willMove(toParent: nil)
        filterCategoriesViewController.view.removeFromSuperview()
        filterCategoriesViewController.removeFromParent()
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
