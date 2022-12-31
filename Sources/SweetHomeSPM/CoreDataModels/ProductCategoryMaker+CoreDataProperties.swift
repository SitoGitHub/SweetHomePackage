//
//  ProductCategoryMaker+CoreDataProperties.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 16/12/22.
//
//

import CoreData

// MARK: - extension ProductCategoryMaker
extension ProductCategoryMaker {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductCategoryMaker> {
        return NSFetchRequest<ProductCategoryMaker>(entityName: "Product_category_maker")
    }

    @NSManaged public var category_name: String?
    @NSManaged public var maker: Maker?
    @NSManaged public var product: NSSet?
    @NSManaged public var product_categories: ProductCategory?

}

// MARK: Generated accessors for product
extension ProductCategoryMaker {

    @objc(addProductObject:)
    @NSManaged public func addToProduct(_ value: Product)

    @objc(removeProductObject:)
    @NSManaged public func removeFromProduct(_ value: Product)

    @objc(addProduct:)
    @NSManaged public func addToProduct(_ values: NSSet)

    @objc(removeProduct:)
    @NSManaged public func removeFromProduct(_ values: NSSet)

}

extension ProductCategoryMaker : Identifiable {

}
