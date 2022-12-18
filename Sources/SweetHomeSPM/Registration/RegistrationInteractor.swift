//
//  RegistrationInteractor.swift
//  
//
//  Created by Aleksei Grachev on 13/12/22.
//

import Foundation
import MapKit

protocol RegistrationInteractorInputProtocol: AnyObject {
    func saveDataNewMaker(surnameMaker: String, nameMaker: String, phoneNumberMaker: String, emailMaker: String, passwordMaker: String, urlImageMaker: URL?, touchCoordinateMaker: CLLocationCoordinate2D)
}

class RegistrationInteractor: RegistrationInteractorInputProtocol {
   
    weak var presenter: RegistrationInteractorOutputProtocol?
    let coreDataManager = CoreDataManager.shared
    
    
    //save New Maker Data
    func saveDataNewMaker(surnameMaker: String, nameMaker: String, phoneNumberMaker: String, emailMaker: String, passwordMaker: String, urlImageMaker: URL?, touchCoordinateMaker: CLLocationCoordinate2D) {

        let maker = coreDataManager.getMakerWithPhone(phoneNumber: phoneNumberMaker)
        
        switch maker {
        case.success(let maker):
            guard maker.count == 0 else {
                self.presenter?.existAlreadyMaker(phoneNumberMaker: phoneNumberMaker)
                return
            }
            let newMaker = Maker()
            newMaker.maker_name = nameMaker
            newMaker.maker_surname = surnameMaker
            // bakerSergei.baker_product_categories = ["Торты"]
            newMaker.date = Date()
            newMaker.lat = touchCoordinateMaker.latitude as? NSDecimalNumber
            newMaker.long = touchCoordinateMaker.longitude as? NSDecimalNumber
            newMaker.phone_number = phoneNumberMaker
            newMaker.email  = emailMaker
            newMaker.password = passwordMaker
            newMaker.maker_image = urlImageMaker
            
            
            self.presenter?.fetchedMakerData(maker: newMaker, error: nil)
            
        case .failure(let error):
            self.presenter?.fetchedMakerData(maker: nil, error: error)
        }
      //  guard maker = nil else {}
//
//        let newMaker = Maker()
//        newMaker.maker_name = nameMaker
//        newMaker.maker_surname = surnameMaker
//       // bakerSergei.baker_product_categories = ["Торты"]
//        newMaker.date = Date()
//        newMaker.lat = touchCoordinateMaker.latitude as? NSDecimalNumber
//        newMaker.long = touchCoordinateMaker.longitude as? NSDecimalNumber
//        newMaker.phone_number = phoneNumberMaker
//        newMaker.email  = emailMaker
//        newMaker.passord = passwordMaker
//        newMaker.maker_image = urlImageMaker
    
       // NSPredicate(format: "%K == %@", #keyPath(CityMaker.city_name), NSNumber(value: false))
        
//        let city = CityMaker()
//        city.city_name = "Москва"
//        city.addToCity_makers([makerSergei, makerGrigoriy])
//        
//        let country = CountryMaker()
//        country.country_name = "Россия"
//        country.addToCountry_cities([city])
//        
//        coreDataManager.saveContext()

    }
    
   
    
    
}
