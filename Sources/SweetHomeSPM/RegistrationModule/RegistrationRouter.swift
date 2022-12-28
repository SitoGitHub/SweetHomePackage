//
//  RegistrationRouter.swift
//  
//
//  Created by Aleksei Grachev on 13/12/22.
//
import UIKit

protocol RegistrationRouterInputProtocol {
    func presentWarnMessage(title: String?, descriptionText: String?)
    func pushGetProductCategoriesViewController(to navigationController: UINavigationController, animated: Bool, phoneMaker: String, emailMaker: String)
    func pushAddProductViewController(to navigationController: UINavigationController, animated: Bool)
}

class RegistrationRouter: RegistrationRouterInputProtocol {
    weak var viewController: RegistrationViewController?
    weak var navigationController: UINavigationController?
    
    func pushGetProductCategoriesViewController(to navigationController: UINavigationController, animated: Bool, phoneMaker: String, emailMaker: String) {
        self.navigationController = navigationController
        navigationController.pushViewController(GetProductCategoriesBuilder.build(phoneMaker: phoneMaker, emailMaker: emailMaker, delegate: viewController?.presenter as? GetProductCategoriesDelegate), animated: animated)
    }
    
    func pushAddProductViewController(to navigationController: UINavigationController, animated: Bool) {
        self.navigationController = navigationController
        navigationController.pushViewController(AddProductModuleBuilder.build(), animated: animated)
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
