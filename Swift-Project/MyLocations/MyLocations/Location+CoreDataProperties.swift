//
//  Location+CoreDataProperties.swift
//  MyLocations
//
//  Created by 谢乾坤 on 4/18/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreLocation
import CoreData

extension Location {

    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var locationDescription: String
    @NSManaged var placemark: CLPlacemark?
    @NSManaged var category: String
    @NSManaged var date: NSDate
    @NSManaged var photoID: NSNumber?

}
