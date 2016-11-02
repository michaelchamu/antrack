//
//  Utilities.swift
//  antrack
//
//  Created by Uriel Tapiwa Munjanga on 19/05/2016.
//  Copyright © 2016 Code Week. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Utilities: NSObject {
    
    //Allows access and sharing of class attribues
    class var sharedInstance : Utilities {
        struct Static {
            static let instance : Utilities = Utilities()
        }
        return Static.instance
    }
    
    //Context allows manipulation of this. objects
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    //Subscribe to topic
    func subcribe(topic: String){
        (UIApplication.sharedApplication().delegate as! AppDelegate).subscribeToTopic(topic)
    }
    //Unsubscribe to topic
    func unsubscribe(topic: String){
        (UIApplication.sharedApplication().delegate as! AppDelegate).unSubscribeToTopic(topic)
    }
    
    //Subscriptions entity
    let subscriptionsRequest = NSFetchRequest(entityName: "Subscriptions")
    //Sightings Entity
    let sightingsRequest = NSFetchRequest(entityName: "Sightings")
}

//Resize Extension
extension CGSize {
    
    func resizeFill(toSize: CGSize) -> CGSize {
        
        let aspectOne = self.height / self.width
        let aspectTwo = toSize.height / toSize.width
        
        let scale : CGFloat
        
        if aspectOne < aspectTwo {
            scale = self.height / toSize.height
        } else {
            scale = self.width / toSize.width
        }
        
        let newHeight = self.height / scale
        let newWidth = self.width / scale
        return CGSize(width: newWidth, height: newHeight)
        
    }
}

//Scale image to desired size
extension UIImage {
    
    func scale(toSize newSize:CGSize) -> UIImage {
        
        // make sure the new size has the correct aspect ratio
        let aspectFill = self.size.resizeFill(newSize)
        
        UIGraphicsBeginImageContextWithOptions(aspectFill, false, 0.0);
        self.drawInRect(CGRectMake(0, 0, aspectFill.width, aspectFill.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}