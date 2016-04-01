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



//featured needs the menu button but the rest shouldn't

class FeaturedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{
    
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
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        
        //menu code
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 150
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
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
            for(var i = 0; i < y; i+=1){
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
        cell!.textLabel!.resizeToText()
        let bgImg = images[indexPath.row]
        bgImg.frame = cell!.frame
        bgImg.alpha = 0.70
        cell!.backgroundView = bgImg
        return cell!
        
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let toURL = NSURL(string: self.articleURLs[indexPath.row])
        let leftPadding = CGFloat(10)
        let rightPadding = CGFloat(25)
        var y = 75
        let articleView:UIView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        articleView.backgroundColor = UIColor(red:238, green:238, blue:238, alpha:1.0)
        let scrollView:UIScrollView = UIScrollView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        do {
            let html = try String(contentsOfURL: toURL!, encoding: NSUTF8StringEncoding)
            if let doc = Kanna.HTML(html: html as String, encoding: NSUTF8StringEncoding) {
                let spacing = CGFloat(y)
                let label = UILabel()
                let rawTitle = doc.title as String!
                let formattedTitle = rawTitle.stringByPaddingToLength(rawTitle.characters.count - 11, withString: "", startingAtIndex: 0)
                label.text = formattedTitle
                label.frame.origin = CGPoint(x: leftPadding, y: spacing)
                label.frame.size.width = UIScreen.mainScreen().bounds.width-10
                label.font = UIFont(name:"Helvetica-bold", size: 50.0)
                label.resizeToText()
                y += Int(label.frame.size.height) + 5
                scrollView.addSubview(label)
                //remove -PONDMAG from the title
                //remove -tags at the bottom
                for authors in doc.css("h2, authors"){
                    let spacing = CGFloat(y)
                    let label = UILabel()
                    label.frame.origin = CGPoint(x: leftPadding, y: spacing)
                    label.frame.size.width = UIScreen.mainScreen().bounds.width-rightPadding
                    label.text = authors.text
                    label.resizeToText()
                    scrollView.addSubview(label)
                    y += Int(label.frame.size.height) + 5
                }
                y += 13 //spacing between authors and article
                //maybe use a background image behind title and authors
                //then add a bit of padding in between
                var numItems = 0;
                for content in doc.css("p, content") {
                    if(content.text != "" && content.text != " "){
                        let spacing = CGFloat(y)
                        let label = UILabel()
                        label.frame.origin = CGPoint(x: leftPadding, y: spacing)
                        label.frame.size.width = UIScreen.mainScreen().bounds.width-rightPadding
                        label.text = content.text
                        label.resizeToText()
                        scrollView.addSubview(label)
                        y += Int(label.frame.size.height)
                        numItems += 1;
                    }
                    if(content.text == " "){
                        y += 30 //add some extra space for blank <p>s
                    }
                }
                if(numItems < 5){ //determine if it's a photo article or not
                    print("this is a photo article, open this page in webview to view it")
                }
            }
        } catch {
            print("Error : \(error)")
        }
        scrollView.contentSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: CGFloat(y)) //after all the item heights are added to the y resize the scrollview apropriately
        articleView.addSubview(scrollView) //then add to article view
        self.view.addSubview(articleView) //display article view
        //self.navigationController!.navigationBarHidden = true
        self.navigationController!.hidesBarsOnSwipe = true
    }
    
}