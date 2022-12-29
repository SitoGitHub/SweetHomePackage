//
//  FilterCategoriesPresenter.swift
// 
//
//  Created by Aleksei Grachev on 27/12/22
//

protocol FilterCategoriesViewOutputProtocol: AnyObject {
    
}

protocol FilterCategoriesInteractorOutputProtocol: AnyObject {
    
    
}

protocol FilterCategoriesDelegate: AnyObject {
    
}


final class FilterCategoriesPresenter {
    weak var view: FilterCategoriesViewInputProtocol?
    var router: FilterCategoriesRouterInputProtocol
    var interactor: FilterCategoriesInteractorInputProtocol

    init(interactor: FilterCategoriesInteractorInputProtocol, router: FilterCategoriesRouterInputProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension FilterCategoriesPresenter: FilterCategoriesViewOutputProtocol {
}

extension FilterCategoriesPresenter: FilterCategoriesInteractorOutputProtocol {
}

extension FilterCategoriesPresenter: FilterCategoriesDelegate {
}