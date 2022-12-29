//
//  addProductInteractor.swift
//  Super easy dev
//
//  Created by Aleksei Grachev on 24/12/22
//

protocol AddProductInteractorInputProtocol: AnyObject {
}

final class AddProductInteractor: AddProductInteractorInputProtocol {
    weak var presenter: AddProductInteractorOutputProtocol?
    
    
}
