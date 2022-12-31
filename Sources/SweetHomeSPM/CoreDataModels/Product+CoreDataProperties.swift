//
//  Product+CoreDataProperties.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 16/12/22.
//
//

import CoreData

// MARK: - extension Product
extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var product_image: URL?
    @NSManaged public var product_name: String?
    @NSManaged public var product_price: NSDecimalNumber?
    @NSManaged public var products_category_maker: ProductCategoryMaker?

}

extension Product : Identifiable {

}
