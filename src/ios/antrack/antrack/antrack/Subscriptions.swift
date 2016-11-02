//
//  Subscriptions.swift
//  antrack
//
//  Created by Uriel Tapiwa Munjanga on 19/05/2016.
//  Copyright © 2016 Code Week. All rights reserved.
//

import Foundation
import CoreData


class Subscriptions: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(animalID: String, animalName: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Subscriptions", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        self.aanimalID = animalID
        self.animalName = animalName
    }
}
