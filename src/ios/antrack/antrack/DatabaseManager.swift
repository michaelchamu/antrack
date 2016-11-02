//
//  DatabaseManager.swift
//  antrack
//
//  Created by Uriel Tapiwa Munjanga on 19/05/2016.
//  Copyright © 2016 Code Week. All rights reserved.
//

import Foundation
import CoreData

class DatabaseManager {
    
    let context = Utilities.sharedInstance.context
    
    func insertSightingsData(sights: AnyObject){
        let sightsArray = sights as! NSArray
        for i in 0..<sightsArray.count {
            
            //Filter the  sightings core Data on id to see if site already exists
            let filterRequest = NSFetchRequest(entityName: "Sightings")
            let filter = sightsArray[i].objectForKey("_id") as! String
            filterRequest.predicate = NSPredicate(format: "id == %@", filter)
            
            //Retrieve sightings from coredata
            do{
                let results = try self.context.executeFetchRequest(filterRequest) as! [Sightings]
                
                //If results.count == 0 item does not exist therefore insert
                if results.count == 0 {
                    
                    //Values
                    var latitude:Double{
                        if let latitude = sightsArray[i].objectForKey("location")?.objectForKey("latitude"){
                            return latitude as! Double
                        }else{
                            return 0
                        }
                    }
                    
                    //Check if latitude is not zero and do not insert record
                    if latitude.isZero{
                        continue
                    }
                    var longitude:Double{
                        if let longitude = sightsArray[i].objectForKey("location")?.objectForKey("longitude"){
                            return longitude as! Double
                        }else{
                            return 0
                        }
                    }
                    //Check if latitude is not zero and do not insert record
                    if longitude.isZero{
                        continue
                    }
                    var name: String {
                     if let name = sightsArray[i].objectForKey("location")?.objectForKey("name"){
                        return name as! String
                     }else{
                        return ""
                        }
                    }
                    var desc:String{
                        if let desc = sightsArray[i].objectForKey("description"){
                            return desc as! String
                        }else{
                            return ""
                        }
                    }
                    var keyword:String{
                        if let keyword = sightsArray[i].objectForKey("keyword"){
                            return keyword as! String
                        }else{
                            return ""
                        }
                    }
                    var id:String{
                        if let _id = sightsArray[i].objectForKey("_id"){
                            return _id as! String
                        }else{
                            return ""
                        }
                    }
                    var timestamp:String{
                        if let timestamp = sightsArray[i].objectForKey("timestamp"){
                            return timestamp as! String
                        }else{
                            return ""
                        }
                    }
                    
                    _ = Sightings(latitude: latitude, longitude: longitude, name: name, keyword: keyword, timestamp: timestamp, description: desc, id: id, context: context)
                    
                    do{
                        try context.save()
                    }catch let error as NSError {
                        print("error: \(error.localizedDescription)")
                    }
                }
                
            }catch let error as NSError {
                print("error: \(error.localizedDescription)")
                
            }
        }
    }
    
    //Inserting Subscription Table with data from server
    func insertSubscriptionsData(subs: AnyObject){
        let subscrip = subs["english"] as! NSArray
        for i in 0..<subscrip.count {
            //Filter the  subscriptions core Data on animalID to see if animal already exists
            let filterRequest = NSFetchRequest(entityName: "Subscriptions")
            let filter = subscrip[i] as! String
            filterRequest.predicate = NSPredicate(format: "aanimalID == %@", filter)

            //Retrieve subscriptions from coredata
            do{
            let results = try self.context.executeFetchRequest(filterRequest) as! [Subscriptions]
            
            if results.count == 0 {
                
                //Insert Subscription into coredata if they do not exists
                _ = Subscriptions(animalID: (subscrip[i] as? String)!, animalName: (subscrip[i] as? String)!, context: context)
                //Save changes to Subscriptions coreData
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                }

                }
            }catch let error as NSError {
                    print("error: \(error.localizedDescription)")
            }
            

        }
    }
}