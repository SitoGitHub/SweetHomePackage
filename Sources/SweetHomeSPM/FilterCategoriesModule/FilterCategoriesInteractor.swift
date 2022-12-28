//
//  FilterCategoriesInteractor.swift
// 
//
//  Created by Aleksei Grachev on 27/12/22
//

protocol FilterCategoriesInteractorInputProtocol: AnyObject {
}

class FilterCategoriesInteractor: FilterCategoriesInteractorInputProtocol {
    weak var presenter: FilterCategoriesInteractorOutputProtocol?
    
    deinit{
        print("FilterCategoriesInteractor deinit")
    }
}
