//
//  CountryMaker+CoreDataClass.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 16/12/22.
//
//

import CoreData

@objc(CountryMaker)
public class CountryMaker: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.shared.entityForName(entityName: "Country"),
                  insertInto: CoreDataManager.shared.managedObjectContext)
    }
}
