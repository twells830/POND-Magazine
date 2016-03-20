//
//  TestJSONViewController.swift
//  POND Magazine
//
//  Created by Tanner Wells on 2/8/16.
//  Copyright © 2016 PONDMAG. All rights reserved.
//

import Foundation
import CoreData
import Kanna

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

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var vTitle: UINavigationItem!
    
    
    var url = " "
    var titles = [String]()
    var images = [UIImageView]()
    var articleURLs = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false

        
        //menu code
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 200
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        tableView.delegate = self
        
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
            cell!.textLabel!.font = UIFont(name: "Geeza Pro", size: 20.0)
            let bgImg = images[indexPath.row]
            bgImg.frame = cell!.frame
            bgImg.alpha = 0.70
            cell!.backgroundView = bgImg
            return cell!
            
  
    }
    //set all to resize to text 
    //handle longer titles
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let toURL = NSURL(string: self.articleURLs[indexPath.row])
        var x = 50
        let articleView:UIView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        articleView.backgroundColor = UIColor(red:238, green:238, blue:238, alpha:1.0)
        let scrollView:UIScrollView = UIScrollView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        do {
            let html = try String(contentsOfURL: toURL!, encoding: NSUTF8StringEncoding)
            if let doc = Kanna.HTML(html: html as String, encoding: NSUTF8StringEncoding) {
                let label = UILabel(frame: CGRectMake(4, CGFloat(x), UIScreen.mainScreen().bounds.width-3, 50))
                label.text = doc.title
                label.font = UIFont(name:"Helvetica-bold", size: 20.0)
                scrollView.addSubview(label)
                x += Int(label.frame.size.height)
                print(doc.title)
                for authors in doc.css("h2, authors"){
                    let spacing = CGFloat(x)
                    let label = UILabel(frame: CGRectMake(4, spacing, UIScreen.mainScreen().bounds.width-3, 21))
                    label.text = authors.text
                    scrollView.addSubview(label)
                    x += 21
                }
                var numItems = 0;
                for content in doc.css("p, content") {
                    if(content.text != "" && content.text != " "){
                        let spacing = CGFloat(x)
                        let label = UILabel()
                        label.frame.origin = CGPoint(x: 4, y: spacing)
                        label.frame.size.width = UIScreen.mainScreen().bounds.width-3
                        label.text = content.text
                        label.resizeToText()
                        scrollView.addSubview(label)
                        x += Int(label.frame.size.height)
                        numItems++;
                        print(content.text)
                    }
                    if(content.text == " "){
                        x += 30
                    }
                }
                if(numItems < 5){
                    print("this is a photo article, open this page in webview to view it")
                }
            }
        } catch {
            print("Error : \(error)")
        }
        scrollView.contentSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: CGFloat(x))
        articleView.addSubview(scrollView)
        self.view.addSubview(articleView)
        self.navigationController!.navigationBarHidden = true
        self.navigationController!.hidesBarsOnSwipe = true
        self.navigationController!.navigationBar.translucent = true
    }

}