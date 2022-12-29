//
//  ViewController.swift
//  SweetHomeMap 1.2
//
//  Created by Aleksei Grachev on 7/12/22.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol: AnyObject {
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

final class CoreDataManager: CoreDataManagerProtocol {
    
    static let shared = CoreDataManager()
    
    func entityForName(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext)!
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let bundle = Bundle.module
        guard let modelURL = bundle.url(forResource: "SweetHomeMap_1_2", withExtension: ".momd"), let model = NSManagedObjectModel(contentsOf: modelURL) else { return (NSPersistentContainer())
        }
          let container = NSPersistentCloudKitContainer(name: "SweetHomeMap_1_2", managedObjectModel: model)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = persistentContainer.viewContext

    // MARK: - Core Data Saving support
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
