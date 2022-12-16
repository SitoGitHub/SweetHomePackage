//
//  ViewController.swift
//  SweetHomeMap 1.2
//
//  Created by Aleksei Grachev on 7/12/22.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
 //   init() {
        
 //   }
    
    func entityForName(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext)!
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let bundle = Bundle.module
        guard let modelURL = bundle.url(forResource: "SweetHomeMap_1_2", withExtension: ".momd"), let model = NSManagedObjectModel(contentsOf: modelURL) else { return (NSPersistentContainer())
        }
          let container = NSPersistentCloudKitContainer(name: "SweetHomeMap_1_2", managedObjectModel: model)
        
        //let container = NSPersistentContainer(name: "SweetHomeMap_1_2")
        
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
