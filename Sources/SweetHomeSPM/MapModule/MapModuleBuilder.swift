//
//  MapModuleBuilder.swift

//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 28/11/22.
//
import UIKit
// MARK: - MapModuleBuilder
public final class MapModuleBuilder {
    //@discardableResult
    public static func build() -> UIViewController {
        let view = MapViewController()
        let coreDataManager = CoreDataManager.shared
        let interactor = MapInteractor(coreDataManager: coreDataManager)
        let router = MapRouter()
        let imageManager = ImageManager()
        let presenter = MapPresenter(interactor: interactor, router: router, imageManager: imageManager)
        view.presenter = presenter
        presenter.view = view
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
}


