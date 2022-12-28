//
//  GetProductCategoriesInteractor.swift
//  SweetHomeWithSPM 2.0
//
//  Created by Aleksei Grachev on 21/12/22.
//  
//

import Foundation
import MapKit

protocol GetProductCategoriesInteractorInputProtocol: AnyObject {
    func fetchCategoriesData(phoneMaker: String, emailMaker: String)
    func modifyCategoryProductMaker(check: Bool, index: Int, productCategory: ProductCategory, phoneMaker: String, emailMaker: String) -> Bool
    func reWriteMakerAnnotation()
}

class GetProductCategoriesInteractor: GetProductCategoriesInteractorInputProtocol {
    
    weak var presenter: GetProductCategoriesInteractorOutputProtocol?
    let coreDataManager = CoreDataManager.shared
    var maker = Maker()
    
    deinit{
        print("GetProductCategoriesInteractor deinit")
    }
    
    func fetchCategoriesData (phoneMaker: String, emailMaker: String) {
        
        //получение категорий продуктов мейкера
        let makers = coreDataManager.getMakerWithPhoneAndEmail(phoneNumber: phoneMaker, email: emailMaker)
        switch makers {
        case.success(let makers):
            for maker in makers{
                //  maker.addToMaker_product_categories(newCategoryProductMaker)
                self.maker = maker
            }
        case .failure(let error):
            self.presenter?.fetchedProductCategoriesMakerData(productCategoriesMakers: nil, error: error)
        }
        
        let productCategoriesMakers = coreDataManager.getProductCategoriesMakers(categoryName: nil, maker: maker)
        switch productCategoriesMakers {
        case.success(let productCategoriesMakers):
            self.presenter?.fetchedProductCategoriesMakerData(productCategoriesMakers: productCategoriesMakers, error: nil)
            
        case .failure(let error):
            self.presenter?.fetchedProductCategoriesMakerData(productCategoriesMakers: nil, error: error)
        }
        
        
        //получение общего списка категорий продуктов
        let productCategories = coreDataManager.getProductCategories(category: nil)
        switch productCategories {
        case.success(let productCategories):
            self.presenter?.fetchedProductCategoriesData(productCategories: productCategories, error: nil)
            
        case .failure(let error):
            self.presenter?.fetchedProductCategoriesData(productCategories: nil, error: error)
        }
    }
    
    
    func modifyCategoryProductMaker(check: Bool, index: Int, productCategory: ProductCategory, phoneMaker: String, emailMaker: String) -> Bool {
        var resultModifyCategory = false
        switch check {
        case true:
            let newCategoryProductMaker = ProductCategoryMaker()
            newCategoryProductMaker.category_name = productCategory.category_name
            //coreDataManager.saveContext()
            let makers = coreDataManager.getMakerWithPhoneAndEmail(phoneNumber: phoneMaker, email: emailMaker)
            switch makers {
            case.success(let makers):
                for maker in makers{
                    maker.addToMaker_product_categories(newCategoryProductMaker)
                    coreDataManager.saveContext()
                }
            case .failure(let error):
                self.presenter?.fetchedProductCategoriesMakerData(productCategoriesMakers: nil, error: error)
            }
            
            productCategory.addToProduct_categorie_maker(newCategoryProductMaker)
            resultModifyCategory = true
            coreDataManager.saveContext()
            reWriteMakerAnnotation()
        case false:
            let result: Result<Bool, Errors>
            let resultDelete = coreDataManager.deleteProductCategoriesMakers(categoryName: productCategory.category_name, maker: maker, productCategory: productCategory)
            result = resultDelete
            
            switch result {
            case.success(let result):
                resultModifyCategory = result
            case .failure(let error):
                self.presenter?.fetchedProductCategoriesData(productCategories: nil, error: error)
            }
            coreDataManager.saveContext()
        }
        return resultModifyCategory
    }
    
    //обновляем maker annotation для карты (список категорий)
    func reWriteMakerAnnotation() {
        var productCategoriesMaker: [ProductCategoryMaker] = []
        let productCategories = coreDataManager.getProductCategoriesMakers(categoryName: nil, maker: maker)
        switch productCategories {
        case.success(let productCategories):
            productCategoriesMaker = productCategories
        case .failure(let error):
            self.presenter?.fetchedProductCategoriesData(productCategories: nil, error: error)
        }
        //данные для созданияя пина на карте
        guard let name = maker.maker_name, let surname = maker.maker_surname, let phoneNumber = maker.phone_number, let email = maker.email, let password = maker.password else { return }
        let nameMaker = name
        let surnameMaker = surname
        let touchCoordinateMaker: CLLocationCoordinate2D
        let coordinateMaker = CLLocationCoordinate2D(
            latitude: maker.lat,
            longitude: maker.long)
        touchCoordinateMaker = coordinateMaker
        
        let phoneNumberMaker = phoneNumber
        let emailMaker = email
        let passwordMaker = password
        let pathImageMaker = maker.path_image
        
        let makerAnotation = MakerAnotation(surnameMaker: surnameMaker, nameMaker: nameMaker, phoneNumberMaker: phoneNumberMaker, emailMaker: emailMaker, passwordMaker: passwordMaker, pathImageMaker: pathImageMaker, coordinate: touchCoordinateMaker, productCategoriesMaker: productCategoriesMaker)
        self.presenter?.isWrittenMakerAnotation(makerAnotation: makerAnotation)
        
    }
}
