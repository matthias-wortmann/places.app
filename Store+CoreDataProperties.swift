//
//  Store+CoreDataProperties.swift
//  Places
//
//  Created by Matthias Wortmann on 01.07.16.
//  Copyright © 2016 Matthias Wortmann. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData


extension Store {

    @NSManaged var storeLat: NSNumber
    @NSManaged var storeLng: NSNumber
    @NSManaged var storeName: String

}
