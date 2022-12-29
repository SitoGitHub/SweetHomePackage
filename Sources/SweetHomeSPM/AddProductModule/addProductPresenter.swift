//
//  addProductPresenter.swift
//  Super easy dev
//
//  Created by Aleksei Grachev on 24/12/22
//
import UIKit

protocol AddProductViewOutputProtocol: AnyObject {
    func viewDidLoaded()
}

protocol AddProductInteractorOutputProtocol: AnyObject {
    
    
}

protocol AddProductCategoriesDelegate: AnyObject {
    
}


final class AddProductPresenter {
    weak var view: AddProductViewInputProtocol?
    var router: AddProductRouterInputProtocol
    var interactor: AddProductInteractorInputProtocol

    init(interactor: AddProductInteractorInputProtocol, router: AddProductRouterInputProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
}
// MARK: - AddProductViewOutputProtocol
extension AddProductPresenter: AddProductViewOutputProtocol {
    func viewDidLoaded(){
        if let image = UIImage(named: "underconstruction", in: .module, compatibleWith: nil) {
            view?.showMainImageView(image: image)
        }
        if let image = UIImage(named: "ng", in: .module, compatibleWith: nil) {
            view?.showCongratImageView(image: image)
        } 
    }
}

// MARK: - AddProductInteractorOutputProtocol
extension AddProductPresenter: AddProductInteractorOutputProtocol {
}

// MARK: - AddProductCategoriesDelegate
extension AddProductPresenter: AddProductCategoriesDelegate {
}
