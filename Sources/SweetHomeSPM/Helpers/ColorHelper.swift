//
//  Color.swift
//  ExchCurrency
//
//  Created by Dana on 20/11/2022.
//  Copyright © 2022 Sito. All rights reserved.
//

import UIKit

//цвета для view фона
enum Colors {
    case headerColor
    case activeButtonColor
    case partsColormedimView
    case textFieldColor
    case whiteLabel
    case blackLabel
    case lightGrayButton
    case placeHolderColor
    case registrationViewColor
    var colorViewUIColor: UIColor{
        switch self {
        case .headerColor:
            return #colorLiteral(red: 0.09887791425, green: 0.4298920333, blue: 0.9957283139, alpha: 1)
        case .activeButtonColor:
            return #colorLiteral(red: 0.09887791425, green: 0.4298920333, blue: 0.9957283139, alpha: 1)
        case .partsColormedimView:
            return #colorLiteral(red: 0.01055246126, green: 0.3625304103, blue: 0.6282795668, alpha: 1)
        case .textFieldColor:
            return .black
        case .whiteLabel:
            return .white
        case .blackLabel:
            return .black
        case .lightGrayButton:
            return .lightGray
        case .placeHolderColor:
            return .darkGray
        case .registrationViewColor:
            return #colorLiteral(red: 0.5881078839, green: 0.8096932769, blue: 0.9557163119, alpha: 1)
        }
    }
}
