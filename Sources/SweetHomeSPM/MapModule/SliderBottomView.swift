//
//  File.swift
//  
//
//  Created by Aleksei Grachev on 11/12/22.
//

import Foundation
import UIKit

class SliderBottomView: UIView {
   
    let routeButton = UIButton()
    let makerLabel = UILabel()
    let makerImageView = UIImageView()
    let recognizer = UITapGestureRecognizer()
    
    required init() {
        
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
        setupMakerLabel()
        createMAkerImageView()
    }
    
    private func createRouteButton(){
        //RouteButton.layer.masksToBounds = true
        routeButton.setTitle("Маршрут", for: .normal)
        routeButton.setTitleColor(Colors.whiteLabel.colorViewUIColor, for: .normal)
        routeButton.backgroundColor = Colors.activeButtonColor.colorViewUIColor
        routeButton.titleLabel?.font = Fonts.fontButton.fontsForViews
        routeButton.layer.cornerRadius = 10
        //RouteButton.isEnabled = true
        //RouteButton.addTarget(self, action: #selector(cancelLastExchButton), for: .touchUpInside)
       // routeButton.frame = CGRect(x: 50, y: 50, width: 70, height: 30)
        self.addSubview(routeButton)
        
        routeButton.snp.makeConstraints { (make) -> Void in
           // make.left.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalToSuperview().multipliedBy(0.15)
            make.bottom.equalToSuperview().inset(30)
        }
    }
    
    private func setupMakerLabel() {
        makerLabel.font = Fonts.fontNameMakerLabelSlideView.fontsForViews
        makerLabel.textColor = Colors.blackLabel.colorViewUIColor
        self.addSubview(makerLabel)
        
        makerLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
//            make.width.equalToSuperview().multipliedBy(0.3)
//            make.height.equalToSuperview().multipliedBy(0.15)
//            make.bottom.equalToSuperview().inset(30)
        }
    }
    
    private func createMAkerImageView(){
       // makerImageView.layer.cornerRadius = makerImageView.frame.width / 2
        makerImageView.layer.masksToBounds = false
        makerImageView.clipsToBounds = true
       // picker.delegate = self
        
        makerImageView.contentMode = .scaleAspectFill
        if let image = UIImage(named: "undefinedImage", in: .module, compatibleWith: nil){
            makerImageView.image = image
        }
        self.addSubview(makerImageView)
        
        makerImageView.snp.makeConstraints { (make) -> Void in
           // make.left.equalToSuperview().offset(60)
            make.left.equalToSuperview().inset(2)
            make.right.equalTo(makerLabel.snp.left).inset(2)
            make.width.equalTo(65)
            make.height.equalTo(makerImageView.snp.width)
            make.top.equalToSuperview().inset(2)
        }
        makerImageView.layoutIfNeeded()
        makerImageView.layer.cornerRadius = makerImageView.frame.width / 2
        
        makerImageView.isUserInteractionEnabled = true
        
        
        //recognizer.addTarget(self, action: #selector(tapForMakerImageAction(_:)))
        makerImageView.addGestureRecognizer(recognizer)
    }
}
