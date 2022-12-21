//
//  GetProductCategoriesInteractor.swift
//  SweetHomeWithSPM 2.0
//
//  Created by Aleksei Grachev on 21/12/22.
//  
//

import Foundation

 protocol GetProductCategoriesInteractorInputProtocol: AnyObject {
   
}

class GetProductCategoriesInteractor: GetProductCategoriesInteractorInputProtocol {
    weak var presenter: GetProductCategoriesInteractorOutputProtocol?
    
    deinit{
        print("GetProductCategoriesInteractor deinit")
    }
}
