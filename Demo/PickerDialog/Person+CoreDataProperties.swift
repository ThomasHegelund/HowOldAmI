//
//  Person+CoreDataProperties.swift
//  DatePickerDialogExample
//
//  Created by Thomas Hegelund on 14/09/2016.
//  Copyright © 2016 vinicius. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Person {

    @NSManaged var age: Date?
    @NSManaged var name: String?

}
