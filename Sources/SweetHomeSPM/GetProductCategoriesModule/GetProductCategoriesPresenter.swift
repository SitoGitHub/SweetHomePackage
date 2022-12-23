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
     func fetchedProductCategoriesMakerData(productCategoriesMakers: [ProductCategoryMaker]?, error: Errors?)
}


 protocol GetProductCategoriesViewOutputProtocol: AnyObject {
     func viewDidLoaded()
     func didSelectRowAt(index: Int) -> Bool
     func saveDataMakerCategory()
     
     var numberOfRowsInSection: Int { get }
}


class GetProductCategoriesPresenter {

    // MARK: Properties
    weak var view: GetProductCategoriesViewInputProtocol?
    var router: GetProductCategoriesRouterInputProtocol
    var interactor: GetProductCategoriesInteractorInputProtocol
    //var maker: Maker
    var phoneMaker: String
    var emailMaker: String
    var numberOfCategories: Int?
    lazy var arrayCategoriesMakers = [String]()
    var categoriesViewModel: [(String, Bool)] = []
    lazy var productCategories = [ProductCategory]()
    
    init(interactor: GetProductCategoriesInteractorInputProtocol, router: GetProductCategoriesRouterInputProtocol, phoneMaker: String, emailMaker: String) {
        self.interactor = interactor
        self.router = router
        //self.maker = maker
        self.phoneMaker = phoneMaker
        self.emailMaker = emailMaker
    }
    
    deinit{
        print("GetProductCategoriesPresenter deinit")
    }
    
}

extension GetProductCategoriesPresenter: GetProductCategoriesInteractorOutputProtocol {
    
    func fetchedProductCategoriesMakerData(productCategoriesMakers: [ProductCategoryMaker]?, error: Errors?) {
        guard let productCategoriesMakers = productCategoriesMakers, error == nil else {
                router.presentWarnMessage(title: "Возникла ошибка базы данных",
                                         descriptionText: "Возникла ошибка при извлечении списка категорий продуктов поставщика")
            return
        }
        self.arrayCategoriesMakers = makeCategoriesMaker(productCategoriesMaker: productCategoriesMakers)
       // productCategoriesMakers[0].managedObjectContext?.delete(productCategoriesMakers[0])
    }
    
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
        self.productCategories = productCategories
        categoriesViewModel = makeCategoriesViewModel(productCategories: productCategories)
        
      //  DispatchQueue.main.async { [unowned self] in
         //   self.view?.updateViewWithProductCategories(productCategories: [productCategories])
        self.view?.updateViewWithProductCategories(productCategories: categoriesViewModel)
     //       }
      //  }
    }
    
    //create ViewModel for tableView
    func makeCategoriesViewModel(productCategories: [ProductCategory]) -> [(String, Bool)] {
        return productCategories.map { productCategory in
            var categoryName = String()
            var check = Bool()
            if let category = productCategory.category_name {
                categoryName = category
                check = arrayCategoriesMakers.contains(categoryName)
            }
            return (categoryName, check)
        }
    }
    
    //create array of Maker's categories name
    func makeCategoriesMaker(productCategoriesMaker: [ProductCategoryMaker]) -> [String] {
        return productCategoriesMaker.map { productCategoryMaker in
            var categoryNameMaker = String()
            if let category = productCategoryMaker.category_name {
                categoryNameMaker = category
            }
            return (categoryNameMaker)
        }
    }
}

extension GetProductCategoriesPresenter: GetProductCategoriesViewOutputProtocol {
    
    var numberOfRowsInSection: Int {
        return numberOfCategories ?? 0
    }
    
    //запрос данных
    func viewDidLoaded() {
        interactor.fetchCategoriesData(phoneMaker: phoneMaker, emailMaker: emailMaker)
    }
    
    //выделение и снятие выделения ячеек check and uncheck a cell
    func didSelectRowAt(index: Int) -> Bool {
        let categoryName = categoriesViewModel[index].0
        let productCategory = productCategories[index]
        var check = !categoriesViewModel[index].1
        
        let resultModify = interactor.modifyCategoryProductMaker(check: check, index: index, productCategory: productCategory, phoneMaker: phoneMaker, emailMaker: emailMaker)
        if resultModify == false {
            check = !check
        }
        categoriesViewModel[index].1 = check
        return check
    }

    //обработка нажатия конпки SaveButton
        func saveDataMakerCategory() {
           // interactor.saveDataNewMaker(categoriesViewModel)
        }
}
