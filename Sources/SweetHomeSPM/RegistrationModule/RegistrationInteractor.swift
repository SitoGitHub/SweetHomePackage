//
//  RegistrationInteractor.swift
//  
//
//  Created by Aleksei Grachev on 13/12/22.
//

import Foundation
import MapKit


protocol RegistrationInteractorInputProtocol: AnyObject {
    func saveDataNewMaker(surnameMaker: String, nameMaker: String, phoneNumberMaker: String, emailMaker: String, passwordMaker: String, urlImageMaker: URL?, touchCoordinateMaker: CLLocationCoordinate2D) -> Maker
}

class RegistrationInteractor: RegistrationInteractorInputProtocol {
    
    weak var presenter: RegistrationInteractorOutputProtocol?
    var maker = Maker()
    
    deinit{
        print("RegistrationInteractor deinit")
    }
    
    //save New Maker Data
    func saveDataNewMaker(surnameMaker: String, nameMaker: String, phoneNumberMaker: String, emailMaker: String, passwordMaker: String, urlImageMaker: URL?, touchCoordinateMaker: CLLocationCoordinate2D) -> Maker {
        
        let locationManager = LocationManager()
        
        locationManager.geocode(latitude: touchCoordinateMaker.latitude, longitude: touchCoordinateMaker.longitude) { placemarks, error in
            
            var newMaker = Maker()
            let coreDataManager = CoreDataManager.shared
            lazy var countryLocation = CountryMaker()
            lazy var cityLocation = CityMaker()
            var countryMaker: String?
            var cityMaker: String?
            
            let maker = coreDataManager.getMakerWithPhoneAndEmail(phoneNumber: phoneNumberMaker, email: emailMaker)
            
            
            switch maker {
            case.success(let maker):
                guard maker.count == 0 else {
                    self.presenter?.existAlreadyMaker(phoneNumberMaker: phoneNumberMaker, email: emailMaker)
                    return
                }
                
                newMaker = createNewMaker()
                
                // get country and city names by location
                // getCountryCityByLacation(touchCoordinateMaker, newMaker: newMaker)
                //            print (Double(touchCoordinateMaker.latitude) as? NSDecimalNumber, Double(touchCoordinateMaker.latitude))
                
                
                
                
            case .failure(let error):
                self.presenter?.fetchedMakerData(maker: nil, error: error)
                
            }
            
            guard let placeMark = placemarks?.first else { return }
            // Country
            if let country = placeMark.country {
                print(country)
                countryMaker = country
                
            }
            // City
            if let city = placeMark.subAdministrativeArea {
                cityMaker = city
                print(city)
            }
            if let country = countryMaker {
                let countryExist = coreDataManager.getCountry(country: country)
                switch countryExist {
                case.success(let countryExist):
                    if countryExist.count == 0 {
                        let newCountry = CountryMaker()
                        newCountry.country_name = country
                        countryLocation = newCountry
                    } else {
                        if let countryLocationMaker = countryExist.first {
                            countryLocation = countryLocationMaker
                        }
                    }
                case .failure(let error):
                    self.presenter?.fetchedMakerData(maker: nil, error: error)
                }
            }
            
            if let city = cityMaker {
                let countryName = countryLocation.country_name ?? ""
                let cityExist = coreDataManager.getCityWithName(cityName: city, country: countryName)
                switch cityExist {
                case.success(let cityExist):
                    if cityExist.count == 0 {
                        let newCity = CityMaker()
                        newCity.city_name = city
                        cityLocation = newCity
                        countryLocation.addToCountry_cities([newCity])
                    } else {
                        if let cityLocationMaker = cityExist.first {
                            cityLocation = cityLocationMaker
                        }
                    }
                    
                case .failure(let error):
                    self.presenter?.fetchedMakerData(maker: nil, error: error)
                    //   print(error)
                }
            }
            
            //данные для созданияя пина на карте
            let makerAnotation = MakerAnotation(surnameMaker: surnameMaker, nameMaker: nameMaker, phoneNumberMaker: phoneNumberMaker, emailMaker: emailMaker, passwordMaker: passwordMaker, urlImageMaker: urlImageMaker, coordinate: touchCoordinateMaker)
            
            //allMakersAnotation.append(MakerAnotation)
            
            self.presenter?.fetchedMakerData(maker: makerAnotation, error: nil)
            
            cityLocation.addToCity_makers([newMaker])
            coreDataManager.saveContext()
            
            self.maker = newMaker
            
            //create New Maker
            func createNewMaker() -> Maker {
                let newMaker = Maker()
                newMaker.maker_name = nameMaker
                newMaker.maker_surname = surnameMaker
                // bakerSergei.baker_product_categories = ["Торты"]
                newMaker.date = Date()
                newMaker.lat = Double(touchCoordinateMaker.latitude)
                newMaker.long = Double(touchCoordinateMaker.longitude)
                newMaker.phone_number = phoneNumberMaker
                newMaker.email  = emailMaker
                newMaker.password = passwordMaker
                newMaker.maker_image = urlImageMaker
                return newMaker
            }
        }
        return self.maker
        
    }
    
    
    //
    //    func geocode(latitude: Double, longitude: Double, completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
    //        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemark, error in
    //            guard let placemark = placemark, error == nil else {
    //                completion(nil, error)
    //                return
    //            }
    //            completion(placemark, nil)
    //        }
    //    }
    
}
