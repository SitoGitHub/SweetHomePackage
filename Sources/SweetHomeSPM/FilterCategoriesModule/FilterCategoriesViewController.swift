//
//  FilterCategoriesViewController.swift
// 
//
//  Created by Aleksei Grachev on 27/12/22
//

import UIKit
import SnapKit
// MARK: - FilterCategoriesViewInputProtocol
protocol FilterCategoriesViewInputProtocol: AnyObject {
    func updateSliderFilterCategoriesView(productCategories: [(String, Bool)])
}
// MARK: - FilterCategoriesViewController
final class FilterCategoriesViewController: UIViewController {
    // MARK: - Properties
    var presenter: FilterCategoriesViewOutputProtocol?
    let categoriesTableView = UITableView()
    let identifier = "MyCell"
    var productCategories: [(String, Bool)]? {
        didSet {
            categoriesTableView.reloadData()
        }
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.ispressedProductCategoriesButton()
    }
}

// MARK: - Private functions
private extension FilterCategoriesViewController {
    private func initialize() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        
        createCategoriesTableView()
        addViewConstraints()
    }
    //create Categories TableView
    private func createCategoriesTableView() {
        categoriesTableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        categoriesTableView.backgroundColor = .white
        categoriesTableView.layer.cornerRadius = 20
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        
        view.addSubview(categoriesTableView)
    }
    
    private func addViewConstraints() {
        
        categoriesTableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - FilterCategoriesViewInputProtocol
extension FilterCategoriesViewController: FilterCategoriesViewInputProtocol {
    func updateSliderFilterCategoriesView(productCategories: [(String, Bool)]) {
        self.productCategories = productCategories
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FilterCategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSectionCategoriesView ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = productCategories?[indexPath.item].0
        cell.accessoryType = productCategories?[indexPath.item].1 ?? false ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) //as? MyCustomCell
        else { return }
        let index = indexPath.row
        let check = presenter?.didSelectRowAt(index: index)
        cell.accessoryType = check ?? false ? .checkmark : .none
    }
}
