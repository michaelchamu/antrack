//
//  UploadViewController.swift
//  antrack
//
//  Created by Stalin Kay on 29/04/2016.
//  Copyright © 2016 Code Week. All rights reserved.
//

import UIKit
import CoreLocation
import Photos
import AssetsLibrary

class UploadViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //VARIABLES
    var TYPE = "CAMERA"
    var picker = UIPickerView()
    let imagePicker = UIImagePickerController()
    let cameraPicker = UIImagePickerController()
    var coordinate: CLLocationCoordinate2D!
    var latitude:CLLocationDegrees!
    var longitude:CLLocationDegrees!
    
    //Outlets
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var animalPickerView: UIPickerView!
    @IBOutlet weak var animal: UITextField!
    @IBOutlet weak var animalImage: UIImageView!
    @IBOutlet weak var cameraBtnOutlet: UIButton!
    @IBOutlet weak var locationName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        
        //Set Delegates
        animal.delegate = self
        picker.delegate = self
        picker.dataSource = self
        imagePicker.delegate = self
        cameraPicker.delegate = self
        
        animal.inputView = picker
        animalPickerView.hidden = true
        
        //Show hidden toolbar
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.cameraBtnOutlet.setImage(UIImage().imageFromSystemBarButton(UIBarButtonSystemItem.Camera), forState: .Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Perfom action when Camera Button is clicked
    @IBAction func cameraButton(sender: AnyObject) {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil || UIImagePickerController.availableCaptureModesForCameraDevice(.Front) != nil{
            TYPE = "CAMERA"
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.cameraCaptureMode = .Photo
            imagePicker.modalPresentationStyle = .FullScreen
            presentViewController(imagePicker,
                                  animated: true,
                                  completion: nil)
        }else{
            noCamera()
        }
    }
    
    //Perfom action when Photo from Gallery button is clicked
    
    @IBAction func galleryPhoto(sender: UIButton) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.NotDetermined || PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.Authorized
        {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .PhotoLibrary
            TYPE = "GALLERY"
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
            else {
                imagePicker.modalPresentationStyle = .Popover
                presentViewController(imagePicker, animated: true, completion: nil)//4
                imagePicker.popoverPresentationController?.sourceView = sender
                
                imagePicker.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.Left
                imagePicker.popoverPresentationController?.sourceRect = CGRect(x: 80, y: 10, width: 0, height: 0)
                
            }
        }
        else if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.Denied
        {
            turnOnGallery()
        }
        
        
    }
    
    //NO CAMERA FOUND
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .Alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.Default,
            handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC,
                              animated: true,
                              completion: nil)
    }
    
    func turnOnGallery(){
        let alertVC = UIAlertController(
            title: "Photo Library Unavailable",
            message: "Please check device settings to allow photo library access",
            preferredStyle: .Alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.Default,
            handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .Destructive) { (_) -> Void in
            let settingsUrl = NSURL(string:UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        alertVC.addAction(okAction)
        alertVC.addAction(settingsAction)
        presentViewController(alertVC,
                              animated: true,
                              completion: nil)
    }
    
    //Image setup
    //MARK: Delegates
    
    func imagePickerController(imagePicker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if imagePicker.sourceType == UIImagePickerControllerSourceType.Camera{
            _ = info[UIImagePickerControllerOriginalImage]as! UIImage
            
            let library = ALAssetsLibrary()
            let url:NSURL = info[UIImagePickerControllerReferenceURL] as! NSURL
            
            library.assetForURL(url, resultBlock: {
                (asset:ALAsset!) in
                if asset.valueForProperty(ALAssetPropertyLocation) != nil {
                    self.latitude = (asset.valueForProperty(ALAssetPropertyLocation) as! CLLocation).coordinate.latitude
                    self.longitude = (asset.valueForProperty(ALAssetPropertyLocation) as! CLLocation).coordinate.longitude
                }
                }, failureBlock: {
                    (error:NSError!) in
                    NSLog("Error!")
            })
        }
        
        let capturedImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        let displayImage = capturedImage.scale(toSize: self.animalImage.frame.size)
        animalImage.contentMode = .ScaleToFill
        animalImage.image = displayImage
        animalImage.backgroundColor = UIColor.clearColor()
        animalImage.userInteractionEnabled = true
        
        dismissViewControllerAnimated(true, completion: nil) //5
        
    }
    
    //Cancel Image Picker
    func imagePickerControllerDidCancel(imagePicker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //End editing when parent view is clicked
    @IBAction func endEditing(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    //MARK:- PickerView
    //Number of Components in pickerView Datasource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Number of Items in picker View Datasource
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let rows = SubscriptionSingleton.current().frc.sections?[component].numberOfObjects
        
        return rows!
    }
    
    //Select title to display for each row int picker datasource
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let animal = SubscriptionSingleton.current().frc.sections![component].objects![row] as! Subscriptions
        return animal.animalName
    }
    
    //Perfom action when pickview did select ends
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let animal = SubscriptionSingleton.current().frc.sections![component].objects![row] as! Subscriptions
        self.animal.text = animal.animalName
    }
    
    
    // MARK: - Navigation
    
    @IBAction func postNewSighting(sender: UIBarButtonItem) {
        let name:String!
        let description:String!
        let location:String!
        
        name = self.animal.text
        description = self.descriptionTextView.text
        location = self.locationName.text
        
        //Get Current Timestamp
        let date : NSDate = NSDate()
        //If image is nil do not perfom send
        //Location will be empty
        if self.animalImage.image != nil {
            NetworkManager().apiSendSighting(date, latitude: self.latitude as Double, longitude: self.longitude as Double, name: location, topic: name, desc: description)
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
extension UIImage {
    func imageFromSystemBarButton(systemItem: UIBarButtonSystemItem) -> UIImage {
        let tempItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: nil, action: nil)
        
        //Add to tollbar and render it.
        UIToolbar().setItems([tempItem], animated: false)
        
        //got image from real uiBtton
        let itemView = tempItem.valueForKey("view") as! UIView
        for view in itemView.subviews {
            if view.isKindOfClass(UIButton){
                let button = view as! UIButton
                return button.imageView!.image!
            }
        }
        return UIImage()
    }
}