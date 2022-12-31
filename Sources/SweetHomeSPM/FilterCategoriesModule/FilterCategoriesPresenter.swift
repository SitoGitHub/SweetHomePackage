//
//  FilterCategoriesPresenter.swift
// 
//
//  Created by Aleksei Grachev on 27/12/22
//

// MARK: - protocol FilterCategoriesViewOutputProtocol
protocol FilterCategoriesViewOutputProtocol: AnyObject {
    
}
// MARK: - protocol FilterCategoriesViewOutputProtocol
protocol FilterCategoriesInteractorOutputProtocol: AnyObject {
    
    
}
// MARK: - protocol FilterCategoriesViewOutputProtocol
protocol FilterCategoriesDelegate: AnyObject {
    
}

// MARK: - class FilterCategoriesPresenter
final class FilterCategoriesPresenter {
    weak var view: FilterCategoriesViewInputProtocol?
    var router: FilterCategoriesRouterInputProtocol
    var interactor: FilterCategoriesInteractorInputProtocol
    // MARK: init
    init(interactor: FilterCategoriesInteractorInputProtocol, router: FilterCategoriesRouterInputProtocol) {
        self.interactor = interactor
        self.router = router
    }
}
// MARK: - extension FilterCategoriesViewOutputProtocol
extension FilterCategoriesPresenter: FilterCategoriesViewOutputProtocol {
}
// MARK: - extension FilterCategoriesInteractorOutputProtocol
extension FilterCategoriesPresenter: FilterCategoriesInteractorOutputProtocol {
}
// MARK: - extension FilterCategoriesDelegate
extension FilterCategoriesPresenter: FilterCategoriesDelegate {
}
