//
//  ProductCategory+CoreDataClass.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 16/12/22.
//
//

import Foundation
import CoreData

@objc(ProductCategory)
public class ProductCategory: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.shared.entityForName(entityName: "Product_category"),
                  insertInto: CoreDataManager.shared.managedObjectContext)
    }
}
