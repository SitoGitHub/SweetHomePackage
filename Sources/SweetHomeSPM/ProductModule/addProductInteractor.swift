//
//  addProductInteractor.swift
//  Super easy dev
//
//  Created by Aleksei Grachev on 24/12/22
//

protocol AddProductInteractorInputProtocol: AnyObject {
}

class AddProductInteractor: AddProductInteractorInputProtocol {
    weak var presenter: AddProductInteractorOutputProtocol?
    
    deinit{
        print("AddProductInteractor deinit")
    }
}
