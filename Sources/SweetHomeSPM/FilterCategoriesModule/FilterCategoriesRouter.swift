//
//  FilterCategoriesRouter.swift
//
//
//  Created by Aleksei Grachev on 27/12/22
//

protocol FilterCategoriesRouterInputProtocol {
}

class FilterCategoriesRouter: FilterCategoriesRouterInputProtocol {
    weak var viewController: FilterCategoriesViewController?
    
    deinit{
        print("FilterCategoriesRouter deinit")
    }
}
