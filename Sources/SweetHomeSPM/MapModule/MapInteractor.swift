//
//  MapInteractor.swift
//
//  AppDelegate.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 28/11/22.
//

public protocol MapInteractorInputProtocol: AnyObject {
   func fetchMakerData()
    func fetchCategoriesData ()
}

public class MapInteractor: MapInteractorInputProtocol {
    weak var presenter: MapInteractorOutputProtocol?
    let modelUser = ModelUser()
    var users = [[User]]()
    let coreDataManager = CoreDataManager.shared
   // var maker = Maker()
    
    deinit{
        print("MapInteractor deinit")
    }
    
    public func fetchMakerData() {
        let pinMakers = coreDataManager.getPinMaker()
        switch pinMakers {
        case.success(let pinMakers):
            self.presenter?.fetchedMakerData(pinMakers: pinMakers, error: nil)
            
        case .failure(let error):
            self.presenter?.fetchedMakerData(pinMakers: nil, error: error)
        }
    }
    
    //получение общего списка категорий продуктов
    public func fetchCategoriesData () {
        let productCategories = coreDataManager.getProductCategories(category: nil)
        switch productCategories {
        case.success(let productCategories):
            self.presenter?.fetchedProductCategoriesData(productCategories: productCategories, error: nil)
            
        case .failure(let error):
            self.presenter?.fetchedProductCategoriesData(productCategories: nil, error: error)
        }
  
    }
    
}
