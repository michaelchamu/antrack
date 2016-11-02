//
//  Subscriptions+CoreDataProperties.swift
//  antrack
//
//  Created by Uriel Tapiwa Munjanga on 19/05/2016.
//  Copyright © 2016 Code Week. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Subscriptions {

    @NSManaged var aanimalID: String?
    @NSManaged var animalName: String?
    @NSManaged var subscribedTo: NSNumber?

}
