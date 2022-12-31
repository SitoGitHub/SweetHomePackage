//
//  FilterCategoriesModuleBuilder.swift
//
//
//  Created by Aleksei Grachev on 27/12/22
//

import UIKit

// MARK: - FilterCategoriesModuleBuilder
final class FilterCategoriesModuleBuilder {
    static func build() -> FilterCategoriesViewController {
        let interactor = FilterCategoriesInteractor()
        let router = FilterCategoriesRouter()
        let presenter = FilterCategoriesPresenter(interactor: interactor, router: router)
        let view = FilterCategoriesViewController()
        presenter.view = view
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
}
