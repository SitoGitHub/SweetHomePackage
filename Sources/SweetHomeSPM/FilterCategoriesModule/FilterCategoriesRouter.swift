//
//  FilterCategoriesRouter.swift
//
//
//  Created by Aleksei Grachev on 27/12/22
//
import UIKit

// MARK: - protocol FilterCategoriesRouterInputProtocol
protocol FilterCategoriesRouterInputProtocol {
    func presentWarnMessage(title: String?, descriptionText: String?) 
}
// MARK: - class FilterCategoriesRouter
final class FilterCategoriesRouter {
    weak var viewController: FilterCategoriesViewController?
  
}
// MARK: - extension FilterCategoriesRouterInputProtocol
extension FilterCategoriesRouter: FilterCategoriesRouterInputProtocol {
    
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
