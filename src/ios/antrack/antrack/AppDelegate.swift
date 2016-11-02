//
//  AppDelegate.swift
//  antrack
//
//  Created by Stalin Kay on 27/04/2016.
//  Copyright © 2016 Code Week. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GGLInstanceIDDelegate, GCMReceiverDelegate {
    
    //GCM Settings
    var connectedToGCM = false
    var subscribedToTopic = false
    var gcmSenderID: String?
    var registrationToken: String?
    var registrationOptions = [String: AnyObject]()
    let registrationKey = "onRegistrationCompleted"
    let messageKey = "onMessageReceived"
    let subscriptionTopic = "/topics/lion"
    
    
    var window: UIWindow?
    
    /**
     * Change appearance to branding
     */
    func customizeAppearance() {
        
        // UINavigationBar customizations
        UINavigationBar.appearance().barTintColor = UIColor(red: 51.0/255.0, green: 112.0/255.0, blue: 166.0/255.0, alpha: 1.0) // blue
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        // UITableView customizations
        UITableView.appearance().tintColor = UIColor(red: 51.0/255.0, green: 112.0/255.0, blue: 166.0/255.0, alpha: 1.0) // blue
        UITableView.appearance().separatorColor = UIColor.lightTextColor()
//        UITableView.appearance().backgroundColor = UIColor(red: 51.0/255.0, green: 112.0/255.0, blue: 166.0/255.0, alpha: 1.0) // blue
        UITableView.appearance().backgroundColor = UIColor(red: 217.0/255.0, green: 170.0/255.0, blue: 85.0/255.0, alpha: 0.20) // light brown


        UITableViewCell.appearance().backgroundColor = UIColor(red: 217.0/255.0, green: 170.0/255.0, blue: 85.0/255.0, alpha: 0.50) // light brown
        UITableViewCell.appearance().backgroundColor = UIColor(white: 1.0, alpha: 0.8) // light brown

        window?.backgroundColor = UIColor.whiteColor()
        UIApplication.sharedApplication().statusBarHidden = false // with animation option.
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //customize appearance
        customizeAppearance()
        
        // Override point for customization after application launch.
        
        // [START_EXCLUDE]
        // Configure the Google context: parses the GoogleService-Info.plist, and initializes
        // the services that have entries in the file
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        gcmSenderID = GGLContext.sharedInstance().configuration.gcmSenderID
        
        // [END_EXCLUDE]
        
        // Register for remote notifications
        if #available(iOS 8.0, *) {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            // Fallback
            let types: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
            application.registerForRemoteNotificationTypes(types)
        }
        
        //Start GCM Services
        let gcmConfig = GCMConfig.defaultConfig()
        gcmConfig.receiverDelegate = self
        GCMService.sharedInstance().startWithConfig(gcmConfig)
        
        //End GCM Serrvices
        
        // API Call
        
        let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        var dataTask: NSURLSessionDataTask?
        
        let url = NSURL(string: "http://196.216.167.210:5480/api/sightings")
        // 5
        dataTask = defaultSession.dataTaskWithURL(url!) {
            data, response, error in
            // 6
            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            // 7
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("API Call returnned with data below")
                    let jsondata = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print(jsondata)
                    
                }
            }
        }
        // 8
        dataTask?.resume()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.codeweek.antrack" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("antrack", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    
    //Methods for GCM Notification Settings
    
    func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData ) {
        
        // Create a config and set a delegate that implements the GGLInstaceIDDelegate protocol.
        let instanceIDConfig = GGLInstanceIDConfig.defaultConfig()
        instanceIDConfig.delegate = self
        // Start the GGLInstanceID shared instance with that config and request a registration
        // token to enable reception of notifications
        GGLInstanceID.sharedInstance().startWithConfig(instanceIDConfig)
        registrationOptions = [kGGLInstanceIDRegisterAPNSOption:deviceToken,kGGLInstanceIDAPNSServerTypeSandboxOption: false]
        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(gcmSenderID,scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
    }
    
    func subscribeToTopic(subscriptionTopic: String) {
        // If the app has a registration token and is connected to GCM, proceed to subscribe to the
        // topic
        if(registrationToken != nil && connectedToGCM) {
            GCMPubSub.sharedInstance().subscribeWithToken(self.registrationToken, topic: subscriptionTopic,
                                                          options: nil, handler: {(error) -> Void in
                                                            if (error != nil) {
                                                                // Treat the "already subscribed" error more gently
                                                                if error.code == 3001 {
                                                                    print("Already subscribed to \(subscriptionTopic)")
                                                                } else {
                                                                    print("Subscription failed: \(error.localizedDescription)");
                                                                }
                                                            } else {
                                                                self.subscribedToTopic = true;
                                                                NSLog("Subscribed to \(subscriptionTopic)");
                                                            }
            })
        }
    }
    
    func unSubscribeToTopic(unsubscriptionTopic: String) {
        // If the app has a registration token and is connected to GCM, proceed to subscribe to the
        // topic
        if(registrationToken != nil && connectedToGCM) {
            GCMPubSub.sharedInstance().unsubscribeWithToken(self.registrationToken, topic: unsubscriptionTopic,
                                                          options: nil, handler: {(error) -> Void in
                                                            if (error != nil) {
                                                                // Treat the "already subscribed" error more gently
                                                                if error.code == 3001 {
                                                                    print("Already unsubscribed to \(unsubscriptionTopic)")
                                                                } else {
                                                                    print("Unsubscription failed: \(error.localizedDescription)");
                                                                }
                                                            } else {
                                                                self.subscribedToTopic = true;
                                                                NSLog("Unsubscribed to \(unsubscriptionTopic)");
                                                            }
            })
        }
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        //Choose which controller to launch based on the notification
        if identifier == "view" {
            NSNotificationCenter.defaultCenter().postNotificationName("notificationReceived", object: nil, userInfo: userInfo)
            
        }else {
            NSNotificationCenter.defaultCenter().postNotificationName("notificationReceived", object: nil, userInfo: userInfo)
            
        }
        completionHandler()
    }
    
    // [START connect_gcm_service]
    func applicationDidBecomeActive( application: UIApplication) {
        //Reset badge number
        if application.applicationIconBadgeNumber > 0 {
            application.applicationIconBadgeNumber = 0
        }
        //Connect to the GCM server to receive non-APNS notifications
        print("applicationDidBecomeActive")
        GCMService.sharedInstance().connectWithHandler({
            (error) -> Void in
            if error != nil {
                print("Could not connect to GCM: \(error.localizedDescription)")
            } else {
                self.connectedToGCM = true
                print("Connected to GCM")
                // [START_EXCLUDE]
                self.subscribeToTopic(self.subscriptionTopic)
                // [END_EXCLUDE]
            }
        })
    }
    // [END connect_gcm_service]
    
    // [START disconnect_gcm_service]
    func applicationDidEnterBackground(application: UIApplication) {
        GCMService.sharedInstance().disconnect()
        // [START_EXCLUDE]
        self.connectedToGCM = false
        // [END_EXCLUDE]
    }
    // [END disconnect_gcm_service]
    
    //    // [START receive_apns_token_error]
    //    func application( application: UIApplication, didFailToRegisterForRemoteNotificationsWithError
    //        error: NSError ) {
    //        print("Registration for remote notification failed with error: \(error.localizedDescription)")
    //        // [END receive_apns_token_error]
    //        let userInfo = ["error": error.localizedDescription]
    //        NSNotificationCenter.defaultCenter().postNotificationName(
    //            registrationKey, object: nil, userInfo: userInfo)
    //    }
    
    // [START ack_message_reception]
    func application( application: UIApplication,
                      didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("Notification received: \(userInfo)")
        // This works only if the app started the GCM service
        GCMService.sharedInstance().appDidReceiveMessage(userInfo);
        // Handle the received message
        // [START_EXCLUDE]
        if let item = userInfo["from"]{
            //[message: New News Items Available, collapse_key: do_not_collapse, from: /topics/news]
            if (item as! String).containsString("/topics/news"){
                NSNotificationCenter.defaultCenter().postNotificationName("newNewsAvailable", object: nil,
                                                                          userInfo: nil)
                print("Yes new Item available")
            }else {
                print(item as! String)
            }
        }
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 1)
        notification.alertBody = userInfo["message"] as? String
        notification.alertAction = "be awesome!"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = userInfo
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        print("Did receive notification from remote")
        // [END_EXCLUDE]
    }
    
    //    func application( application: UIApplication,
    //                      didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
    //                                                   fetchCompletionHandler handler: (UIBackgroundFetchResult) -> Void) {
    //        print("Notification received: \(userInfo)")
    //        // This works only if the app started the GCM service
    //        GCMService.sharedInstance().appDidReceiveMessage(userInfo);
    //        // Handle the received message
    //        // Invoke the completion handler passing the appropriate UIBackgroundFetchResult value
    //        // [START_EXCLUDE]
    //        NSNotificationCenter.defaultCenter().postNotificationName(messageKey, object: nil,
    //                                                                  userInfo: userInfo)
    //
    //        //To post Notification
    //        //NSNotificationCenter.defaultCenter().postNotificationName("updateFaults", object: nil, userInfo: nil)
    //
    //        //Choose which controller to launch based on the notification using method above
    //
    //        // [END_EXCLUDE]
    //    }
    // [END ack_message_reception]
    
    func registrationHandler(registrationToken: String!, error: NSError!) {
        if (registrationToken != nil) {
            self.registrationToken = registrationToken
            print("Registration Token: \(registrationToken)")
            self.subscribeToTopic(self.subscriptionTopic)
            let userInfo = ["registrationToken": registrationToken]
            NSNotificationCenter.defaultCenter().postNotificationName(
                self.registrationKey, object: nil, userInfo: userInfo)
        } else {
            print("Registration to GCM failed with error: \(error.localizedDescription)")
            let userInfo = ["error": error.localizedDescription]
            NSNotificationCenter.defaultCenter().postNotificationName(
                self.registrationKey, object: nil, userInfo: userInfo)
        }
    }
    
    // [START on_token_refresh]
    func onTokenRefresh() {
        // A rotation of the registration tokens is happening, so the app needs to request a new token.
        print("The GCM registration token needs to be changed.")
        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(gcmSenderID,
                                                                 scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
    }
    
    
    // [END on_token_refresh]
    
    
    func scheduleLocal(sender: AnyObject) {
        let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
        
        if settings!.types == .None {
            let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(ac, animated: true, completion: nil)
            return
        }
        
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 1)
        notification.alertBody = "Wassup"
        notification.alertAction = "This is my action"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["CustomField1": "w00t"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
}

