//
//  RegistrationRouter.swift
//  
//
//  Created by Aleksei Grachev on 13/12/22.
//
import UIKit

protocol RegistrationRouterInputProtocol {
    func presentWarnMessage(title: String?, descriptionText: String?)
    func pushViewController(to navigationController: UINavigationController, animated: Bool, maker: Maker)
}

class RegistrationRouter: RegistrationRouterInputProtocol {
    weak var viewController: RegistrationViewController?
    var navigationController: UINavigationController?
    
    deinit{
        print("RegistrationRouter deinit")
    }
    
    
   // weak var presentedViewController: ModuleViewController?

    func pushViewController(to navigationController: UINavigationController, animated: Bool, maker: Maker) {
        self.navigationController = navigationController
//        guard let newViewController = presentedViewController else { return }
        navigationController.pushViewController(GetProductCategoriesBuilder.build(maker: maker), animated: animated)
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
