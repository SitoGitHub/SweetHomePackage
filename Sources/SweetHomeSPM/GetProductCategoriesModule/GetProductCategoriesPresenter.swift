//
//  GetProductCategoriesPresenter.swift
//  SweetHomeWithSPM 2.0
//
//  Created by Aleksei Grachev on 21/12/22.
//  
//

import Foundation

 protocol GetProductCategoriesInteractorOutputProtocol: AnyObject {
    
}


 protocol GetProductCategoriesViewOutputProtocol: AnyObject {
   
}


class GetProductCategoriesPresenter {

    // MARK: Properties
    weak var view: GetProductCategoriesViewInputProtocol?
    var router: GetProductCategoriesRouterInputProtocol
    var interactor: GetProductCategoriesInteractorInputProtocol
    
    
     init(interactor: GetProductCategoriesInteractorInputProtocol, router: GetProductCategoriesRouterInputProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    deinit{
        print("MapPresenter deinit")
    }
    
}

extension GetProductCategoriesPresenter: GetProductCategoriesInteractorOutputProtocol {
}
extension GetProductCategoriesPresenter: GetProductCategoriesViewOutputProtocol {
    
}
