//
//  TestJSONViewController.swift
//  POND Magazine
//
//  Created by Tanner Wells on 2/8/16.
//  Copyright © 2016 PONDMAG. All rights reserved.
//

import Foundation
import CoreData

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    self.image = UIImage(data: imageData)
                }
            }
        }
    }
}

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var vTitle: UINavigationItem!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var url = " "
    var titles = [String]()
    var images = [UIImageView]()
    var articleURLs = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
       /* url = "http://www.pond-mag.com/spotlight/"
        url = "http://www.pond-mag.com/interviews/"
        url = "http://www.pond-mag.com/releases/"
        url = "http://www.pond-mag.com/reviews-1/"
        url = "http://www.pond-mag.com/photography-1/"
        url = "http://www.pond-mag.com/featured-artists/"
        url = "http://www.pond-mag.com/new-page-4/"
        url = "http://www.pond-mag.com/literature-/" */
        
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
        case "Diaries"?:
            url = "http://www.pond-mag.com/diaries-1/"
            break
        case "Photography"?:
            url = "http://www.pond-mag.com/photography-1/"
            break
        case "Featured Artists"?:
            url = "http://www.pond-mag.com/featured-artists/"
            break
        case "Culture"?:
            url = "http://www.pond-mag.com/literature-/"
            break
        default:
            print("Switch Fail")
        }
        
        
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
        
        //the problem is it runs this while it's running the data manager in loadswithoptions
        //have to find a way to make sure this happens after the datamanager is finished running
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest1 = NSFetchRequest(entityName: "ListPage")
        let fetchRequest2 = NSFetchRequest(entityName: "Item")
        
        do{
            let results1 = try managedContext.executeFetchRequest(fetchRequest1)
            let x = results1[0] as! NSManagedObject
            let y = x.valueForKey("count") as? Int
            print("ListPage count =  \(y)")
            
            let results2 = try managedContext.executeFetchRequest(fetchRequest2)
            for(var i = 0; i < y; i++){
                let z = results2[i] as! NSManagedObject
                let itemURL = z.valueForKey("url") as? String
                if(itemURL == self.url){
                    let b = z.valueForKey("title") as? String
                    let c = z.valueForKey("imageURL") as? String
                    var d : String
                    if(self.url == "http://www.pond-mag.com/"){
                        d = (z.valueForKey("articleURL") as? String)!
                    }else{
                        d = "http://www.pond-mag.com" + (z.valueForKey("articleURL") as? String)!
                    }
                    self.titles.append(b!)
                    self.articleURLs.append(d)
                    //self.imageURLs.append(c!)
                    let imageView = UIImageView()
                    imageView.imageFromUrl(c!)
                    images.append(imageView)
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
            
            tableView.rowHeight = 190
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
            
            cell!.textLabel!.text = titles[indexPath.row]
            //cell!.
            let bgImg = images[indexPath.row]
            bgImg.frame = cell!.frame
            cell!.backgroundView = bgImg
            //cell!.addSubview(bgImg)
           // cell!.sendSubviewToBack(bgImg)
            return cell!
            
  
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let toURL = NSURL(string: self.articleURLs[indexPath.row])
        let webV:UIWebView = UIWebView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        webV.loadRequest(NSURLRequest(URL: toURL!))
        self.view.addSubview(webV)
    }

}