//
//  CityMaker+CoreDataClass.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 16/12/22.
//
//

import Foundation
import CoreData

@objc(CityMaker)
public class CityMaker: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.shared.entityForName(entityName: "City"),
                  insertInto: CoreDataManager.shared.managedObjectContext)
    }
}
