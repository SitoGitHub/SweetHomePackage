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
     func isWrittenMakerAnotation(makerAnotation: MakerAnotation)
}


 protocol GetProductCategoriesViewOutputProtocol: AnyObject {
     func viewDidLoaded()
     func didSelectRowAt(index: Int) -> Bool
    // func saveDataMakerCategory()
     func isDeinitedModule()
     var numberOfRowsInSection: Int { get }
}


class GetProductCategoriesPresenter {

    // MARK: Properties
    weak var view: GetProductCategoriesViewInputProtocol?
    var router: GetProductCategoriesRouterInputProtocol
    var interactor: GetProductCategoriesInteractorInputProtocol
    weak var delegate: GetProductCategoriesDelegate?
   // weak var delegate: GetProductMapDelegate?
    //var maker: Maker
    var phoneMaker: String
    var emailMaker: String
    var numberOfCategories: Int?
    lazy var arrayCategoriesMakers = [String]()
    var categoriesViewModel: [(String, Bool)] = []
    lazy var productCategories = [ProductCategory]()
    var isCheckedCount = 0
    var isChangedProductCategoriesMaker = false {
        didSet {
            delegate?.isChangedProductCategoriesMakers(isChanged: isChangedProductCategoriesMaker)
        }
    }
    
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
        isChangedProductCategoriesMaker = arrayCategoriesMakers.count > 0
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.view?.updateViewWithProductCategories(productCategories: self.categoriesViewModel)
            self.view?.stopActivityIndicator()
        }
      //  }
    }
    
    //create ViewModel for tableView
    func makeCategoriesViewModel(productCategories: [ProductCategory]) -> [(String, Bool)] {
    //    var isChanged = false
        return productCategories.map { productCategory in
            var categoryName = String()
            var check = Bool()
            if let category = productCategory.category_name {
                categoryName = category
                check = arrayCategoriesMakers.contains(categoryName)
//                if check == true {
//                    isChanged = true
//                }
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
    //передаем обновленный makerAnotation в Map module in the presenter
    func isWrittenMakerAnotation(makerAnotation: MakerAnotation) {
        self.delegate?.IsWrittenMakerAnnotation(pinMakers: [makerAnotation])
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
       // let categoryName = categoriesViewModel[index].0
        let productCategory = productCategories[index]
        var check = !categoriesViewModel[index].1
        
        let resultModify = interactor.modifyCategoryProductMaker(check: check, index: index, productCategory: productCategory, phoneMaker: phoneMaker, emailMaker: emailMaker)
        if resultModify == false {
            check = !check
        }
        isCheckedCount = check ? isCheckedCount + 1 : isCheckedCount - 1
        isChangedProductCategoriesMaker = isCheckedCount > 0
        categoriesViewModel[index].1 = check
        return check
    }

//    //при деините модуля формируем новый Maker Annotation
        func isDeinitedModule() {
            interactor.reWriteMakerAnnotation()
        }
}
