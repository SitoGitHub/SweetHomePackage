//
//  GetProductCategoriesInteractor.swift
//  SweetHomeWithSPM 2.0
//
//  Created by Aleksei Grachev on 21/12/22.
//  
//

import Foundation

 protocol GetProductCategoriesInteractorInputProtocol: AnyObject {
     func fetchCategoriesData()
}

class GetProductCategoriesInteractor: GetProductCategoriesInteractorInputProtocol {
    weak var presenter: GetProductCategoriesInteractorOutputProtocol?
    var coreDataManager = CoreDataManager()
    
    deinit{
        print("GetProductCategoriesInteractor deinit")
    }
    
    func fetchCategoriesData() {
//           dateService.getDate { [weak self] date in
//               self?.presenter?.didLoadDate(date: date.description)
//           }
        let productCategories = coreDataManager.getProductCategories(category: nil)
        switch productCategories {
        case.success(let productCategories):
            self.presenter?.fetchedProductCategoriesData(productCategories: productCategories, error: nil)
            
        case .failure(let error):
            self.presenter?.fetchedProductCategoriesData(productCategories: nil, error: error)
        }

        
        
//        self.users = modelUser.users
//        self.presenter?.didLoadDate(users: users)
        
//        for user in modelUser.users.first!{
//            mapView.addAnnotation(user)
//        }
        
       }
    
}
