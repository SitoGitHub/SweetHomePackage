//
//  ViewController.swift
//  SweetHomeMap 1.2
//
//  Created by Aleksei Grachev on 7/12/22.
//

import Foundation
import CoreData
import MapKit

protocol CoreDataManagerDelegate: AnyObject {
    func getCountry(country: String) -> Result<[CountryMaker], Errors>
    func getCity() -> Result<[CityMaker], Errors>
    func getMaker() -> Result<[Maker], Errors>
    func getPinMaker() -> Result<[MakerAnotation], Errors>
    func getMakerWithPhoneAndEmail(phoneNumber: String, email: String) -> Result<[Maker], Errors>
    func getMakerWithCoordinate(latitude: Double, long: Double)  -> Result<[Maker], Errors>
    func getCityWithName(cityName: String, country: String) -> Result<[CityMaker], Errors>
    func getProductCategories() -> Result<[ProductCategory], Errors>
    func getProductCategoriesMakers(categoryName: String, maker: Maker) -> Result<[ProductCategoryMaker], Errors>
    func getAllProductCategoriesMakers(maker: Maker) -> Result<[ProductCategoryMaker], Errors>
    func deleteProductCategoriesMakers(categoryName: String?, maker: Maker, productCategory: ProductCategory) -> Result<Bool, Errors>
    func saveContext ()
}

extension CoreDataManager: CoreDataManagerDelegate {
    
    func getCountry(country: String) -> Result<[CountryMaker], Errors> {
        let fetchRequest: NSFetchRequest<CountryMaker> = CountryMaker.fetchRequest()
        
            let predicate = NSPredicate(format: "%K == %@", #keyPath(CountryMaker.country_name), country)
            fetchRequest.predicate = predicate
        
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            return .success(result)
        } catch {
            return .failure(Errors.loadCountriesError)
        }
    }
    
    func getAllCountry() -> Result<[CountryMaker], Errors> {
        let fetchRequest: NSFetchRequest<CountryMaker> = CountryMaker.fetchRequest()
        
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            return .success(result)
        } catch {
            return .failure(Errors.loadCountriesError)
        }
    }
    
    func getCity() -> Result<[CityMaker], Errors> {
        var allCities: [CityMaker] = []
        let countries = getAllCountry()
        
        switch countries {
        case.success(let countries):
            for country in countries {
                guard let cities = country.country_cities?.allObjects as? [CityMaker]
                else {
                    return .failure(Errors.loadCitiesError)
                }
                
                for city in cities {
                    allCities.append(city)
                }
            }
            return .success(allCities)
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getMaker() -> Result<[Maker], Errors> {
        var allMakers: [Maker] = []
        let cities = getCity()
        
        switch cities {
        case.success(let cities):
            for city in cities {
                guard let makers = city.city_makers?.allObjects as? [Maker]
                else {
                    return .failure(Errors.loadMakersError)
                }
                
                for maker in makers {
                    allMakers.append(maker)
                }
            }
            return .success(allMakers)
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getPinMaker() -> Result<[MakerAnotation], Errors> {
        var allMakersAnotation: [MakerAnotation] = []
        let cities = getCity()
        
        switch cities {
        case.success(let cities):
            for city in cities {
                guard let makers = city.city_makers?.allObjects as? [Maker]
                else {
                    return .failure(Errors.loadMakersError)
                }
                
                for maker in makers {
                    var name = String()
                    var surnameMaker = String()
                    var phoneNumberMaker = String()
                    var emailMaker = String()
                    var passwordMaker = String()
                    
                    if let nameMAker = maker.maker_name {
                        name = nameMAker
                    }
                    if let surname = maker.maker_surname{
                        surnameMaker = surname
                    }
                    if let phoneNumber = maker.phone_number{
                        phoneNumberMaker = phoneNumber
                    }
                    if let email = maker.email {
                        emailMaker = email
                    }
                    if let password = maker.password {
                        passwordMaker = password
                    }
                    let pathImage = maker.path_image
                    let lat = maker.lat
                    let long = maker.long
                    
                    let coordinate = CLLocationCoordinate2D(
                        latitude: lat,
                        longitude: long)
                    let productCategoriesMaker: [ProductCategoryMaker]
                    let productCategories = getAllProductCategoriesMakers(maker: maker)
                    switch productCategories {
                    case.success(let productCategories):
                        productCategoriesMaker = productCategories
                    case .failure(let error):
                        return .failure(error)
                    }
                    
                    let makerAnotation = MakerAnotation(surnameMaker: surnameMaker, nameMaker: name, phoneNumberMaker: phoneNumberMaker, emailMaker: emailMaker, passwordMaker: passwordMaker, pathImageMaker: pathImage, coordinate: coordinate, productCategoriesMaker: productCategoriesMaker)
                    allMakersAnotation.append(makerAnotation)
                }
            }
            return .success(allMakersAnotation)
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
    //get Maker with his phone number
    func getMakerWithPhoneAndEmail(phoneNumber: String, email: String) -> Result<[Maker], Errors> {
        let fetchRequest: NSFetchRequest<Maker> = Maker.fetchRequest()
        let predicatePhone = NSPredicate(format: "%K == %@", #keyPath(Maker.phone_number), phoneNumber)
        let predicateEmail = NSPredicate(format: "%K == %@", #keyPath(Maker.email), email)
        let orPredicate = NSCompoundPredicate(type: .or, subpredicates: [predicatePhone, predicateEmail])
        fetchRequest.predicate = orPredicate
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            return .success(result)
        } catch {
            return .failure(Errors.loadMakersError)
        }
    }
    
    func getMakerWithCoordinate(latitude: Double, long: Double)  -> Result<[Maker], Errors> {
        let fetchRequest: NSFetchRequest<Maker> = Maker.fetchRequest()
        let predicateLong = NSPredicate(format: "%K == %lf", #keyPath(Maker.long), long)
        let predicateLatitude = NSPredicate(format: "%K == %lf", #keyPath(Maker.lat), latitude)
        
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateLatitude, predicateLong])
        fetchRequest.predicate = andPredicate
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            return .success(result)
        } catch {
            return .failure(Errors.loadMakersError)
        }
    }
    
    //get City with name
    func getCityWithName(cityName: String, country: String) -> Result<[CityMaker], Errors> {
        var allCities: [CityMaker] = []
        let countries = getCountry(country: country)
        
        switch countries {
        case.success(let countries):
            // let countries: [AnyObject] = countries
            for country in countries {
                guard let cities = country.country_cities?.allObjects as? [CityMaker]
                else {
                    return .failure(Errors.loadCitiesError)
                }
                
                for city in cities {
                    if city.city_name == cityName {
                        allCities.append(city)
                    }
                }
            }
            return .success(allCities)
            
        case .failure(let error):
            return .failure(error)
        }
    }
    //список категорий продуктов
    func getProductCategories() -> Result<[ProductCategory], Errors> {
        let fetchRequest: NSFetchRequest<ProductCategory> = ProductCategory.fetchRequest()

        //    let predicate = NSPredicate(format: "%K == %@", #keyPath(ProductCategory.category_name), productCategory)
        //    fetchRequest.predicate = predicate
        
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            return .success(result)
        } catch {
            return .failure(Errors.loadProdactCategoryError)
        }
    }
    
    //список категорий продуктов мейкера
    func getProductCategoriesMakers(categoryName: String, maker: Maker) -> Result<[ProductCategoryMaker], Errors> {
        var allCategories: [ProductCategoryMaker] = []
        guard let categories = maker.maker_product_categories?.allObjects as? [ProductCategoryMaker]
        else {
            return .failure(Errors.loadProdactCategoryError)
        }
        
        for category in categories {
            if category.category_name == categoryName {
                allCategories.append(category)
            } else {
                allCategories.append(category)
            }
        }
        return .success(allCategories)
    }
    
    //список категорий продуктов мейкера
    func getAllProductCategoriesMakers(maker: Maker) -> Result<[ProductCategoryMaker], Errors> {
        var allCategories: [ProductCategoryMaker] = []
        guard let categories = maker.maker_product_categories?.allObjects as? [ProductCategoryMaker]
        else {
            return .failure(Errors.loadProdactCategoryError)
        }
        
        for category in categories {
                allCategories.append(category)
        }
        return .success(allCategories)
    }
    
    //удаление категории продуктов мейкера
    func deleteProductCategoriesMakers(categoryName: String?, maker: Maker, productCategory: ProductCategory) -> Result<Bool, Errors> {
        var result = false
        guard let categories = maker.maker_product_categories?.allObjects as? [ProductCategoryMaker]
        else {
            return .failure(Errors.loadProdactCategoryError)
        }
        
        for category in categories {
            if category.category_name == categoryName {
                managedObjectContext.delete(category)
                maker.removeFromMaker_product_categories(category)
                productCategory.removeFromProduct_categorie_maker(category)
                result = true
            }
        }
        return .success(result)
    }
}
