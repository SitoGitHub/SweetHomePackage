//
//  GetProductCategoriesRouter.swift
//  SweetHomeWithSPM 2.0
//
//  Created by Aleksei Grachev on 21/12/22.
//  
//
import UIKit
// MARK: - GetProductCategoriesRouterInputProtocol
protocol GetProductCategoriesRouterInputProtocol {
    func presentWarnMessage(title: String?, descriptionText: String?)
}
// MARK: - class GetProductCategoriesRouter
final class GetProductCategoriesRouter {
    weak var viewController: GetProductCategoriesViewController?
}
// MARK: - GetProductCategoriesRouterInputProtocol
extension GetProductCategoriesRouter: GetProductCategoriesRouterInputProtocol {
    
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
