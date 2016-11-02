//
//  SubscriptionViewController.swift
//  antrack
//
//  Created by Stalin Kay on 29/04/2016.
//  Copyright © 2016 Code Week. All rights reserved.
//

import UIKit
import CoreData

class SubscriptionViewController: UITableViewController {
    
    let context = Utilities.sharedInstance.context
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        fetchAllPins()
    }
    
    //Fetch Sighting Pins from database
    func fetchAllPins() -> [Subscriptions] {
        let fetchRequest = NSFetchRequest(entityName: "Subscriptions")
        var results:[Subscriptions] = []
        do{
            results = try context.executeFetchRequest(fetchRequest) as! [Subscriptions]
        }catch{
            let nserror = error as NSError
            NSLog("Unresolved error in fetch all Pins\(nserror), \(nserror.userInfo)")
        }
        return results
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let rows = SubscriptionSingleton.current().frc.sections?[section].numberOfObjects
        
        return rows!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SubscriptionIdentifier", forIndexPath: indexPath)
        
        let subscriptions = SubscriptionSingleton.current().frc.objectAtIndexPath(indexPath) as! Subscriptions
        
        // Configure the cell...
        
        cell.textLabel?.text = subscriptions.animalName
        let name = "\(subscriptions.animalName!)"
        let filename = "\(name.lowercaseString).png"
        let image = UIImage(named:  filename)
            
        if (image != nil) {
            cell.imageView!.image = image;
        }else{
            cell.imageView!.image = nil;
        }

        
        //Check if user is subscribed to keyword and display accordingly
        if subscriptions.subscribedTo == true {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.imageView?.alpha = 0.0
        // animate cell
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,0.1)
        UIView.animateWithDuration(0.5, animations: {
            cell.layer.transform = CATransform3DMakeScale(1.10,1.10,1.10)
            },completion: { finished in
                UIView.animateWithDuration(0.1, animations: {
                    cell.layer.transform = CATransform3DMakeScale(1,1,1)
                    cell.imageView?.alpha = 1.0
                })
        })

        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let subscriptions = SubscriptionSingleton.current().frc.objectAtIndexPath(indexPath) as! Subscriptions
        if  (subscriptions.aanimalID != nil) {
            SubscriptionSingleton.sharedInstance.subscribeStatusChange(subscriptions.aanimalID!)
            self.tableView.reloadData()
            
            if (subscriptions.subscribedTo == true) { // subscribed
            //Utilities().subscribeToTopic(subscriptions.animalName)
                let alert = UIAlertController(title: "Subscribed", message: "You will be receiving notifications when a " + subscriptions.animalName! + " is spotted.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else { // unsubscribed
                let alert = UIAlertController(title: "Unsubscribed", message: "You will no longer be receiving notifications when a " + subscriptions.animalName! + " is spotted.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: ";-(", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
