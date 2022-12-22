//
//  GetProductCategoriesPresenter.swift
//  SweetHomeWithSPM 2.0
//
//  Created by Aleksei Grachev on 21/12/22.
//  
//

import Foundation

 protocol GetProductCategoriesInteractorOutputProtocol: AnyObject {
     func fetchedProductCategoriesData(productCategories: [ProductCategory]?, error: Errors?)
}


 protocol GetProductCategoriesViewOutputProtocol: AnyObject {
     func viewDidLoaded()
     
     var numberOfRowsInSection: Int { get }
}


class GetProductCategoriesPresenter {

    // MARK: Properties
    weak var view: GetProductCategoriesViewInputProtocol?
    var router: GetProductCategoriesRouterInputProtocol
    var interactor: GetProductCategoriesInteractorInputProtocol
    var numberOfCategories: Int?
    
     init(interactor: GetProductCategoriesInteractorInputProtocol, router: GetProductCategoriesRouterInputProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    deinit{
        print("GetProductCategoriesPresenter deinit")
    }
    
}

extension GetProductCategoriesPresenter: GetProductCategoriesInteractorOutputProtocol {
    func fetchedProductCategoriesData(productCategories: [ProductCategory]?, error: Errors?) {
        
        guard let productCategories = productCategories, error == nil else {
            switch error {
            case .loadProdactCategoryError:
                router.presentWarnMessage(title: "Возникла ошибка базы данных",
                                         descriptionText: "Возникла ошибка при извлечении категорий продуктов")
           
            default:
                return
            }
            return
        }
        numberOfCategories = productCategories.count
        DispatchQueue.main.async { [unowned self] in
            self.view?.updateViewWithProductCategories(productCategories: productCategories)
        }
    }
}
extension GetProductCategoriesPresenter: GetProductCategoriesViewOutputProtocol {
    
    var numberOfRowsInSection: Int {
        return numberOfCategories ?? 0
    }
    
    
    func viewDidLoaded() {
        interactor.fetchCategoriesData()
    }
}
