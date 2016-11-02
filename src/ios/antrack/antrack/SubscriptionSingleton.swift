//
//  SubscriptionSingleton.swift
//  antrack
//
//  Created by Uriel Tapiwa Munjanga on 12/05/2016.
//  Copyright © 2016 Code Week. All rights reserved.
//

import UIKit
import CoreData

class SubscriptionSingleton: NSObject, NSFetchedResultsControllerDelegate {

    //Allows Access to class attribues
    class var sharedInstance : SubscriptionSingleton {
        struct Static {
            static let instance : SubscriptionSingleton = SubscriptionSingleton(frc: NSFetchedResultsController())
        }
        return Static.instance
    }
    
    //CONSTANTS
    let context = Utilities.sharedInstance.context
    
    //Variables
    var frc: NSFetchedResultsController = NSFetchedResultsController()
    
    static var data: SubscriptionSingleton?
    
    init(frc: NSFetchedResultsController){
        super.init()
        self.frc = getSubs()
    }
    
    static func current() -> SubscriptionSingleton{
        if data == nil {
            data = SubscriptionSingleton(frc: NSFetchedResultsController())
        }
        return data!
    }
    
    func getSubs() -> NSFetchedResultsController{
        frc = getFetchedResultsController()
        frc.delegate = self
        do{
            try frc.performFetch()
        }catch{
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        return frc
    }
    
    //Fetch Controller for Coredata
    func getFetchedResultsController() -> NSFetchedResultsController{
        frc = NSFetchedResultsController(fetchRequest: subscriptionFetch(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }
    
    //Fetch Subscriptions
    func subscriptionFetch() -> NSFetchRequest {
        
        let fetchRequest = Utilities.sharedInstance.subscriptionsRequest
        let primarySortDescriptor = NSSortDescriptor(key: "animalName", ascending: true)
        fetchRequest.sortDescriptors = [primarySortDescriptor]
        
        return fetchRequest
    }
    
    //Reset Singleton
    func resetSharedInstance(){
        SubscriptionSingleton.data = nil
    }
    
    func subscribeStatusChange(id: String){
        let fetchRequest = NSFetchRequest(entityName: "Subscriptions")
        fetchRequest.predicate = NSPredicate(format: "aanimalID == %@", id)
        do {
            let subscription = try context.executeFetchRequest(fetchRequest) as! [Subscriptions]
            //let subscription = results as! [Subscriptions]
            
            if subscription[0].subscribedTo == true {
                subscription[0].setValue(false, forKey: "subscribedTo")
            }else{
                subscription[0].setValue(true, forKey: "subscribedTo")
            }
            try context.save()
        } catch {
            print("Could not fetch data \(error)")
        }
    }
    
    //Get CoreData methods
    func getSubscriptions() -> [Subscriptions]{
        let fetchRequest = NSFetchRequest(entityName: "Subscriptions")
        do {
            let subscription = try context.executeFetchRequest(fetchRequest) as! [Subscriptions]
            print(subscription)
            return subscription
        } catch {
            print("Could not fetch data \(error)")
            return []
        }
        
    }
}
