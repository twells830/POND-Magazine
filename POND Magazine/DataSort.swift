//
//  DataSort.swift
//  POND Magazine
//
//  Created by Tanner Wells on 2/8/16.
//  Copyright © 2016 PONDMAG. All rights reserved.
//

import Foundation
/*
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
*/
var rowNum = 0

var titles = [String]()
var images = [UIImageView]()

class DataSort{
    
    /*class func getEditorialsURL() -> String{
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
    */
    
    class func getRowNum() -> Int{
        return rowNum
    }
    
    class func getTitles() -> [String]{
        return titles
    }
    class func getImages() -> [UIImageView]{
        return images
    }
    /*(maybe use something with the titles so you could wrap all the subview controllers
    into one since they're all gonna be pretty similar)*/
    
    
    //take a look at the tableview functions in testjsonviewcontroller to see if they can be integrated here
    
    
    //titles arary? maybe make a 2d array so that 
                                    //array[i]<=(image source)[i] <==article title
    //or just make two arrays and pull the data from both
    

    
    
    /*
    !!!!!!!!!
    ewi2!ejx ew
    XEHCR E
    !
    MIGHT HAVE TO SCRAP ALL THIS BULLSHIT AND JUST MOVE THIS BACK TO THE ORIGINAL VIEW CONTROLLER
    !
    !
   !!!
    */

    //then call this function to fill in the tables from the other indiviual view controllers

    class func fillTable(url: String){
    
        var JSON: [String: AnyObject]!

        DataManager.getTopAppsDataFromItunesWithSuccess { (data) -> Void in
            do {
                //self because json isn't passed to the viewDidLoad
                JSON = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String: AnyObject]
            } catch {
                print(error)
            }
        }
        //url - get string based on whatever view it's called from
        //tableview - connect to whatever view controller its in
            guard let list = listPage(json: JSON) else {
            print("Error initializing object")
            return
        }
        
        let bodyCount = list.count! - 1
        
        for(var i = 0; i < bodyCount; i++){
            
            let itemURL = list.results?.body![i].url
            if(itemURL == url){
                rowNum++
                let imageSrc = NSURL(string:(list.results?.body![i].image?.imgSrc)!)
                let data = NSData(contentsOfURL: imageSrc!)
                var imageView: UIImageView!
                if data != nil{
                    imageView.image = UIImage(data:data!)
                    images.append(imageView)
                }
                
                guard let item = list.results?.body![i].title?.text else {
                    print("No such item")
                    return
                }
                
                titles.append(item)
            }
        }
    }
}