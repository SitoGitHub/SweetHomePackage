//
//  GetProductCategoriesBuilder.swift
//  SweetHomeWithSPM 2.0
//
//  Created by Aleksei Grachev on 21/12/22.
//  
//


 class GetProductCategoriesBuilder {
    //@discardableResult
     public static func build(phoneMaker: String, emailMaker: String, delegate: GetProductCategoriesDelegate?) -> GetProductCategoriesViewController {
        let view = GetProductCategoriesViewController()
        let interactor = GetProductCategoriesInteractor()
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

