//
//  Product+CoreDataClass.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 16/12/22.
//
//

import CoreData
// MARK: - class Product
@objc(Product)
public class Product: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.shared.entityForName(entityName: "Product"),
                  insertInto: CoreDataManager.shared.managedObjectContext)
    }
}
