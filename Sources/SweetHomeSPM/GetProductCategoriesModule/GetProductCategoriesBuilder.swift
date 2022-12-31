//
//  GetProductCategoriesBuilder.swift
//  SweetHomeWithSPM 2.0
//
//  Created by Aleksei Grachev on 21/12/22.
//  
//

// MARK: - GetProductCategoriesBuilder
final class GetProductCategoriesBuilder {
    static func build(phoneMaker: String, emailMaker: String, delegate: GetProductCategoriesDelegate?) -> GetProductCategoriesViewController {
        let coreDataManager = CoreDataManager.shared
        let view = GetProductCategoriesViewController()
        let interactor = GetProductCategoriesInteractor(coreDataManager: coreDataManager)
        let router = GetProductCategoriesRouter()
        let presenter = GetProductCategoriesPresenter(interactor: interactor, router: router, phoneMaker: phoneMaker, emailMaker: emailMaker)
        view.presenter = presenter
        presenter.view = view
        presenter.delegate = delegate
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
}

