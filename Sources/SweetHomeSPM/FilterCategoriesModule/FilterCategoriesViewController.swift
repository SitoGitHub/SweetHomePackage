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
}
// MARK: - FilterCategoriesViewController
final class FilterCategoriesViewController: UIViewController {
    // MARK: - Properties
    var presenter: FilterCategoriesViewOutputProtocol?
    var registrationView = UIView()

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
}

// MARK: - Private functions
private extension FilterCategoriesViewController {
    private func initialize() {
        view.backgroundColor = .clear
        addViewConstraints()
    }
    //create Registration View
    private func createRegistrationView() {
        registrationView.backgroundColor = Colors.registrationViewColor.colorViewUIColor //.lightGray
        registrationView.layer.cornerRadius = 10
        
        view.addSubview(registrationView)
    }
    
    private func addViewConstraints() {
        view.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(20)
            createRegistrationView()
        }
        
        registrationView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
            make.width.equalToSuperview().inset(5)
            make.height.equalToSuperview().multipliedBy(0.55)
        }
    }
}

// MARK: - FilterCategoriesViewProtocol
extension FilterCategoriesViewController: FilterCategoriesViewInputProtocol {
}
