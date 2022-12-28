//
//  FilterCategoriesViewController.swift
// 
//
//  Created by Aleksei Grachev on 27/12/22
//

import UIKit
protocol FilterCategoriesViewInputProtocol: AnyObject {
}

class FilterCategoriesViewController: UIViewController {
    // MARK: - Public
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
    func initialize() {
        view.backgroundColor = .clear
        view.snp.makeConstraints { (make) -> Void in
           // make.centerX.equalToSuperview()
           // make.top.equalToSuperview().inset(20)
           // make.width.equalToSuperview().inset(5)
           // make.height.equalToSuperview().multipliedBy(0.55)
            make.height.equalTo(20)
            
            createRegistrationView()
        }
    }
    //create Registration View
    private func createRegistrationView() {
        registrationView.backgroundColor = Colors.registrationViewColor.colorViewUIColor //.lightGray
        registrationView.layer.cornerRadius = 10
        view.addSubview(registrationView)
        
        registrationView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
            make.width.equalToSuperview().inset(5)
            make.height.equalToSuperview().multipliedBy(0.55)
            //make.height.equalTo(20)
        }
    }
}

// MARK: - FilterCategoriesViewProtocol
extension FilterCategoriesViewController: FilterCategoriesViewInputProtocol {
}
