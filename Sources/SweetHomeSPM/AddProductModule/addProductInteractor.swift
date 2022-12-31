//
//  addProductInteractor.swift
//  Super easy dev
//
//   Created by Aleksei Grachev on 21/12/22.
//
// MARK: - AddProductInteractorInputProtocol
protocol AddProductInteractorInputProtocol: AnyObject {
}
// MARK: - AddProductInteractor
final class AddProductInteractor {
    // MARK: - Properties
    weak var presenter: AddProductInteractorOutputProtocol?
    
}
// MARK: - AddProductInteractorInputProtocol
extension AddProductInteractor: AddProductInteractorInputProtocol {
    
}
