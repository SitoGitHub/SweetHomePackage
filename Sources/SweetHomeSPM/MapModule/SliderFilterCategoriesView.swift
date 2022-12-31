//
//  File.swift
//  
//
//  Created by Aleksei Grachev on 26/12/22.
//
import UIKit
// MARK: - SliderFilterCategoriesView
final class SliderFilterCategoriesView: UIView {
    // MARK: - properties
    let categoriesTableView: UITableView
    let identifier = "MyCell"
    // MARK: - init
    init(tableView: UITableView) {
        categoriesTableView = tableView
        
        super.init(frame: .zero)
        setupView()
        createCategoriesTableView()
        addViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private functions
    private func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
    }
    
    private func createCategoriesTableView() {
        categoriesTableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        categoriesTableView.backgroundColor = .white
        
        self.addSubview(categoriesTableView)
    }
    
    private func addViewConstraints() {
        categoriesTableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
}


