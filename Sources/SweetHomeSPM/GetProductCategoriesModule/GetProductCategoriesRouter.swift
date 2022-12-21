//
//  GetProductCategoriesRouter.swift
//  SweetHomeWithSPM 2.0
//
//  Created by Aleksei Grachev on 21/12/22.
//  
//

import Foundation
import UIKit

class GetProductCategoriesRouter: PresenterToRouterGetProductCategoriesProtocol {
    
    // MARK: Static methods
    static func createModule() -> UIViewController {
        
        let viewController = GetProductCategoriesViewController()
        
        let presenter: ViewToPresenterGetProductCategoriesProtocol & InteractorToPresenterGetProductCategoriesProtocol = GetProductCategoriesPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = GetProductCategoriesRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = GetProductCategoriesInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
}
