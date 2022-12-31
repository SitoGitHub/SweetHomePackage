//
//  FilterCategoriesInteractor.swift
// 
//
//  Created by Aleksei Grachev on 27/12/22
//
// MARK: - FilterCategoriesInteractorInputProtocol
protocol FilterCategoriesInteractorInputProtocol: AnyObject {
}

// MARK: - class FilterCategoriesInteractorOutputProtocol
final class FilterCategoriesInteractor {
    weak var presenter: FilterCategoriesInteractorOutputProtocol?
    
}

// MARK: - extension FilterCategoriesInteractorInputProtocol
extension FilterCategoriesInteractor: FilterCategoriesInteractorInputProtocol {
    
    
}
