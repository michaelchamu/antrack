//
//  Sightings.swift
//  antrack
//
//  Created by Uriel Tapiwa Munjanga on 19/05/2016.
//  Copyright © 2016 Code Week. All rights reserved.
//

import Foundation
import CoreData
import MapKit

@objc(Sightings)
class Sightings: NSManagedObject, MKAnnotation {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(latitude: Double, longitude: Double, name: String, keyword: String, timestamp: String, description: String, id: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Sightings", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        self.latitude = NSNumber(double: latitude)
        self.longitude = NSNumber(double: longitude)
        self.name = name
        self.desc = description
        self.timestamp = timestamp
        self.id = id
        self.keyword = keyword
    }
    var coordinate1: MKPointAnnotation {
        let me = MKPointAnnotation()
        me.coordinate = coordinate
        me.title = keyword
        me.subtitle = desc
        return me
    }
    
    var coordinate: CLLocationCoordinate2D {
        
        return CLLocationCoordinate2D(latitude: latitude as! Double, longitude: longitude as! Double)
    }
}
