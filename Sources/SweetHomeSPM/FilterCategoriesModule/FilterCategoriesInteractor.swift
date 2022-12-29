//
//  FilterCategoriesInteractor.swift
// 
//
//  Created by Aleksei Grachev on 27/12/22
//

protocol FilterCategoriesInteractorInputProtocol: AnyObject {
}

final class FilterCategoriesInteractor {
    weak var presenter: FilterCategoriesInteractorOutputProtocol?
    
}

extension FilterCategoriesInteractor: FilterCategoriesInteractorInputProtocol {
    
    
}
