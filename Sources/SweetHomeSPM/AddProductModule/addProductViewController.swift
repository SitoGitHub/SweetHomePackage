//
//  addProductViewController.swift
//  Super easy dev
//
//  Created by Aleksei Grachev on 24/12/22
//

import UIKit
import SnapKit


protocol AddProductViewInputProtocol: AnyObject {
    func showMainImageView(image: UIImage)
    func showCongratImageView(image: UIImage)
}

final class AddProductViewController: UIViewController {
    // MARK: - Public
    var presenter: AddProductViewOutputProtocol?
    var mainImageView = UIImageView()
    var congratImageView = UIImageView()
    lazy var viewHeight = CGFloat()

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
}

// MARK: - Private functions
private extension AddProductViewController {
    func initialize() {
        presenter?.viewDidLoaded()
        createImageView()
        addViewConstraints()
    }
    
    private func createImageView() {
            view.addSubview(mainImageView)
        view.addSubview(congratImageView)
        }
    private func addViewConstraints() {
        viewHeight = view.bounds.height
        let heightImageView = viewHeight / 2
        mainImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(heightImageView)
        }
        congratImageView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(mainImageView.snp.bottom)
        }
    }
}

// MARK: - AddProductViewInputProtocol
extension AddProductViewController: AddProductViewInputProtocol {
    func showMainImageView(image: UIImage) {
        mainImageView.image = image
    }
    func showCongratImageView(image: UIImage) {
        congratImageView.image = image
    }
}
