//
//  LoadViewController.swift
//  POND Magazine
//
//  Created by Tanner Wells on 2/28/16.
//  Copyright © 2016 PONDMAG. All rights reserved.
//

import Foundation
import CoreData

class LoadViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var json: [String: AnyObject]!
        print("before data manager")
        //GET ALL THE JSON
        DataManager.getPondDataWithSuccess { (data) -> Void in //something is breaking up here
            print("inside data manager")
            do {
                json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String: AnyObject] //fails right here
            } catch {
                print(error) //prints error
            }
            //MAKE A LIST AND SET THE DATA TO VAR TO GET NEW COUNT
            let list = listPage(json: json),
            ver = list!.ver,
            newCount = list!.count
            
            //MAKE A FETCH REQUEST TO LISTPAGE
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let fetchRequest = NSFetchRequest(entityName: "ListPage")
            
            let error = NSErrorPointer()
            let countCheck = managedContext.countForFetchRequest(fetchRequest, error: error)
            
            //check if array is empty
            //if yes manually create a new list page object and fill it with default data
            if(countCheck <= 0){
                print("results is empty");
                
                
                //this could just use he above context because it's creating the same entity?
                //maybe cuts down on the threads and therefor some confusion in the programming
                /*let appDelegate1 = UIApplication.sharedApplication().delegate as! AppDelegate
                let managedContext1 = appDelegate1.managedObjectContext*/
                let entity1 =  NSEntityDescription.entityForName("ListPage", inManagedObjectContext:managedContext)
                let newList = NSManagedObject(entity: entity1!, insertIntoManagedObjectContext: managedContext)
                //FILL IN ENTITY
                newList.setValue(ver, forKey: "ver")
                newList.setValue(0, forKey: "count")
                //SAVE
                do {
                    try managedContext.save()
                } catch let error as NSError  {
                    print("Could not save Initial List Page \(error), \(error.userInfo)")
                }
                
            }
            
            //TRY AND GET RESULTS OF FETCH
            do {
                let results = try managedContext.executeFetchRequest(fetchRequest)
                
                //GET THE NEW COUNT FROM SAVED LISTPAGE
                let x = results[0] as! NSManagedObject
                
                let oldCount = x.valueForKey("count") as? Int
                
                //IF COUNTS EQUAL THEN JUST START THE APP CAUSE IT SHOULD ALREADY HAVE ALL THE DATA
                if(oldCount == newCount){
                    print("count is equal")
                }else{
                    //ELSE CLEAR ALL THE OLD DATA
                    print("gets inside else statement")
                    self.deleteAllData("Item")
                    self.deleteAllData("ListPage")
                    
                    //CREATE A NEW LISTPAGE ENTITY
                    /*let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    let managedContext = appDelegate.managedObjectContext*/
                    let entity2 =  NSEntityDescription.entityForName("ListPage", inManagedObjectContext:managedContext)
                    let newList = NSManagedObject(entity: entity2!, insertIntoManagedObjectContext: managedContext)
                    //FILL IN ENTITY
                    newList.setValue(ver, forKey: "ver")
                    newList.setValue(newCount, forKey: "count")
                    //SAVE
                    do {
                        try managedContext.save()
                    } catch let error as NSError  {
                        print("Could not save ListPage \(error), \(error.userInfo)")
                    }
                    
                    
                    //SET COUNT - 1 (TO ACCOUNT FOR FEATURED ITEM NOT IN THIS ARRAY)
                    let bodyCount = newCount!
                    //LOOP TO SAVE ALL THE BODY ITEMS
                    print(bodyCount)
                    for(var i = 0; i < bodyCount; i += 1){ //start at one to skip featured
                        
                        //GET ALL THE DATA FOR THE CURRENT JSON BODY ITEM
                        let articleURL = list!.items![i].articleURL,
                        title = list!.items![i].title,
                        url = list!.items![i].url,
                        index = list!.items![i].index,
                        subTitle = list!.items![i].subTitle,
                        imageURL = list!.items![i].imageURL,
                        featured = list!.items![i].featured
                        print("vars initialized")
                        
                        //not saving the data correctly everytime
                        //CREATE A NEW BITEM ENTITY
                        let appDelegate4 = UIApplication.sharedApplication().delegate as! AppDelegate
                        let managedContext4 = appDelegate4.managedObjectContext
                        let entity4 =  NSEntityDescription.entityForName("Item", inManagedObjectContext:managedContext4)
                        let newItem = NSManagedObject(entity: entity4!, insertIntoManagedObjectContext: managedContext4)
                        print("new entity created")
                        //FILL IN ENTITY
                        print(i)
                        newItem.setValue(articleURL, forKey: "articleURL")
                        print("articleURL")
                        newItem.setValue(title, forKey: "title")
                        print("title")
                        newItem.setValue(url, forKey: "url")
                        print("url")
                        newItem.setValue(index, forKey: "index")
                        print("index")
                        newItem.setValue(subTitle, forKey: "subTitle")
                        print("subTitle")
                        newItem.setValue(imageURL, forKey: "imageURL")
                        print("imageURL")
                        newItem.setValue(featured, forKey: "featured")
                        print("featured")
                        //SAVE
                        do {
                            try managedContext4.save()
                            print("saved")
                        }catch let error as NSError  {
                            print("Could not save body item \(error), \(error.userInfo)")
                        }
                        
                    }
                    
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            self.timeToMoveOn()
        }
        
        

        
        
    }
    
    func deleteAllData(entity: String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.deleteObject(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    
    func timeToMoveOn() {
        self.performSegueWithIdentifier("loadFinished", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}