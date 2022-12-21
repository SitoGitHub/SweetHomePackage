//
//  File.swift
//  
//
//  Created by Aleksei Grachev on 21/12/22.
//

import UIKit

typealias NavigationFactory = (UIViewController) -> (UINavigationController)

class NavigationBuilder {
    static func build(rootView: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootView)
        navigationController.title = "Регистрация"
        return navigationController
    }
}
