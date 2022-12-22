//
//  ViewController.swift
//  SweetHomeMap 1.2
//
//  Created by Aleksei Grachev on 7/12/22.
//

import Foundation
import CoreData
import MapKit

extension CoreDataManager {
    
    func getCountry(country: String?) -> Result<[CountryMaker], Errors> {
        let fetchRequest: NSFetchRequest<CountryMaker> = CountryMaker.fetchRequest()
        if let country = country {
            let predicate = NSPredicate(format: "%K == %@", #keyPath(CountryMaker.country_name), country)
            fetchRequest.predicate = predicate
        }
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
//            guard result != nil else {
//                return .failure(Errors.loadMakersError)
//            }
            return .success(result)
        } catch {
            return .failure(Errors.loadCountriesError)
        }
    }
    
//        func getCurrentCountry(country: String) -> Result<[CountryMaker], Errors> {
//            let fetchRequest: NSFetchRequest<CountryMaker> = CountryMaker.fetchRequest()
//            guard let country = country else { return }
//                let predicate = NSPredicate(format: "%K == %@", #keyPath(CountryMaker.country_name), country)
//            fetchRequest.predicate = fetchRequest.predicate
//            
//            do {
//                let result = try managedObjectContext.fetch(fetchRequest)
//    //            guard result != nil else {
//    //                return .failure(Errors.loadMakersError)
//    //            }
//                return .success(result)
//            } catch {
//                return .failure(Errors.loadCountriesError)
//            }
//        }
    
    func getCity() -> Result<[CityMaker], Errors> {
        var allCities: [CityMaker] = []
        let countries = getCountry(country: nil)
        
        switch countries {
        case.success(let countries):
           // let countries: [AnyObject] = countries
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
        //var coordinate: CLLocationCoordinate2D
        
        switch cities {
        case.success(let cities):
            for city in cities {
                guard let makers = city.city_makers?.allObjects as? [Maker]
                else {
                    return .failure(Errors.loadMakersError)
                }
                
                for maker in makers {
                    //var nameAndSurname = String()
                    var name = String()
                    var surnameMaker = String()
                    //let coordinate: CLLocationCoordinate2D
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
                    let urlImage = maker.maker_image
                    let lat = maker.lat as? CLLocationDegrees ?? 0
                    let long = maker.long as? CLLocationDegrees ?? 0
                    
                    let coordinate = CLLocationCoordinate2D(
                            latitude: lat,
                            longitude: long)
                    
                    let makerAnotation = MakerAnotation(surnameMaker: surnameMaker, nameMaker: name, phoneNumberMaker: phoneNumberMaker, emailMaker: emailMaker, passwordMaker: passwordMaker, urlImageMaker: urlImage, coordinate: coordinate)
                    
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
//            guard result != nil else {
//                return .failure(Errors.loadMakersError)
//            }
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
    func getProductCategories(category: String?) -> Result<[ProductCategory], Errors> {
        let fetchRequest: NSFetchRequest<ProductCategory> = ProductCategory.fetchRequest()
        if let productCategory = category {
            let predicate = NSPredicate(format: "%K == %@", #keyPath(ProductCategory.category_name), productCategory)
            fetchRequest.predicate = predicate
        }
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
//            guard result != nil else {
//                return .failure(Errors.loadMakersError)
//            }
            return .success(result)
        } catch {
            return .failure(Errors.loadProdactCategoryError)
        }
    }
    
    //список категорий продуктов мейкера
    func getProductCategoriesMakers(categoryName: String?, maker: Maker) -> Result<[ProductCategoryMaker], Errors> {
        var allCategories: [ProductCategoryMaker] = []
        guard let categories = maker.maker_product_categories?.allObjects as? [ProductCategoryMaker]
        else {
            return .failure(Errors.loadProdactCategoryError)
        }
        
        for category in categories {
            if category.category_name == categoryName {
                allCategories.append(category)
            }
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
    
//    
//    func getCityWithName(cityName: String, country: String) -> Result<[CityMaker], Errors> {
//        let fetchRequest: NSFetchRequest<CityMaker> = CityMaker.fetchRequest()
//        let predicateCityName = NSPredicate(format: "%K == %@", #keyPath(CityMaker.city_name), cityName)
//        let predicateCountryName = NSPredicate(format: "%K == %@", #keyPath(CountryMaker.country_name), country)
//        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateCityName, predicateCountryName])
//        fetchRequest.predicate = andPredicate
//
//        do {
//            let result = try managedObjectContext.fetch(fetchRequest)
//            //            guard result != nil else {
//            //                return .failure(Errors.loadMakersError)
//            //            }
//            return .success(result)
//        } catch {
//            return .failure(Errors.loadMakersError)
//        }
//    }
    
//    func getProdactCategory() -> Result<[Wallet], Errors> {
//
//        let userSettings = getUserSettings()
//
//        switch userSettings {
//
//        case.success(let userSettings):
//
//            let wallets = userSettings.wallets?.allObjects as? [Wallet]
//
//            guard let wallets = wallets else { return .failure(Errors.loadWalletsError) }
//
//            return .success(wallets)
//
//        case .failure(let error):
//
//            return .failure(error)
//
//        }
//
//    }
//
//    func getUserBudgetUnits() -> Result<[BudgetUnit], Errors> {
//
//        let userSettings = getUserSettings()
//
//        switch userSettings {
//
//        case.success(let userSettings):
//
//            let budgetUnits = userSettings.budgetUnits?.allObjects as? [BudgetUnit]
//
//            guard let budgetUnits = budgetUnits else { return .failure(Errors.loadUserBudgetsError) }
//
//            return .success(budgetUnits)
//
//        case .failure(let error):
//
//            return .failure(error)
//
//        }
//
//    }
//
//    func getAllTransactions() -> Result<[Transaction], Errors> {
//
//        var transactions = [Transaction]()
//
//        let wallets = getUserWallets()
//
//        switch wallets {
//
//        case .success(let wallets):
//
//            for wallet in wallets {
//
//                let walletTransactions = wallet.transactions?.allObjects as? [Transaction]
//
//                guard let walletTransactions = walletTransactions else { return .failure(Errors.loadTransactionsError) }
//
//                for walletTransaction in walletTransactions {
//                    transactions.append(walletTransaction)
//                }
//            }
//
//            return .success(transactions)
//
//        case.failure(let error):
//
//            return .failure(error)
//
//        }
//
//    }
//
//    func getTransactionsForWallet(wallet: Wallet) -> Result<[Transaction], Errors> {
//
//        let userWallets = getUserWallets()
//        let currentWalletName = wallet.walletName ?? ""
//
//        var transactions = [Transaction]()
//
//        switch userWallets {
//
//        case .success(let wallets):
//
//            for userWallet in wallets  {
//                if let userWalletName = userWallet.walletName,
//                   userWalletName == currentWalletName {
//
//                    let walletTransactions = userWallet.transactions?.allObjects as? [Transaction]
//
//                    guard let walletTransactions = walletTransactions else { return .failure(Errors.loadTransactionsError) }
//
//                    transactions = walletTransactions
//
//                }
//
//            }
//
//            return .success(transactions)
//
//        case .failure(let error):
//
//            return .failure(error)
//
//        }
//
//
//
//    }
//
//    func deleteTransaction(_ transaction: Transaction) {
//
//        let currentWallet = transaction.wallet!
//
//        currentWallet.removeFromTransactions(transaction)
//
//        managedObjectContext.delete(transaction)
//
//        saveContext()
//
//    }
    
    
}
