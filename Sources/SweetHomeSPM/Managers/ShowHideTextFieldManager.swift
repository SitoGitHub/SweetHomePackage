//
//  File.swift
//  
//
//  Created by Aleksei Grachev on 14/12/22.


import UIKit
// MARK: - class ShowHideTextField
class ShowHideTextField: UITextField {
    let rightButton  = UIButton(type: .custom)
    
    // MARK: - init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    // MARK: - private functions
    private func commonInit() {
        rightButton.setImage(UIImage(named: "password_show", in: .module, compatibleWith: nil) , for: .normal)
        rightButton.addTarget(self, action: #selector(toggleShowHide), for: .touchUpInside)
        rightButton.frame = CGRect(x:0, y:0, width:20, height:20)

        rightViewMode = .always
        rightView = rightButton
        isSecureTextEntry = true
    }

    @objc
    func toggleShowHide(button: UIButton) {
        toggle()
    }

    private func toggle() {
        isSecureTextEntry = !isSecureTextEntry
        if isSecureTextEntry {
            rightButton.setImage(UIImage(named: "password_show", in: .module, compatibleWith: nil), for: .normal)
        } else {
            rightButton.setImage(UIImage(named: "password_hide", in: .module, compatibleWith: nil), for: .normal)
        }
    }

}
