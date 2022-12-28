//
//  File.swift
//  
//
//  Created by Aleksei Grachev on 11/12/22.
//

import UIKit

class SliderBottomView: UIView {
   
    let routeButton = UIButton()
    let makerLabel = UILabel()
    let categoryLabel = UILabel()
    let makerImageView = UIImageView()
    let recognizer = UITapGestureRecognizer()
    let buttonStack = UIStackView()
    let listOfCategoryLabel = UILabel()
    
    init() {
        
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        createRouteButton()
        createMAkerImageView()
        setupMakerLabel()
        createCategoryLabel()
        createListOfCategoryLabel()
    }
    //конпка для построения маршрута
    private func createRouteButton(){
        routeButton.setTitle("Маршрут", for: .normal)
        routeButton.setTitleColor(Colors.whiteLabel.colorViewUIColor, for: .normal)
        routeButton.backgroundColor = Colors.activeButtonColor.colorViewUIColor
        routeButton.titleLabel?.font = Fonts.fontButton.fontsForViews
        routeButton.layer.cornerRadius = 10
    
        self.addSubview(routeButton)
        
        routeButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalToSuperview().multipliedBy(0.15)
            make.bottom.equalToSuperview().inset(30)
        }
    }
    
    
    private func createMAkerImageView(){
        makerImageView.layer.cornerRadius = makerImageView.frame.width / 2
        makerImageView.layer.masksToBounds = false
        makerImageView.clipsToBounds = true
        makerImageView.contentMode = .scaleAspectFill

        self.addSubview(makerImageView)
        
        makerImageView.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview().inset(2)
            make.width.equalTo(65)
            make.height.equalTo(makerImageView.snp.width)
            make.top.equalToSuperview().inset(2)
        }
        makerImageView.layoutIfNeeded()
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
        

        
        
        makerLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.right.equalTo(makerImageView.snp.left)
        }
    }
   
    private func createCategoryLabel() {
        categoryLabel.font = Fonts.fontTopLabel.fontsForViews
        categoryLabel.textColor = Colors.blackLabel.colorViewUIColor
        categoryLabel.textAlignment = .center
        categoryLabel.text = "Категории:"
        self.addSubview(categoryLabel)
    
        categoryLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(makerLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
   
    private func createListOfCategoryLabel() {
        listOfCategoryLabel.font = Fonts.fontLabel.fontsForViews
        listOfCategoryLabel.textColor = Colors.blackLabel.colorViewUIColor
        listOfCategoryLabel.numberOfLines = 0
        listOfCategoryLabel.textAlignment = .center
        self.addSubview(listOfCategoryLabel)
        listOfCategoryLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview().inset(5)
            make.top.equalTo(categoryLabel.snp.bottom).offset(10)
        }
    }
}
