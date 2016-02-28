//
//  TestJSONViewController.swift
//  POND Magazine
//
//  Created by Tanner Wells on 2/8/16.
//  Copyright © 2016 PONDMAG. All rights reserved.
//

import Foundation
import CoreData

class ListViewController: UIViewController, UITableViewDataSource{
    
    @IBOutlet weak var vTitle: UINavigationItem!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var url = " "
    var titles = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        url = "http://www.pond-mag.com/spotlight/"
        url = "http://www.pond-mag.com/interviews/"
        url = "http://www.pond-mag.com/releases/"
        url = "http://www.pond-mag.com/reviews-1/"
        url = "http://www.pond-mag.com/photography-1/"
        url = "http://www.pond-mag.com/featured-artists/"
        url = "http://www.pond-mag.com/new-page-4/"
        url = "http://www.pond-mag.com/literature-/"
        
        switch(vTitle.title){
        
        case "POND"?:
            url = "http://www.pond-mag.com/"
            break
        case "Editorials"?:
            url = "http://www.pond-mag.com/editorials-2/"
            break
        case "Spotlight"?:
            url = "http://www.pond-mag.com/spotlight/"
            break
        case "Interviews"?:
            url = "http://www.pond-mag.com/interviews/"
            break
        case "Releases"?:
            url = "http://www.pond-mag.com/releases/"
            break
        case "Reviews"?:
            url = "http://www.pond-mag.com/reviews-1/"
            break
        case "Photography"?:
            url = "http://www.pond-mag.com/photography-1/"
            break
        case "Featured Artists"?:
            url = "http://www.pond-mag.com/featured-artists/"
            break
        case "Entertainment"?:
            url = "http://www.pond-mag.com/new-page-4/"
            break
        case "Lit & Zines"?:
            url = "http://www.pond-mag.com/literature-/"
            break
        default:
            print("Switch Broke")
        }
        
        /*if(vTitle.title == "POND"){
            url = "http://www.pond-mag.com/";
        }else if(vTitle.title == "Editorials"){
            url = "http://www.pond-mag.com/editorials-2/"
        }*/
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.fillTable()
        
        //menu code
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 200
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    //PLAYING WITH PASSING THE JSON VARIABLE AROUND
    func fillTable(){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest1 = NSFetchRequest(entityName: "ListPage")
        let fetchRequest2 = NSFetchRequest(entityName: "BItem")
        
        do{
            let results1 = try managedContext.executeFetchRequest(fetchRequest1)
            let x = results1[0] as! NSManagedObject
            let y = x.valueForKey("count") as? Int
            print("ListPage count =  \(y)")
            
            let results2 = try managedContext.executeFetchRequest(fetchRequest2)
            for(var i = 0; i < y!-1; i++){
                let z = results2[i] as! NSManagedObject
                let itemURL = z.valueForKey("url") as? String
                if(itemURL == self.url){
                    let b = z.valueForKey("title") as? String
                    self.titles.append(b!)
                }
            }
            
        }catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        self.tableView.reloadData()
        
    }
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return titles.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell")
            
            cell!.textLabel!.text = titles[indexPath.row]
            
            return cell!
    }
}