//
//  DataSort.swift
//  POND Magazine
//
//  Created by Tanner Wells on 2/8/16.
//  Copyright © 2016 PONDMAG. All rights reserved.
//

import Foundation

let editorialsURL = "http://www.pond-mag.com/editorials-2/"
let spotlightURL = "http://www.pond-mag.com/spotlight/"
let interviewsURL = "http://www.pond-mag.com/interviews/"
let releasesURL = "http://www.pond-mag.com/releases/"
let reviewsURL = "http://www.pond-mag.com/reviews-1/"
let photographyURL = "http://www.pond-mag.com/photography-1/"
let featuredArtistsURL = "http://www.pond-mag.com/featured-artists/"
//let blogURL = "" not collecting blog
let entertainmentURL = "http://www.pond-mag.com/new-page-4/"
let litZinesURL = "http://www.pond-mag.com/literature-/"


var json: [String: AnyObject]!

class DataSort{

    class func getEditorialsURL() -> String{
        return editorialsURL;
    }
    class func getSpotlightURL() -> String{
        return spotlightURL;
    }
    class func getInterviewsURL() -> String{
        return interviewsURL;
    }
    class func getReleasesURL() -> String{
        return releasesURL;
    }
    class func getReviewsURL() -> String{
        return reviewsURL;
    }
    class func getPhotographyURL() -> String{
        return photographyURL;
    }
    class func getFeaturedArtistsURL() -> String{
        return featuredArtistsURL;
    }
    class func getEntertainmentURL() -> String{
        return entertainmentURL;
    }
    class func getLitZinesURL() -> String{
        return litZinesURL;
    }
    
    /*(maybe use something with the titles so you could wrap all the subview controllers 
    into one since they're all gonna be pretty similar)*/
    
    
    //take a look at the tableview functions in testjsonviewcontroller to see if they can be integrated here
    
    
    //titles arary? maybe make a 2d array so that 
                                    //array[i]<=(image source)[i] <==article title
    //or just make two arrays and pull the data from both
    

    

    //then call this function to fill in the tables from the other indiviual view controllers

    class func fillTable(url: String, tableView: UITableView,
        var titles: [String]){
        
        //url - get string based on whatever view it's called from
        //tableview - connect to whatever view controller its in
            
        guard let list = listPage(json: json) else {
            print("Error initializing object")
            return
        }
        
        let bodyCount = list.count! - 1
        
        for(var i = 0; i < bodyCount; i++){
            
            let itemURL = list.results?.body![i].url
            if(itemURL == url){
                guard let item = list.results?.body![i].title?.text else {
                    print("No such item")
                    return
                }
                
                titles.append(item)
            }
        }
        tableView.reloadData()
        
    }
    
    
    func getData(){
        DataManager.getTopAppsDataFromItunesWithSuccess { (data) -> Void in
            do {
                //self because json isn't passed to the viewDidLoad
                json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as?   [String: AnyObject]
            } catch {
                print(error)
            }
        }
    }
    
    
}