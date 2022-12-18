//
//  MapInteractor.swift
//
//  AppDelegate.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 28/11/22.
//

public protocol MapInteractorInputProtocol: AnyObject {
   func fetchMakerData()
}

public class MapInteractor: MapInteractorInputProtocol {
    weak var presenter: MapInteractorOutputProtocol?
    let modelUser = ModelUser()
    var users = [[User]]()
    var coreDataManager = CoreDataManager()
    
    public func fetchMakerData() {
//           dateService.getDate { [weak self] date in
//               self?.presenter?.didLoadDate(date: date.description)
//           }
        
        modelUser.setup()
        
      
        let pinMakers = coreDataManager.getPinMaker()
        switch pinMakers {
        case.success(let pinMakers):
            self.presenter?.fetchedMakerData(pinMakers: pinMakers, error: nil)
            
        case .failure(let error):
            self.presenter?.fetchedMakerData(pinMakers: nil, error: error)
        }

        
        
//        self.users = modelUser.users
//        self.presenter?.didLoadDate(users: users)
        
//        for user in modelUser.users.first!{
//            mapView.addAnnotation(user)
//        }
        
       }
    
}
