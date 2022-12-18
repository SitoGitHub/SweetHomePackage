//
//  modelUser.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 28/11/22.
//

import Foundation
import UIKit
import  MapKit

public class ModelUser {
    public var users = [[User]]()
    //let bakers:
    var coreDataManager = CoreDataManager.shared
    //var bakers: Baker?
    init () {
        setup()
    }
//
    func setup() {
     //   addMaker()
        
     //   let bakers = coreDataManager.getBaker()
     //   bakers
        let man1 = User(name: "Grisha", city: "Moscow",
                        //image: UIImage(named: "GrigorijGrachev2021")!,
                        gender: .male, coordinate: CLLocationCoordinate2D(latitude: 37.789834, longitude: -122.401417))
        let man2 = User(name: "Serega", city: "Moscow",
                        //image: UIImage(named: "Sergey")!,
                        gender: .male, coordinate: CLLocationCoordinate2D(latitude: 37.782834, longitude: -122.411417))
        let manArray = [man1, man2]
        users.append(manArray)
    }
    
    
    func addMaker() {
        
        
    //    let coreDataManager = CoreDataManager.shared
        
        let makerGrigoriy = Maker()
        makerGrigoriy.maker_name = "Grigoriy"
        makerGrigoriy.maker_surname = "Grachev"
        //bakerGrigoriy.baker_product_categories = ["Торты"]
        makerGrigoriy.date = Date()
        makerGrigoriy.lat = 37.789834
        makerGrigoriy.long = -122.401417
        makerGrigoriy.phone_number = "79852222222"
        makerGrigoriy.maker_city
        
        let makerSergei = Maker()
        makerSergei.maker_name = "Sergei"
        makerSergei.maker_surname = "Grachev"
       // bakerSergei.baker_product_categories = ["Торты"]
        makerSergei.date = Date()
        makerSergei.lat = 37.782834
        makerSergei.long = -122.411417
        makerSergei.phone_number = "79851111111"
  
        let city = CityMaker()
        city.city_name = "Москва"
        city.addToCity_makers([makerSergei, makerGrigoriy])
   
        let country = CountryMaker()
        country.country_name = "Россия"
        country.addToCountry_cities([city])
    
        coreDataManager.saveContext()
        
//        userSettings.incomeCategoriesID = incomeCategoriesID
//        userSettings.expenseCategoriesID = expenseCaregoriesID
//
//        for walletModel in wallets {
//
//            let walletManagedObject = Wallet()
//            walletManagedObject.isActive = true
//            walletManagedObject.walletName = walletModel.walletName
//            walletManagedObject.balance = NSDecimalNumber(decimal: walletModel.balance)
//            walletManagedObject.user = userSettings
//            userSettings.addToWallets(walletManagedObject)
//
//        }
//
//        for budgetModel in budgets {
//
//            let budgetManagedObject = BudgetUnit()
//            budgetManagedObject.categoryID = budgetModel.categoryID
//            budgetManagedObject.budget = NSDecimalNumber(decimal: budgetModel.budget ?? 0)
//            budgetManagedObject.user = userSettings
//            userSettings.addToBudgetUnits(budgetManagedObject)
//        }
//
//        coreDataManager.saveContext()
//
//
//        UserDefaults.standard.set(true, forKey: "startSetup")
    }
    
}

