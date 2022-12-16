//
//  MapModuleBuilder.swift

//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 28/11/22.
//


public class MapModuleBuilder {
    //@discardableResult
    public static func build() -> MapViewController {
        let view = MapViewController()
        let interactor = MapInteractor()
        let router = MapRouter()
        let presenter = MapPresenter(interactor: interactor, router: router)
        view.presenter = presenter
        presenter.view = view
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
}


