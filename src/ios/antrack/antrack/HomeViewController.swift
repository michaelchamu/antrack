//
//  HomeViewController.swift
//  antrack
//
//  Created by Stalin Kay on 28/04/2016.
//  Copyright © 2016 Code Week. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    
    let items = ["Subscriptions", "Sightings", "Upload Sightings", "Summary"] // menu items
    let descriptions = ["Subscribe to get notified about sightings", "View Sightings", "Post your sightings", "A summary of your days sightings"] // menu items
    let imageNames = ["elephant-1", "giraffe-1", "lion-1", "zebra-1"] // menu items
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        //TODO: Testig calls
        NetworkManager().apiCallSightings()
        NetworkManager().apiCallTopics()
        // add backgroundView with backgrounColor
        //        self.tableView.backgroundView = UIView(frame: self.tableView.frame)
        //        self.tableView.backgroundView?.backgroundColor = UIColor(red: 217.0/255.0, green: 170.0/255.0, blue: 85.0/255.0, alpha: 0.20) // light brown
        self.tableView.rowHeight = 88.0
        
        self.tableView.cellLayoutMarginsFollowReadableWidth = false
        self.tableView.contentInset = UIEdgeInsetsZero
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        self.title = "antrack"
    }
    
    override func viewWillAppear(animated: Bool) {
        //Hide shown toolbar
        self.navigationController?.setToolbarHidden(true, animated: true)
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
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell
        
        let item = items[indexPath.row] // menu item
        let description = descriptions[indexPath.row] // menu item
        
        
        cell = tableView.dequeueReusableCellWithIdentifier(item.stringByReplacingOccurrencesOfString(" ", withString: ""), forIndexPath: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = item
        cell.detailTextLabel?.text = description
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // Customize cell apperance
        cell.textLabel?.textColor = UIColor(red: 85.0/255.0, green: 135.0/255.0, blue: 217.0/255.0, alpha: 1.0) // dark neon purple
        cell.textLabel?.textColor = UIColor(red: 2.0/255.0, green: 51.0/255.0, blue: 115.0/255.0, alpha: 1.0) // dark blue
        cell.textLabel?.textColor = UIColor(red: 51.0/255.0, green: 112.0/255.0, blue: 166.0/255.0, alpha: 1.0) // blue
        cell.textLabel?.textColor = UIColor(red: 217.0/255.0, green: 170.0/255.0, blue: 85.0/255.0, alpha: 1.0) // light brown
        
        cell.detailTextLabel?.textColor = UIColor.lightTextColor()
        cell.detailTextLabel?.textColor = UIColor(red: 107.0/255.0, green: 128.0/255.0, blue: 241.0/255.0, alpha: 1.0) // neon purple
        cell.detailTextLabel?.textColor = UIColor.lightGrayColor()
        
        // label background
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.detailTextLabel?.backgroundColor = UIColor.clearColor()
        
        let imageName = imageNames[indexPath.row]
        let image = UIImage(named:  imageName)
        if (image != nil) {
            
            let cellHeight = CGRectGetHeight(cell.frame)
            let spacer = CGFloat(24)
            let size = cellHeight - spacer
            let newImage = resizeImage(image!, toTheSize: CGSizeMake(size, size))
            let cellImageLayer: CALayer?  = cell.imageView!.layer
            cellImageLayer?.cornerRadius = size/2
            cellImageLayer?.masksToBounds = true
            cell.imageView?.image = newImage
            
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
        
    }
    
    func resizeImage(image:UIImage, toTheSize size:CGSize)->UIImage{
        
        let scale = CGFloat(max(size.width/image.size.width,
            size.height/image.size.height))
        let width:CGFloat  = image.size.width * scale
        let height:CGFloat = image.size.height * scale;
        
        let rr:CGRect = CGRectMake((size.width-width)/2, 0, width, height); // centered otherwise use 0,0, width, height
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        image.drawInRect(rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let cell = sender as? UITableViewCell {
            let i = self.tableView.indexPathForCell(cell)!.row
            segue.destinationViewController.title = items[i]
        }
        
    }
    
}
