//
//  CityMaker+CoreDataProperties.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 16/12/22.
//
//

import CoreData

// MARK: - extension CityMaker
extension CityMaker {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityMaker> {
        return NSFetchRequest<CityMaker>(entityName: "City")
    }

    @NSManaged public var city_name: String?
    @NSManaged public var cities: CountryMaker?
    @NSManaged public var city_makers: NSSet?

}

// MARK: Generated accessors for city_makers
extension CityMaker {

    @objc(addCity_makersObject:)
    @NSManaged public func addToCity_makers(_ value: Maker)

    @objc(removeCity_makersObject:)
    @NSManaged public func removeFromCity_makers(_ value: Maker)

    @objc(addCity_makers:)
    @NSManaged public func addToCity_makers(_ values: NSSet)

    @objc(removeCity_makers:)
    @NSManaged public func removeFromCity_makers(_ values: NSSet)

}

extension CityMaker : Identifiable {

}
