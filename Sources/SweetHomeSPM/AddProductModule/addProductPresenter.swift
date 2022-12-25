//
//  addProductPresenter.swift
//  Super easy dev
//
//  Created by Aleksei Grachev on 24/12/22
//
protocol AddProductViewOutputProtocol: AnyObject {
    
}

protocol AddProductInteractorOutputProtocol: AnyObject {
    
    
}

protocol AddProductCategoriesDelegate: AnyObject {
    
}


class AddProductPresenter {
    weak var view: AddProductViewInputProtocol?
    var router: AddProductRouterInputProtocol
    var interactor: AddProductInteractorInputProtocol

    init(interactor: AddProductInteractorInputProtocol, router: AddProductRouterInputProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    deinit{
        print("AddProductPresenter deinit")
    }
}
// MARK: - AddProductViewOutputProtocol
extension AddProductPresenter: AddProductViewOutputProtocol {
}

// MARK: - AddProductInteractorOutputProtocol
extension AddProductPresenter: AddProductInteractorOutputProtocol {
}
