//
//  addProductModuleBuilder.swift
//  Super easy dev
//
//  Created by Aleksei Grachev on 24/12/22
//

import UIKit

final class AddProductModuleBuilder {
    static func build() -> AddProductViewController {
        let interactor = AddProductInteractor()
        let router = AddProductRouter()
        let presenter = AddProductPresenter(interactor: interactor, router: router)
        let view = AddProductViewController()
        presenter.view  = view
        view.presenter = presenter
        interactor.presenter = presenter
        router.view = view
        return view
    }
}
