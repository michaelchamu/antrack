//
//  MapDetailViewController.swift
//  antrack
//
//  Created by Stalin Kay on 29/04/2016.
//  Copyright © 2016 Code Week. All rights reserved.
//

import UIKit

class SightingDetailViewController: UIViewController {
    
    @IBOutlet weak var detailSiteImage: UIImageView!
    @IBOutlet weak var animalName: UILabel!
    @IBOutlet weak var animalDescription: UILabel!
    
    //Class Variables
    var animal: String!
    var desc: String!
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animalName.text = animal
        animalDescription.text = desc
        if image == UIImage(named: "No_Image_Available")! {
            detailSiteImage.image = image
            detailSiteImage.contentMode = .ScaleAspectFit
        }else{
            detailSiteImage.image = image
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
