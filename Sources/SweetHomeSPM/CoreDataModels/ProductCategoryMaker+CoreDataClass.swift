//
//  ProductCategoryMaker+CoreDataClass.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 16/12/22.
//
//

import Foundation
import CoreData

@objc(ProductCategoryMaker)
public class ProductCategoryMaker: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.shared.entityForName(entityName: "Product_category_maker"),
                  insertInto: CoreDataManager.shared.managedObjectContext)
    }
}
