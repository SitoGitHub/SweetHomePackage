//
//  addProductViewController.swift
//  Super easy dev
//
//  Created by Aleksei Grachev on 24/12/22
//

import UIKit


protocol AddProductViewInputProtocol: AnyObject {
}

class AddProductViewController: UIViewController {
    // MARK: - Public
    var presenter: AddProductViewOutputProtocol?

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    deinit{
        print("AddProductViewController deinit")
    }
}

// MARK: - Private functions
private extension AddProductViewController {
    func initialize() {
    }
}

// MARK: - AddProductViewInputProtocol
extension AddProductViewController: AddProductViewInputProtocol {
}
