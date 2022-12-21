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
    }

   
}

extension GetProductCategoriesViewController: GetProductCategoriesViewInputProtocol{
    // TODO: Implement View Output Methods
}
