//
//  DataManager.swift
//  TopApps
//
//  Created by Attila on 2015. 11. 10..
//  Copyright © 2015. -. All rights reserved.
//

import Foundation


let pondURL = "https://www.kimonolabs.com/api/bum7mhvu?apikey=GeAWoH0mNefTT6k8GBjeOxYGsEp2P719"

public class DataManager {
  
 /* public class func getTopAppsDataFromFileWithSuccess(success: ((data: NSData) -> Void)) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
      let filePath = NSBundle.mainBundle().pathForResource("topapps", ofType:"json")
      let data = try! NSData(contentsOfFile:filePath!,
        options: NSDataReadingOptions.DataReadingUncached)
      success(data: data)
    })
  }
 */
    
    //will have to change the code here after february to get it from test file untlil can find a way
    //to write identical json to a webpage
  public class func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
    let session = NSURLSession.sharedSession()
    
    let loadDataTask = session.dataTaskWithURL(url) { (data, response, error) -> Void in
      if let responseError = error {
        completion(data: nil, error: responseError)
      } else if let httpResponse = response as? NSHTTPURLResponse {
        if httpResponse.statusCode != 200 {
          let statusError = NSError(domain:"com.raywenderlich", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
          completion(data: nil, error: statusError)
        } else {
          completion(data: data, error: nil)
        }
      }
    }
    
    loadDataTask.resume()
  }

  public class func getPondDataWithSuccess(success: ((pondData: NSData!) -> Void)) {
    //1 loadDataFromUrl sets the data to whatever it gets from passed url
    loadDataFromURL(NSURL(string: pondURL)!, completion:{(data, error) -> Void in
      //2
      if let data = data {
        //3
        success(pondData: data)
      }
    })
  }
  
}
