//
//  GetProductCategoriesViewController.swift
//  SweetHomeWithSPM 2.0
//
//  Created by Aleksei Grachev on 21/12/22.
//  
//

import UIKit

protocol GetProductCategoriesViewInputProtocol: AnyObject {
    func updateViewWithProductCategories(productCategories: [ProductCategory])
    
}

class GetProductCategoriesViewController: UIViewController {
    // MARK: - Properties
    var presenter: GetProductCategoriesViewOutputProtocol?
    
    let categoriesTableView = UITableView()
    let identifier = "MyCell"
    
    var productCategories: [ProductCategory]?
    
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
    //create categories TableView
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
           // make.height.equalTo(90)
            //make.height.equalTo(20)
        }
      
    }
}

// MARK: - GetProductCategoriesViewInputProtocol
extension GetProductCategoriesViewController: GetProductCategoriesViewInputProtocol{
   
    func updateViewWithProductCategories(productCategories: [ProductCategory]){
        self.productCategories = productCategories
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension GetProductCategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = productCategories?[indexPath.item].category_name
        
//        switch indexPath {
//        case [0]:
//            cell.textLabel?.textColor = newMakerIsSaved ? Colors.activeButtonColor.colorViewUIColor : Colors.lightGrayButton.colorViewUIColor
//            cell.isUserInteractionEnabled = newMakerIsSaved
//        case [1]:
//            cell.textLabel?.textColor = categoriesIsSaved ? Colors.activeButtonColor.colorViewUIColor : Colors.lightGrayButton.colorViewUIColor
//            cell.isUserInteractionEnabled = categoriesIsSaved
//        default:
//            cell.textLabel?.textColor =  Colors.lightGrayButton.colorViewUIColor
//            cell.isUserInteractionEnabled = false
       // }
       // cell.accessoryType = .disclosureIndicator
        cell.accessoryType = .checkmark //checkBox.setImage(UIImage(named:"uncheck.png"), for: .normal)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  presenter?.isSelectedRowMenuTableView(indexRow: indexPath.row)
        guard let cell = tableView.cellForRow(at: indexPath) //as? MyCustomCell
        else {
                return
            }
        print(cell.textLabel?.text)
       // cell.accessoryType = .
    }
}
