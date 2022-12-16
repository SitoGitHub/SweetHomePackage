//
//  CountryMaker+CoreDataProperties.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 16/12/22.
//
//

import Foundation
import CoreData


extension CountryMaker {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CountryMaker> {
        return NSFetchRequest<CountryMaker>(entityName: "Country")
    }

    @NSManaged public var country_name: String?
    @NSManaged public var country_cities: NSSet?

}

// MARK: Generated accessors for country_cities
extension CountryMaker {

    @objc(addCountry_citiesObject:)
    @NSManaged public func addToCountry_cities(_ value: CityMaker)

    @objc(removeCountry_citiesObject:)
    @NSManaged public func removeFromCountry_cities(_ value: CityMaker)

    @objc(addCountry_cities:)
    @NSManaged public func addToCountry_cities(_ values: NSSet)

    @objc(removeCountry_cities:)
    @NSManaged public func removeFromCountry_cities(_ values: NSSet)

}

extension CountryMaker : Identifiable {

}
