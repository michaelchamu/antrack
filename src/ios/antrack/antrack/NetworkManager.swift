//
//  NetworkManager.swift
//  antrack
//
//  Created by Uriel Tapiwa Munjanga on 19/05/2016.
//  Copyright © 2016 Code Week. All rights reserved.
//

import Foundation

class NetworkManager {
    var context = Utilities.sharedInstance.context
    
    func apiCallSightings(){
        let url = "http://196.216.167.210:7483/api/sightings"
        
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { data, response, error in
            // Handle result
            do {
                if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        let sightings = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                        DatabaseManager().insertSightingsData(sightings)
                    }
                }
            } catch let error as NSError {
                print("error: \(error.localizedDescription)")
            }
            
            }.resume()
    }
    
    func apiCallTopics(){
        // API Call Sightings
        
        let url = "http://196.216.167.210:7483/api/topics"
        
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { data, response, error in
            // Handle result
            do {
                if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        let subscriptions = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                        DatabaseManager().insertSubscriptionsData(subscriptions)
                    }
                }
            } catch let error as NSError {
                print("error: \(error.localizedDescription)")
            }
            
            }.resume()
        
    }
    
    func apiSendSighting(timestamp:NSDate,latitude:Double,longitude:Double,name:String,topic:String,desc:String){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://196.216.167.210:7483/api/sightings")!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        let location = ["name":name.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),"latitude":"\(latitude)","longitude":"\(longitude)"]
        let params = ["location":location,"keyword": topic.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),"description":desc.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),"timestamp":"\(timestamp)"]
        
        do{
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: .PrettyPrinted)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }catch{
            
        }
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            if let strData = NSString(data: data!, encoding: NSUTF8StringEncoding){
                print("Body: \(strData)")
            }
            
            
        })
        
        task.resume()
    }
}