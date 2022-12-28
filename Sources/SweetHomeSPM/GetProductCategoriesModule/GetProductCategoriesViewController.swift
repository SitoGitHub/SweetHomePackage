//
//  GetProductCategoriesViewController.swift
//  SweetHomeWithSPM 2.0
//
//  Created by Aleksei Grachev on 21/12/22.
//  
//

import UIKit

protocol GetProductCategoriesViewInputProtocol: AnyObject {
    // func updateViewWithProductCategories(productCategories: [ProductCategory])
    func stopActivityIndicator()
    func updateViewWithProductCategories(productCategories: [(String, Bool)])
}

class GetProductCategoriesViewController: UIViewController {
    // MARK: - Properties
    var presenter: GetProductCategoriesViewOutputProtocol?
    
    let categoriesTableView = UITableView()
    let identifier = "MyCell"
    lazy var categoryName = String()
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    var productCategories: [(String, Bool)]? {
        didSet {
            categoriesTableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            presenter?.isDeinitedModule()
        }
    }
  
}

// MARK: - Private functions
extension GetProductCategoriesViewController {
    func initialize() {
        self.title = "Категории"
        
        view.backgroundColor = .white
        presenter?.viewDidLoaded()
        createCategoriesTableView()
        configureActivityIndicator()
    }
    
    private func configureActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) -> Void in
            // make.centerX.equalToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().inset(100)
        }
        
        activityIndicator.color = Colors.activeButtonColor.colorViewUIColor
    }
    
    // stop activityIndicator
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    //create Categories TableView
    private func createCategoriesTableView() {
        
        categoriesTableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        //menuTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        categoriesTableView.backgroundColor = .white
        
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        
        view.addSubview(categoriesTableView)
        
        categoriesTableView.snp.makeConstraints { (make) -> Void in
            // make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().inset(80)
        }
        activityIndicator.startAnimating()
    }
}

// MARK: - GetProductCategoriesViewInputProtocol
extension GetProductCategoriesViewController: GetProductCategoriesViewInputProtocol{
    
    func updateViewWithProductCategories(productCategories: [(String, Bool)]) {
        self.productCategories = productCategories
        //   categoriesTableView.reloadData()
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension GetProductCategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection ?? 0
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
