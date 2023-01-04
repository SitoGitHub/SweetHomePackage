//
//  FilterCategoriesModuleBuilder.swift
//
//
//  Created by Aleksei Grachev on 27/12/22
//

import UIKit

// MARK: - FilterCategoriesModuleBuilder
final class FilterCategoriesModuleBuilder {
    static func build(delegate: FilterCategoriesModuleDelegate?) -> FilterCategoriesViewController {
        let coreDataManager = CoreDataManager.shared
        let interactor = FilterCategoriesInteractor(coreDataManager: coreDataManager)
        let router = FilterCategoriesRouter()
        let presenter = FilterCategoriesPresenter(interactor: interactor, router: router, delegate: delegate)
        let view = FilterCategoriesViewController()
        presenter.view = view
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
}
