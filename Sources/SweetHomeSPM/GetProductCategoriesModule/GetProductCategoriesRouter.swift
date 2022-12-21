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
  
}

class GetProductCategoriesRouter: GetProductCategoriesRouterInputProtocol {
    weak var viewController: GetProductCategoriesViewController?
    
    deinit{
        print("GetProductCategoriesRouter deinit")
    }
    
    
}
