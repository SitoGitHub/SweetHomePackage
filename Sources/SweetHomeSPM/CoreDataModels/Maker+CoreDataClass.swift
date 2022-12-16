//
//  Maker+CoreDataClass.swift
//  SweetHomeWithSPM 1.6
//
//  Created by Aleksei Grachev on 16/12/22.
//
//

import Foundation
import CoreData

@objc(Maker)
public class Maker: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.shared.entityForName(entityName: "Maker"),
                  insertInto: CoreDataManager.shared.managedObjectContext)
    }
}
