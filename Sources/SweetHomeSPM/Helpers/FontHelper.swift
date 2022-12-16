//
//  File.swift
//  ExchCurrency
//
//  Created by Dana on 20/11/2022.
//  Copyright © 2022 Sito. All rights reserved.
//

import UIKit

enum Fonts {
    case fontTextField
    case fontNameMakerLabelSlideView
    case fontLabel
    case fontTopLabel
    case fontPlusLabel
    case fontButton
    var fontsForViews: UIFont{
        switch self {
        case .fontTextField:
            return UIFont.systemFont(ofSize: 17)
        case .fontNameMakerLabelSlideView:
            return UIFont.systemFont(ofSize: 25) //(name: "SF", size: 37) ?? UIFont.italicSystemFont(ofSize: 37)
        case .fontLabel:
            return UIFont.systemFont(ofSize: 17)
        case .fontTopLabel:
        return UIFont.systemFont(ofSize: 21)
        case .fontPlusLabel:
            return UIFont(name: "PingFang HK", size: 33) ?? UIFont.italicSystemFont(ofSize: 33)
        case .fontButton:
            return UIFont(name: "SF", size: 17) ?? UIFont.italicSystemFont(ofSize: 17)
            
        }
    }
}
