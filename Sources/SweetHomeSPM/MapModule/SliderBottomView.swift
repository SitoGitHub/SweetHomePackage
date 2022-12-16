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
}
