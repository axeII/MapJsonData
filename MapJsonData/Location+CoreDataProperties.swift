//
//  Location+CoreDataProperties.swift
//  MapJsonData
//
//  Created by Ales Lerch on 02.04.16.
//  Copyright © 2016 Ales Lerch. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var locDescription: String?
    @NSManaged var locLat: NSNumber?
    @NSManaged var locLong: NSNumber?
    @NSManaged var locName: String?

}
