//
//  FilterCategoriesPresenter.swift
// 
//
//  Created by Aleksei Grachev on 27/12/22
//
import Foundation

// MARK: - protocol FilterCategoriesViewOutputProtocol
protocol FilterCategoriesViewOutputProtocol: AnyObject {
    var numberOfRowsInSectionCategoriesView: Int { get }
    func ispressedProductCategoriesButton()
    func didSelectRowAt(index: Int) -> Bool
}
// MARK: - protocol FilterCategoriesViewOutputProtocol
protocol FilterCategoriesInteractorOutputProtocol: AnyObject {
    func fetchedProductCategoriesData(productCategories: [ProductCategory]?, error: Errors?)
}


// MARK: - class FilterCategoriesPresenter
final class FilterCategoriesPresenter {
    // MARK: Properties
    weak var view: FilterCategoriesViewInputProtocol?
    weak var delegate: FilterCategoriesModuleDelegate?
    var router: FilterCategoriesRouterInputProtocol
    var interactor: FilterCategoriesInteractorInputProtocol
    var numberOfCategories: Int?
    lazy var arrayCategoriesMakers = [String]()
    lazy var productCategories = [ProductCategory]()
    var categoriesViewModel: [(String, Bool)] = []
    // MARK: init
    init(interactor: FilterCategoriesInteractorInputProtocol, router: FilterCategoriesRouterInputProtocol, delegate: FilterCategoriesModuleDelegate?) {
        self.interactor = interactor
        self.router = router
        self.delegate = delegate
    }
}

// MARK: - private functions
extension FilterCategoriesPresenter {
    
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
}

// MARK: - extension FilterCategoriesViewOutputProtocol
extension FilterCategoriesPresenter: FilterCategoriesViewOutputProtocol {
    var numberOfRowsInSectionCategoriesView: Int {
        return numberOfCategories ?? 0
    }
    
    //запрос данных
    func ispressedProductCategoriesButton() {
        interactor.fetchCategoriesData()
    }
    
    //выделение и снятие выделения ячеек check and uncheck a cell
    func didSelectRowAt(index: Int) -> Bool {
        let productCategory = productCategories[index]
        let check = !categoriesViewModel[index].1
        if check, let productCategoryName = productCategory.category_name {
            arrayCategoriesMakers.append(productCategoryName)
        } else {
            arrayCategoriesMakers.removeAll { categoryRemoved in
                categoryRemoved == productCategory.category_name
            }
        }
        delegate?.fetchedFilterCategoriesData(filterListCategories: arrayCategoriesMakers)
        categoriesViewModel[index].1 = check
        return check
    }
}
// MARK: - extension FilterCategoriesInteractorOutputProtocol
extension FilterCategoriesPresenter: FilterCategoriesInteractorOutputProtocol {
    
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
        self.view?.updateSliderFilterCategoriesView(productCategories: categoriesViewModel)
    }
}
