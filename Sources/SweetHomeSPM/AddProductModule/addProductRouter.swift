//
//  addProductRouter.swift
//  Super easy dev
//
//  Created by Aleksei Grachev on 24/12/22
//
// MARK: - AddProductRouterInputProtocol
protocol AddProductRouterInputProtocol {
}
// MARK: - AddProductRouter
final class AddProductRouter {
    // MARK: - Properties
    weak var view: AddProductViewController?
}
// MARK: - AddProductRouterInputProtocol
extension AddProductRouter: AddProductRouterInputProtocol {
    
}
