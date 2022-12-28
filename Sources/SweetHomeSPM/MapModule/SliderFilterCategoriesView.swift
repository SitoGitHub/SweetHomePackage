//
//  File.swift
//  
//
//  Created by Aleksei Grachev on 26/12/22.
//

import Foundation
import UIKit

class SliderFilterCategoriesView: UIView {
    
    let categoriesTableView: UITableView
    let identifier = "MyCell"
    
    init(tableView: UITableView) {
        categoriesTableView = tableView
        
        super.init(frame: .zero)
        setupView()
        createCategoriesTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
    }
    
    private func createCategoriesTableView() {
        
        categoriesTableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        categoriesTableView.backgroundColor = .white
        
        self.addSubview(categoriesTableView)
        
        categoriesTableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
}


