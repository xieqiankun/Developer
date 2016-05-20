//
//  triviaMessageMO+CoreDataProperties.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 5/18/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension triviaMessageMO {

    @NSManaged var body: String?
    @NSManaged var date: NSDate?
    @NSManaged var receiver: String?
    @NSManaged var sender: String?
    @NSManaged var userName: String?

}
