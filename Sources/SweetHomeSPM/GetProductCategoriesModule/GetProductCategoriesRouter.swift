//
//  GetProductCategoriesRouter.swift
//  SweetHomeWithSPM 2.0
//
//  Created by Aleksei Grachev on 21/12/22.
//  
//

import Foundation
import UIKit

protocol GetProductCategoriesRouterInputProtocol {
    func presentWarnMessage(title: String?, descriptionText: String?)
}

class GetProductCategoriesRouter: GetProductCategoriesRouterInputProtocol {
    weak var viewController: GetProductCategoriesViewController?
    
    deinit{
        print("GetProductCategoriesRouter deinit")
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
