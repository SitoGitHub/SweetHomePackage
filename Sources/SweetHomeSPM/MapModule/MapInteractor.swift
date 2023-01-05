//
//  MapInteractor.swift
//
//  AppDelegate.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 28/11/22.
//
// MARK: - MapInteractorInputProtocol
protocol MapInteractorInputProtocol: AnyObject {
    func fetchMakerData()
}
// MARK: - MapInteractor
final class MapInteractor {
    // MARK: - properties
    weak var presenter: MapInteractorOutputProtocol?
    let coreDataManager: CoreDataManagerProtocol
    // MARK: - init
    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
    }
}
// MARK: - MapInteractorInputProtocol
extension MapInteractor: MapInteractorInputProtocol {

    func fetchMakerData() {
        let pinMakers = coreDataManager.getPinMaker()
        switch pinMakers {
        case.success(let pinMakers):
            self.presenter?.fetchedMakerData(pinMakers: pinMakers, error: nil)
            
        case .failure(let error):
            self.presenter?.fetchedMakerData(pinMakers: nil, error: error)
        }
    }
}
