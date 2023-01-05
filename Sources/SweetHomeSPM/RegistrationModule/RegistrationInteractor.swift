//
//  RegistrationInteractor.swift
//  
//
//  Created by Aleksei Grachev on 13/12/22.
//

import Foundation
import MapKit
// MARK: - RegistrationInteractorInputProtocol
protocol RegistrationInteractorInputProtocol: AnyObject {
    func saveDataNewMaker(surnameMaker: String, nameMaker: String, phoneNumberMaker: String, emailMaker: String, passwordMaker: String, pathImageMaker: String?, touchCoordinateMaker: CLLocationCoordinate2D)
    func editDataMaker(surnameMaker: String, nameMaker: String, phoneNumberMaker: String, emailMaker: String, passwordMaker: String, pathImageMaker: String?, touchCoordinateMaker: CLLocationCoordinate2D)
}
// MARK: - RegistrationInteractor
final class RegistrationInteractor {
    // MARK: - Properties
    weak var presenter: RegistrationInteractorOutputProtocol?
    let coreDataManager: CoreDataManagerProtocol
    let locationManager: LocationManagerProtocol
    var lat = Double()
    var long = Double()
    // MARK: - init
    init(coreDataManager: CoreDataManagerProtocol, locationManager: LocationManagerProtocol) {
        self.coreDataManager = coreDataManager
        self.locationManager = locationManager
    }
}

// MARK: - Private functions
extension RegistrationInteractor {
    //получение названия страны вновь зарегетрированного мейкера
    fileprivate func getCountryName(_ placeMark: CLPlacemark) -> CountryMaker? {
        // Country
        var  countryLocation: CountryMaker?
        
        if let country = placeMark.country {
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
        return countryLocation
    }
    //получение названия города вновь зарегетрированного мейкера
    fileprivate func getCityName(_ placeMark: CLPlacemark, _ countryLocation: CountryMaker) -> CityMaker? {
        // City
        var cityLocation: CityMaker?

        if let city = placeMark.subAdministrativeArea {
            let countryName = countryLocation.country_name ?? ""
            let cityExist = self.coreDataManager.getCityWithName(cityName: city, country: countryName)
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
        return cityLocation
    }
}

// MARK: - RegistrationInteractorInputProtocol
extension RegistrationInteractor: RegistrationInteractorInputProtocol {
    
    //save New Maker Data
    func saveDataNewMaker(surnameMaker: String, nameMaker: String, phoneNumberMaker: String, emailMaker: String, passwordMaker: String, pathImageMaker: String?, touchCoordinateMaker: CLLocationCoordinate2D) {
        
        locationManager.geocode(latitude: touchCoordinateMaker.latitude, longitude: touchCoordinateMaker.longitude) { placemarks, error in
            var countryLocation: CountryMaker?
            var cityLocation: CityMaker?
            
            let maker = self.coreDataManager.getMakerWithPhoneAndEmail(phoneNumber: phoneNumberMaker, email: emailMaker)
            
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
                let newMaker = createNewMaker()
                guard let placeMark = placemarks?.first else { return }
                // Country
                countryLocation = self.getCountryName(placeMark)
                //City
                if let countryLocation = countryLocation {
                    cityLocation = self.getCityName(placeMark, countryLocation)
                    cityLocation?.addToCity_makers([newMaker])
                    
                }
                //данные для созданияя пина на карте
                let makerAnotation = MakerAnotation(surnameMaker: surnameMaker, nameMaker: nameMaker, phoneNumberMaker: phoneNumberMaker, emailMaker: emailMaker, passwordMaker: passwordMaker, pathImageMaker: pathImageMaker, coordinate: touchCoordinateMaker, productCategoriesMaker: nil)
                self.self.coreDataManager.saveContext()
                self.presenter?.fetchedMakerData(maker: makerAnotation, error: nil)
                self.presenter?.isSavedData()
                
            case .failure(let error):
                self.presenter?.fetchedMakerData(maker: nil, error: error)
            }
            
            //create New Maker
            func createNewMaker() -> Maker {
                let newMaker = Maker()
                newMaker.maker_name = nameMaker
                newMaker.maker_surname = surnameMaker
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
    // edit Data Maker
    func editDataMaker(surnameMaker: String, nameMaker: String, phoneNumberMaker: String, emailMaker: String, passwordMaker: String, pathImageMaker: String?, touchCoordinateMaker: CLLocationCoordinate2D) {
        coreDataManager.saveContext()
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
