//
//  FilterCategoriesInteractor.swift
// 
//
//  Created by Aleksei Grachev on 27/12/22
//
// MARK: - FilterCategoriesInteractorInputProtocol
protocol FilterCategoriesInteractorInputProtocol: AnyObject {
    func fetchCategoriesData ()
}

// MARK: - class FilterCategoriesInteractorOutputProtocol
final class FilterCategoriesInteractor {
    weak var presenter: FilterCategoriesInteractorOutputProtocol?
    let coreDataManager: CoreDataManagerProtocol
    // MARK: - init
    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
    }
    
}

// MARK: - extension FilterCategoriesInteractorInputProtocol
extension FilterCategoriesInteractor: FilterCategoriesInteractorInputProtocol {
    
    //получение общего списка категорий продуктов
    func fetchCategoriesData () {
        let productCategories = coreDataManager.getProductCategories()
        switch productCategories {
        case.success(let productCategories):
            self.presenter?.fetchedProductCategoriesData(productCategories: productCategories, error: nil)
            
        case .failure(let error):
            self.presenter?.fetchedProductCategoriesData(productCategories: nil, error: error)
        }
    }
    
}
