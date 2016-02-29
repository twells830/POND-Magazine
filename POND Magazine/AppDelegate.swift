//
//  AppDelegate.swift
//  HitList
//
//  Created by Pietro Rea on 7/5/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit
import CoreData

var cont = false

//DataManager runs in background
//LoadViewController is in main and goes to featured page
//which is fetches data while datamanager is still writing

//!!Might have solved this with the timer in loadviewController
// this ^ is just a quick fix look up how to fix the threading so that dataManager happens first

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
       var json: [String: AnyObject]!
            print("before data manager")
            //GET ALL THE JSON
            DataManager.getPondDataWithSuccess { (data) -> Void in //something is breaking up here
                print("inside data manager")
                do {
                    json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String: AnyObject]
                } catch {
                    print(error)
                }
                //MAKE A LIST AND SET THE DATA TO VAR TO GET NEW COUNT
                let list = listPage(json: json),
                newData = list!.newData,
                thisVer = list!.thisVer,
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
                    newList.setValue(newData, forKey: "newData")
                    newList.setValue(thisVer, forKey: "thisVer")
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
                        self.deleteAllData("BItem")
                        self.deleteAllData("Item")
                        self.deleteAllData("ListPage")
                        
                        //CREATE A NEW LISTPAGE ENTITY
                        /*let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        let managedContext = appDelegate.managedObjectContext*/
                        let entity2 =  NSEntityDescription.entityForName("ListPage", inManagedObjectContext:managedContext)
                        let newList = NSManagedObject(entity: entity2!, insertIntoManagedObjectContext: managedContext)
                        //FILL IN ENTITY
                        newList.setValue(newData, forKey: "newData")
                        newList.setValue(thisVer, forKey: "thisVer")
                        newList.setValue(newCount, forKey: "count")
                        //SAVE
                        do {
                            try managedContext.save()
                        } catch let error as NSError  {
                            print("Could not save ListPage \(error), \(error.userInfo)")
                        }
                        
                        
                        
            //CREATE A NEW ITEM ENTITY (FOR FEATURED ITEM)
            let appDelegate3 = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext3 = appDelegate3.managedObjectContext
            let entity3 =  NSEntityDescription.entityForName("Item", inManagedObjectContext:managedContext3)
            let newFeaturedItem = NSManagedObject(entity: entity3!, insertIntoManagedObjectContext: managedContext3)
            //FILL IN ENTITY
            newFeaturedItem.setValue(list!.results?.top![0].fLink?.href, forKey: "href")
            newFeaturedItem.setValue(list!.results?.top![0].fTitle, forKey: "Title")
            newFeaturedItem.setValue(list!.results?.top![0].url, forKey: "url")
            newFeaturedItem.setValue(list!.results?.top![0].index, forKey: "index")
            newFeaturedItem.setValue(list!.results?.top![0].fLink?.subTitle, forKey: "subTitle")
            //SAVE
            do {
                try managedContext3.save()
            } catch let error as NSError  {
                print("Could not save Featured Item \(error), \(error.userInfo)")
            }
                        
                        //SET COUNT - 1 (TO ACCOUNT FOR FEATURED ITEM NOT IN THIS ARRAY)
                        let bodyCount = newCount! - 1
                        //LOOP TO SAVE ALL THE BODY ITEMS
                        print(bodyCount)
                        for(var i = 0; i < bodyCount; i++){
                            
                            //GET ALL THE DATA FOR THE CURRENT JSON BODY ITEM
                            let itemHref = list!.results?.body![i].title?.href,
                            itemTitle = list!.results?.body![i].title?.text,
                            itemUrl = list!.results?.body![i].url,
                            itemIndex = list!.results?.body![i].index,
                            itemSubTitle = list!.results?.body![i].subTitle,
                            itemImgSrc = list!.results?.body![i].image?.imgSrc
                            print("vars initialized")
                        
                            //not saving the data correctly everytime
                            //CREATE A NEW BITEM ENTITY
                            let appDelegate4 = UIApplication.sharedApplication().delegate as! AppDelegate
                            let managedContext4 = appDelegate4.managedObjectContext
                            let entity4 =  NSEntityDescription.entityForName("BItem", inManagedObjectContext:managedContext4)
                            let newItem = NSManagedObject(entity: entity4!, insertIntoManagedObjectContext: managedContext4)
                            print("new entity created")
                            //FILL IN ENTITY
                            print(i)
                            newItem.setValue(itemHref, forKey: "href")
                            print("href")
                            newItem.setValue(itemTitle, forKey: "title")
                            print("title")
                            newItem.setValue(itemUrl, forKey: "url")
                            print("url")
                            newItem.setValue(itemIndex, forKey: "index")
                            print("index")
                            newItem.setValue(itemSubTitle, forKey: "subTitle")
                            print("subTitle")
                            newItem.setValue(itemImgSrc, forKey: "imgSrc")
                            print("imgSrc")
                            //SAVE
                            do {
                                try managedContext4.save()
                                print("saved")
                            }catch let error as NSError  {
                                print("Could not save body item \(error), \(error.userInfo)")
                            }
                            
                        }
                        cont = true
                        
                    }
                } catch let error as NSError {
                    print("Could not fetch \(error), \(error.userInfo)")
                }
            }
        
        
        
        
        
        
        
        
        
        //print the count in ListPage Entity
        //print all titles from Item entities
        
        /*
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest1 = NSFetchRequest(entityName: "ListPage")
        let fetchRequest2 = NSFetchRequest(entityName: "BItem")
        
        do{
            let results1 = try managedContext.executeFetchRequest(fetchRequest1)
            let x = results1[0] as! NSManagedObject //breaking here again ===== think its a problem with initializiation this
                                                    // this was here just as a test so comment out and see if it fixes
            let y = x.valueForKey("count") as? Int
            print("ListPage count =  \(y)")
            
            let results2 = try managedContext.executeFetchRequest(fetchRequest2)
            for(var i = 0; i < y!-1; i++){
                let z = results2[i] as! NSManagedObject
                let b = z.valueForKey("title") as? String
                print(b)
            }
            
        } catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }*/
        
        return true
    }
    
    
    
    //SHOULD CLEAR ALL RECORDS OF PASSED ENTITY FROM: STACKOVERFLOW
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

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.razeware.HitList" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("POND-Magazine", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("POND-Magazine.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
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
    
}

