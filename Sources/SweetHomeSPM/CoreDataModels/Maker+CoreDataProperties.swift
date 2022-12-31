//
//  Maker+CoreDataProperties.swift
//  SweetHomeWithSPM 2.0
//
//  Created by Aleksei Grachev on 25/12/22.
//
//

import CoreData

// MARK: - extension Maker
extension Maker {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Maker> {
        return NSFetchRequest<Maker>(entityName: "Maker")
    }

    @NSManaged public var date: Date?
    @NSManaged public var email: String?
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var maker_image: URL?
    @NSManaged public var maker_name: String?
    @NSManaged public var maker_surname: String?
    @NSManaged public var password: String?
    @NSManaged public var phone_number: String?
    @NSManaged public var path_image: String?
    @NSManaged public var maker_city: CityMaker?
    @NSManaged public var maker_product_categories: NSSet?

}

// MARK: Generated accessors for maker_product_categories
extension Maker {

    @objc(addMaker_product_categoriesObject:)
    @NSManaged public func addToMaker_product_categories(_ value: ProductCategoryMaker)

    @objc(removeMaker_product_categoriesObject:)
    @NSManaged public func removeFromMaker_product_categories(_ value: ProductCategoryMaker)

    @objc(addMaker_product_categories:)
    @NSManaged public func addToMaker_product_categories(_ values: NSSet)

    @objc(removeMaker_product_categories:)
    @NSManaged public func removeFromMaker_product_categories(_ values: NSSet)

}

extension Maker : Identifiable {

}
