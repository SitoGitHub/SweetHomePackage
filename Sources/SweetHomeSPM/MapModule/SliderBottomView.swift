//
//  File.swift
//  
//
//  Created by Aleksei Grachev on 11/12/22.
//

import UIKit
import SnapKit
// MARK: - SliderBottomView
final class SliderBottomView: UIView {
    // MARK: - properties
    let routeButton = UIButton()
    let makerLabel = UILabel()
    let categoryLabel = UILabel()
    let makerImageView = UIImageView()
    let recognizer = UITapGestureRecognizer()
    let buttonStack = UIStackView()
    let listOfCategoryLabel = UILabel()
    // MARK: - init
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - private functions
    private func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        createRouteButton()
        createMAkerImageView()
        setupMakerLabel()
        createCategoryLabel()
        createListOfCategoryLabel()
        addViewConstraints()
        setupMakerImageView()
    }
    //конпка для построения маршрута
    private func createRouteButton(){
        routeButton.setTitle("Маршрут", for: .normal)
        routeButton.setTitleColor(Colors.whiteLabel.colorViewUIColor, for: .normal)
        routeButton.backgroundColor = Colors.activeButtonColor.colorViewUIColor
        routeButton.titleLabel?.font = Fonts.fontButton.fontsForViews
        routeButton.layer.cornerRadius = 10
    
        self.addSubview(routeButton)
    }

    private func createMAkerImageView(){
        makerImageView.layer.cornerRadius = makerImageView.frame.width / 2
        makerImageView.layer.masksToBounds = false
        makerImageView.clipsToBounds = true
        makerImageView.contentMode = .scaleAspectFill

        self.addSubview(makerImageView)
    }
    private func setupMakerImageView(){
        makerImageView.layer.cornerRadius = makerImageView.frame.width / 2
        makerImageView.isUserInteractionEnabled = true
        makerImageView.addGestureRecognizer(recognizer)
    }
    
    private func setupMakerLabel() {
        makerLabel.font = Fonts.fontNameMakerLabelSlideView.fontsForViews
        makerLabel.textColor = Colors.blackLabel.colorViewUIColor
        makerLabel.numberOfLines = 2
        makerLabel.textAlignment = .center
        makerLabel.adjustsFontSizeToFitWidth = true
        makerLabel.minimumScaleFactor = 0.5
        self.addSubview(makerLabel)
    }
   
    private func createCategoryLabel() {
        categoryLabel.font = Fonts.fontTopLabel.fontsForViews
        categoryLabel.textColor = Colors.blackLabel.colorViewUIColor
        categoryLabel.textAlignment = .center
        categoryLabel.text = "Категории:"
        self.addSubview(categoryLabel)
    }
   
    private func createListOfCategoryLabel() {
        listOfCategoryLabel.font = Fonts.fontLabel.fontsForViews
        listOfCategoryLabel.textColor = Colors.blackLabel.colorViewUIColor
        listOfCategoryLabel.numberOfLines = 0
        listOfCategoryLabel.textAlignment = .center
        self.addSubview(listOfCategoryLabel)
    }
    
    private func addViewConstraints() {
        routeButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalToSuperview().multipliedBy(0.15)
            make.bottom.equalToSuperview().inset(30)
        }
        
        makerImageView.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview().inset(2)
            make.width.equalTo(65)
            make.height.equalTo(makerImageView.snp.width)
            make.top.equalToSuperview().inset(2)
        }
        makerImageView.layoutIfNeeded()
        
        makerLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.right.equalTo(makerImageView.snp.left)
        }
        
        categoryLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(makerLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        listOfCategoryLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview().inset(5)
            make.top.equalTo(categoryLabel.snp.bottom).offset(10)
        }
    }
}
