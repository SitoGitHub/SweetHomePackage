//
//  RegistrationInteractor.swift
//  
//
//  Created by Aleksei Grachev on 13/12/22.
//

import Foundation
import MapKit

protocol RegistrationInteractorProtocol: AnyObject {
    func saveDataNewMaker(surnameMaker: String, nameMaker: String, phoneNumberMaker: String, emailMaker: String, passwordMaker: String, urlImageMaker: URL?, touchCoordinateMaker: CLLocationCoordinate2D)
}

class RegistrationInteractor: RegistrationInteractorProtocol {
   
    weak var presenter: RegistrationPresenterProtocol?
    let coreDataManager = CoreDataManager.shared
    
    
    //save Data of New Maker
    func saveDataNewMaker(surnameMaker: String, nameMaker: String, phoneNumberMaker: String, emailMaker: String, passwordMaker: String, urlImageMaker: URL?, touchCoordinateMaker: CLLocationCoordinate2D) {

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
