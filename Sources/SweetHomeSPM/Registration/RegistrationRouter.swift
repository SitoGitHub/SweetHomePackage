//
//  RegistrationRouter.swift
//  
//
//  Created by Aleksei Grachev on 13/12/22.
//
import UIKit

protocol RegistrationRouterInputProtocol {
    func presentWarnMessage(title: String?, descriptionText: String?)
}

class RegistrationRouter: RegistrationRouterInputProtocol {
    weak var viewController: RegistrationViewController?
    
    deinit{
        print("RegistrationRouter deinit")
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
