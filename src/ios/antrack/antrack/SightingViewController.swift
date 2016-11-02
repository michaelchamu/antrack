//
//  SightingViewController.swift
//  antrack
//
//  Created by Stalin Kay on 29/04/2016.
//  Copyright © 2016 Code Week. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class SightingViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate {
    
    //Set Application context
    var context = Utilities.sharedInstance.context

    // set initial location in Etosha
    let initialLocation = CLLocation(latitude: -18.9946, longitude: 15.7522)
    
    //Set map radius range
    let regionRadius: CLLocationDistance = 100000
    
    //Popoverpresentation to modalView Details variable
    var popOverController: UIPopoverPresentationController!
    
    //class variable
    var coordinate: CLLocationCoordinate2D!
    var boundMapRec: MKMapRect!
    let locationManager = CLLocationManager()
    var locationServicesEnabled : Bool?
    var locationHorizontalAccuracy : CLLocationAccuracy?
    var addSiteButton = UIBarButtonItem()
    
    //Outlet objects
    @IBOutlet weak var map: MKMapView!
    @IBOutlet var mapLongPress: UILongPressGestureRecognizer!
    
    var rightBarButton: UIBarButtonItem! {
        didSet {
            
            let icon = UIImage().imageFromSystemBarButton(UIBarButtonSystemItem.Add)
            let iconSize = CGRect(origin: CGPointZero, size: icon.size)
            let iconButton = UIButton(frame: iconSize)
            iconButton.setBackgroundImage(icon, forState: .Normal)
            
            self.rightBarButton.customView = iconButton
            self.rightBarButton.customView!.transform = CGAffineTransformMakeScale(0, 0)
            
            UIView.animateWithDuration(1.0,
                                       delay: 0.5,
                                       usingSpringWithDamping: 0.5,
                                       initialSpringVelocity: 10,
                                       options: .CurveLinear,
                                       animations: {
                                        self.rightBarButton.customView!.transform = CGAffineTransformIdentity
                },
                                       completion: { (finished: Bool) -> Void in
                                        self.rightBarButton.enabled = false
                }
            )    
            
            iconButton.addTarget(self, action: #selector(newPostingBtn(_:)), forControlEvents: .TouchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        map.delegate = self
        map.showsPointsOfInterest = true
        map.showsCompass = true
        
        //center mapview on predefined location above
        centerMapOnLocation(initialLocation)
        
        //Configure Add sighting Button +
        rightBarButton = UIBarButtonItem()
        self.navigationItem.rightBarButtonItem = rightBarButton.self
        
        //Populate map
        if let annotations:[Sightings] = fetchAllPins(){
            for annot in annotations {
                let annotation = MKPointAnnotation()
                annotation.coordinate = annot.coordinate
                annotation.title = annot.keyword
                annotation.subtitle = annot.desc
                map.addAnnotation(annotation)
            }
        }
        
        //Location Settings getting user location if available
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //Verify if location services are enabled
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .NotDetermined, .Restricted, .Denied:
                print("No access")
                locationServicesEnabled = false
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                locationServicesEnabled = true
            }
        } else {
            print("Location services are not enabled")
            // Location services not enabled
            locationServicesEnabled = false
        }
        
        //Show user's current position
        map.showsUserLocation = true
    }
    
    override func viewWillAppear(animated: Bool) {
        //Hide shown toolbar
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Fetch Sighting Pins from database
    func fetchAllPins() -> [Sightings] {
        let request = NSFetchRequest(entityName: "Sightings")
        var results: [AnyObject]!
        do{
            results = try context.executeFetchRequest(request)
        }catch{
            let nserror = error as NSError
            NSLog("Unresolved error in fetch all Pins\(nserror), \(nserror.userInfo)")
        }
        return results as! [Sightings]
    }
    
    //Map
    func centerMapOnLocation(location: CLLocation) {
        //set are of display
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        // Reuse the annotation if possible
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
        if annotationView == nil
        {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        }
        //Get image name from annotation title
        var animal: String!
        if let title = annotation.title{
            if let title = title{
                animal = (title as String).lowercaseString
            }
            
        }
        //Set image for annotation
        annotationView!.image = UIImage(named: animal)
        
        let detailButton: UIButton = UIButton(type: UIButtonType.DetailDisclosure)
        annotationView!.rightCalloutAccessoryView = detailButton
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            performSegueWithIdentifier("detailView", sender: view)
        }
    }
    
    //Open Detail View of Sighting
    func sightingDetailView(sender: UIButton) {
        performSegueWithIdentifier("detailView", sender: self)
    }
    
    //Add new posting + button method
    func newPostingBtn(sender: UIButton) {
        performSegueWithIdentifier("posting", sender: self)
    }
    
    //LongPress on map method
    @IBAction func longPressOnMap(sender: AnyObject) {
        if mapLongPress.state !=  UIGestureRecognizerState.Began {
            return
        }
        if (map.region.span.longitudeDelta < 0.02) {
        let point =  mapLongPress.locationInView(map)
        let touchMapCoordinate = map.convertPoint(point, toCoordinateFromView: map)
        coordinate = touchMapCoordinate
        
        
            UIView.animateWithDuration(0.8, delay:0, options:[UIViewAnimationOptions.Autoreverse, UIViewAnimationOptions.CurveEaseInOut, UIViewAnimationOptions.Repeat, UIViewAnimationOptions.AllowUserInteraction], animations: {
                
                UIView.setAnimationRepeatCount(3)
                self.addSiteButton.customView?.transform = CGAffineTransformMakeScale(1.5, 1.2)
                
                self.view.layoutIfNeeded()
                }, completion: { (finished: Bool) -> Void in
                    self.rightBarButton.enabled = true
                    self.rightBarButton.customView!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 6/5))
                    UIView.animateWithDuration(1.0) {
                        self.rightBarButton.customView!.transform = CGAffineTransformIdentity
                    }
                    
            })
        }else{
            let toastLabel = UILabel(frame: CGRectMake(self.view.frame.size.width/2 - 150, self.view.frame.size.height-100, 300, 35))
            toastLabel.backgroundColor = UIColor.blackColor()
            toastLabel.textColor = UIColor.whiteColor()
            toastLabel.textAlignment = NSTextAlignment.Center;
            self.view.addSubview(toastLabel)
            toastLabel.text = "Sorry Zoom to get a precise location"
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            UIView.animateWithDuration(4.0, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                toastLabel.alpha = 0.0
                }, completion: { (true) in
                    print("Zoom in Required")
            })
            

        }
    }
    
    //Navigation Controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "posting"{
            let destinationVC = segue.destinationViewController as! UploadViewController
            destinationVC.latitude = coordinate.latitude
            destinationVC.longitude = coordinate.longitude
        }
        else if segue.identifier == "detailView"{
            let destinationVC = segue.destinationViewController as! SightingDetailViewController
            destinationVC.animal = (sender as! MKAnnotationView).annotation!.title!
            destinationVC.desc = (sender as! MKAnnotationView).annotation!.subtitle!
            //Get image name from annotation title
            var animal: String!
            if let title = (sender as! MKAnnotationView).annotation!.title{
                if let title = title{
                    animal = (title as String).lowercaseString
                }
                
            }
            if (UIImage(named: (animal+"-1")) != nil){
                destinationVC.image = UIImage(named: (animal+"-1"))!
            }else{
                destinationVC.image = UIImage(named: "No_Image_Available")!
            }
            popOverController = destinationVC.popoverPresentationController
            if popOverController != nil{
                popOverController?.delegate = self
                }        }
        }

}
extension SightingViewController {
    
    //Get User's latest available location
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.last?.horizontalAccuracy)
        locationHorizontalAccuracy = locations.last?.horizontalAccuracy
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    func popoverPresentationControllerDidDismissPopover(popOverController: UIPopoverPresentationController) {
        
    }
}