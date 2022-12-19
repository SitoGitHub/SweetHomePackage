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
    lazy var countryLocation = CountryMaker()
    lazy var cityLocation = CityMaker()
    
    //save New Maker Data
    
    func saveDataNewMaker(surnameMaker: String, nameMaker: String, phoneNumberMaker: String, emailMaker: String, passwordMaker: String, urlImageMaker: URL?, touchCoordinateMaker: CLLocationCoordinate2D) {

       // var countryMaker: String?
       // var cityMaker: String?
        var setContryCity: (String?, String?)
        let maker = coreDataManager.getMakerWithPhoneAndEmail(phoneNumber: phoneNumberMaker, email: emailMaker)
        
        switch maker {
        case.success(let maker):
            guard maker.count == 0 else {
                self.presenter?.existAlreadyMaker(phoneNumberMaker: phoneNumberMaker, email: emailMaker)
                return
            }
            // get country and city names by location
            setContryCity = getCountryCityByLacation(touchCoordinateMaker)
            
            let newMaker = Maker()
            newMaker.maker_name = nameMaker
            newMaker.maker_surname = surnameMaker
            // bakerSergei.baker_product_categories = ["Торты"]
            newMaker.date = Date()
            newMaker.lat = Double(touchCoordinateMaker.latitude) as? NSDecimalNumber
            newMaker.long = touchCoordinateMaker.longitude as? NSDecimalNumber
            newMaker.phone_number = phoneNumberMaker
            newMaker.email  = emailMaker
            newMaker.password = passwordMaker
            newMaker.maker_image = urlImageMaker
            
            print (Double(touchCoordinateMaker.latitude) as? NSDecimalNumber, Double(touchCoordinateMaker.latitude))
            
            if let country = setContryCity.0 {
                let countryExist = self.coreDataManager.getCountry(country: country)
                switch countryExist {
                case.success(let countryExist):
                    if countryExist.count == 0 {
                        let newCountry = CountryMaker()
                        newCountry.country_name = country
                        self.countryLocation = newCountry
                    } else {
                        if let countryLocationMaker = countryExist.first {
                            self.countryLocation = countryLocationMaker
                        }
                    }
                case .failure(let error):
                    self.presenter?.fetchedMakerData(maker: nil, error: error)
                }
            }
            
            if let city = setContryCity.1 {
                let countryName = self.countryLocation.country_name ?? ""
                let cityExist = self.coreDataManager.getCityWithName(cityName: city, country: countryName)
                switch cityExist {
                case.success(let cityExist):
                    if cityExist.count == 0 {
                        let newCity = CityMaker()
                        newCity.city_name = city
                        self.cityLocation = newCity
                        self.countryLocation.addToCountry_cities([newCity])
                } else {
                    if let cityLocationMaker = cityExist.first {
                        self.cityLocation = cityLocationMaker
                    }
                }
                
                case .failure(let error):
                    self.presenter?.fetchedMakerData(maker: nil, error: error)
                }
            }
            
            cityLocation.addToCity_makers([newMaker])
            coreDataManager.saveContext()
            
            let makerAnotation = MakerAnotation(surnameMaker: surnameMaker, nameMaker: nameMaker, phoneNumberMaker: phoneNumberMaker, emailMaker: emailMaker, passwordMaker: passwordMaker, urlImageMaker: urlImageMaker, coordinate: touchCoordinateMaker)
            
            //allMakersAnotation.append(MakerAnotation)
            
            self.presenter?.fetchedMakerData(maker: makerAnotation, error: nil)
            
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
    // get country and city names by location
    fileprivate func getCountryCityByLacation(_ touchCoordinateMaker: CLLocationCoordinate2D) -> (String?, String?) {
        // get address for touch coordinates.
        var countryMaker: String?
        var cityMaker: String?
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: touchCoordinateMaker.latitude, longitude: touchCoordinateMaker.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler:
                                            {
            placemarks, error -> Void in
            
            // Place details
            guard let placeMark = placemarks?.first else { return }
            
            // Country
            if let country = placeMark.country {
                print(country)
                countryMaker = country
                
            }
            
            // Location name
            if let locationName = placeMark.location {
                print(locationName)
            }
            // Street address
            if let street = placeMark.thoroughfare {
                
                print(street)
                
            }
            // City
            if let city = placeMark.subAdministrativeArea {
                cityMaker = city
                print(city)
            }
            // Zip code
            if let zip = placeMark.isoCountryCode {
                print(zip)
            }
            
        })
        return (countryMaker, cityMaker)
    }
    
    
}
