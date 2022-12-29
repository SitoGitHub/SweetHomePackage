//
//  ProductCategory+CoreDataProperties.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 16/12/22.
//
//

import CoreData


extension ProductCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductCategory> {
        return NSFetchRequest<ProductCategory>(entityName: "Product_category")
    }

    @NSManaged public var category_image: URL?
    @NSManaged public var category_name: String?
    @NSManaged public var product_categorie_maker: NSSet?

}

// MARK: Generated accessors for product_categorie_maker
extension ProductCategory {

    @objc(addProduct_categorie_makerObject:)
    @NSManaged public func addToProduct_categorie_maker(_ value: ProductCategoryMaker)

    @objc(removeProduct_categorie_makerObject:)
    @NSManaged public func removeFromProduct_categorie_maker(_ value: ProductCategoryMaker)

    @objc(addProduct_categorie_maker:)
    @NSManaged public func addToProduct_categorie_maker(_ values: NSSet)

    @objc(removeProduct_categorie_maker:)
    @NSManaged public func removeFromProduct_categorie_maker(_ values: NSSet)

}

extension ProductCategory : Identifiable {

}
