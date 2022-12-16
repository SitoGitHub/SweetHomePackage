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
    
    func getCountry() -> Result<[CountryMaker], Errors> {
        let fetchRequest: NSFetchRequest<CountryMaker> = CountryMaker.fetchRequest()
        
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
        let countries = getCountry()
        
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
        
        switch cities {
        case.success(let cities):
            for city in cities {
                guard let makers = city.city_makers?.allObjects as? [Maker]
                else {
                    return .failure(Errors.loadMakersError)
                }
                
                for maker in makers {
                    var nameAndSurname = String()
                    if let name = maker.maker_name{
                        nameAndSurname = name
                    }
                    if let surname = maker.maker_surname{
                        nameAndSurname += " " + surname
                    }
                    let coordinate = CLLocationCoordinate2D(
                        latitude: maker.lat as! CLLocationDegrees,
                        longitude: maker.long as! CLLocationDegrees
                    )
                    let MakerAnotation = MakerAnotation(title: nameAndSurname, coordinate: coordinate)
                    
                    allMakersAnotation.append(MakerAnotation)
                }
            }
            return .success(allMakersAnotation)
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
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
