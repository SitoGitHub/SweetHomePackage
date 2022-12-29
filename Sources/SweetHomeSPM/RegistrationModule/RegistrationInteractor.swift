//
//  RegistrationInteractor.swift
//  
//
//  Created by Aleksei Grachev on 13/12/22.
//

import Foundation
import MapKit

protocol RegistrationInteractorInputProtocol: AnyObject {
    func saveDataNewMaker(surnameMaker: String, nameMaker: String, phoneNumberMaker: String, emailMaker: String, passwordMaker: String, pathImageMaker: String?, touchCoordinateMaker: CLLocationCoordinate2D)
    func editDataMaker(surnameMaker: String, nameMaker: String, phoneNumberMaker: String, emailMaker: String, passwordMaker: String, pathImageMaker: String?, touchCoordinateMaker: CLLocationCoordinate2D)
}

final class RegistrationInteractor {
    weak var presenter: RegistrationInteractorOutputProtocol?
    let coreDataManager: CoreDataManagerProtocol
    let locationManager: LocationManagerProtocol
    var maker = Maker()
    var lat = Double()
    var long = Double()
    
    init(coreDataManager: CoreDataManagerProtocol, locationManager: LocationManagerProtocol) {
        self.coreDataManager = coreDataManager
        self.locationManager = locationManager
    }
}

extension RegistrationInteractor: RegistrationInteractorInputProtocol {
    //save New Maker Data
    func saveDataNewMaker(surnameMaker: String, nameMaker: String, phoneNumberMaker: String, emailMaker: String, passwordMaker: String, pathImageMaker: String?, touchCoordinateMaker: CLLocationCoordinate2D) {
        
        locationManager.geocode(latitude: touchCoordinateMaker.latitude, longitude: touchCoordinateMaker.longitude) { placemarks, error in
            
            var newMaker = Maker()
            lazy var countryLocation = CountryMaker()
            lazy var cityLocation = CityMaker()
            var countryMaker: String?
            var cityMaker: String?
            
            let maker = self.self.coreDataManager.getMakerWithPhoneAndEmail(phoneNumber: phoneNumberMaker, email: emailMaker)
            
            switch maker {
            case.success(let makers):
                guard makers.count == 0 else {
                    for maker in makers{
                        if maker.lat == Double(touchCoordinateMaker.latitude) &&
                            maker.long == Double(touchCoordinateMaker.longitude) {
                            self.presenter?.isNeedEditMaker(phoneNumberMaker: phoneNumberMaker, email: emailMaker)
                        } else {
                            self.presenter?.existAlreadyMaker(phoneNumberMaker: phoneNumberMaker, email: emailMaker)
                        }
                    }
                    return
                }
                newMaker = createNewMaker()
                
            case .failure(let error):
                self.presenter?.fetchedMakerData(maker: nil, error: error)
            }
            
            guard let placeMark = placemarks?.first else { return }
            // Country
            if let country = placeMark.country {
                countryMaker = country
                
            }
            // City
            if let city = placeMark.subAdministrativeArea {
                cityMaker = city
            }
            if let country = countryMaker {
                let countryExist = self.self.coreDataManager.getCountry(country: country)
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
                let cityExist = self.self.coreDataManager.getCityWithName(cityName: city, country: countryName)
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
                }
            }
            
            //данные для созданияя пина на карте
            let makerAnotation = MakerAnotation(surnameMaker: surnameMaker, nameMaker: nameMaker, phoneNumberMaker: phoneNumberMaker, emailMaker: emailMaker, passwordMaker: passwordMaker, pathImageMaker: pathImageMaker, coordinate: touchCoordinateMaker, productCategoriesMaker: nil)
            
            cityLocation.addToCity_makers([newMaker])
            self.self.coreDataManager.saveContext()
            self.presenter?.fetchedMakerData(maker: makerAnotation, error: nil)
            self.presenter?.isSavedData()
            
            //create New Maker
            func createNewMaker() -> Maker {
                let newMaker = Maker()
                newMaker.maker_name = nameMaker
                newMaker.maker_surname = surnameMaker
                // bakerSergei.baker_product_categories = ["Торты"]
                newMaker.date = Date()
                newMaker.lat = Double(touchCoordinateMaker.latitude)
                self.lat = newMaker.lat
                newMaker.long = Double(touchCoordinateMaker.longitude)
                self.long = newMaker.long
                newMaker.phone_number = phoneNumberMaker
                newMaker.email  = emailMaker
                newMaker.password = passwordMaker
                newMaker.path_image = pathImageMaker
                return newMaker
            }
        }
    }
    
    func editDataMaker(surnameMaker: String, nameMaker: String, phoneNumberMaker: String, emailMaker: String, passwordMaker: String, pathImageMaker: String?, touchCoordinateMaker: CLLocationCoordinate2D) {
        let lat = Double(touchCoordinateMaker.latitude)
        let long = Double(touchCoordinateMaker.longitude)
        let maker = coreDataManager.getMakerWithCoordinate(latitude: lat, long: long)
        
        switch maker {
        case.success(let makers):
            if makers.count == 0 {
                self.presenter?.fetchedMakerData(maker: nil, error: .loadMakersError)
            } else {
                for maker in makers{
                    maker.setValue(nameMaker, forKey: "maker_name")
                    maker.setValue(phoneNumberMaker, forKey: "phone_number")
                    maker.setValue(emailMaker, forKey: "email")
                    maker.setValue(passwordMaker, forKey: "password")
                    maker.setValue(pathImageMaker, forKey: "path_image")
                    maker.setValue(surnameMaker, forKey: "maker_surname")
                }
                coreDataManager.saveContext()
                var productCategoriesMaker: [ProductCategoryMaker] = []
                if let maker = makers.first{
                    let productCategories = coreDataManager.getAllProductCategoriesMakers(maker: maker)
                    switch productCategories {
                    case.success(let productCategories):
                        productCategoriesMaker = productCategories
                        //for productCategoryMakers in productCategoriesMakers {
                    case .failure(let error):
                        self.presenter?.fetchedMakerData(maker: nil, error: error)
                    }
                }
                //данные для созданияя пина на карте
                let makerAnotation = MakerAnotation(surnameMaker: surnameMaker, nameMaker: nameMaker, phoneNumberMaker: phoneNumberMaker, emailMaker: emailMaker, passwordMaker: passwordMaker, pathImageMaker: pathImageMaker, coordinate: touchCoordinateMaker, productCategoriesMaker: productCategoriesMaker)
                self.presenter?.fetchedMakerData(maker: makerAnotation, error: nil)
                presenter?.isEditedData()
            }
            
        case .failure(let error):
            self.presenter?.fetchedMakerData(maker: nil, error: error)
            
        }
    }
}
