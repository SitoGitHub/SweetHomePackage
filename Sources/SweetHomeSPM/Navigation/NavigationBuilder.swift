//
//  File.swift
//  
//
//  Created by Aleksei Grachev on 21/12/22.
//

import UIKit

typealias NavigationFactory = (UIViewController) -> (UINavigationController)

final class NavigationBuilder {
    static func build(rootView: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootView)
        return navigationController
    }
}
