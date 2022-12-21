//
//  GetProductCategoriesViewController.swift
//  SweetHomeWithSPM 2.0
//
//  Created by Aleksei Grachev on 21/12/22.
//  
//

import UIKit

protocol GetProductCategoriesViewInputProtocol: AnyObject {
    
}

class GetProductCategoriesViewController: UIViewController {
    // MARK: - Properties
    var presenter: GetProductCategoriesViewOutputProtocol?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    deinit{
        print("GetProductCategoriesViewController deinit")
    }
   
}

// MARK: - Private functions
extension GetProductCategoriesViewController {
    func initialize() {
        self.title = "Категории продуктов"
        view.backgroundColor = .white
        
    }
}

extension GetProductCategoriesViewController: GetProductCategoriesViewInputProtocol{
    // TODO: Implement View Output Methods
}
