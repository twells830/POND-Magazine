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

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{
    
    @IBOutlet weak var vTitle: UINavigationItem!
    
    var url = " "
    var titles = [String]()
    var images = [UIImageView]()
    var imgUrls = [String]()
    var articleURLs = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
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
            
            tableView.rowHeight = 200
        
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
            
            cell!.textLabel!.text = titles[indexPath.row]
            cell!.textLabel!.textColor = UIColor.whiteColor()
            cell!.textLabel!.font = UIFont(name: "Avenir-heavy", size: 20.0)
            cell!.textLabel!.resizeToText()
        
            cell!.textLabel!.layer.shadowColor = UIColor.blackColor().CGColor
            cell!.textLabel!.layer.shadowOffset = CGSize(width: 2, height: 2)
            cell!.textLabel!.layer.shadowOpacity = 1
            cell!.textLabel!.layer.shadowRadius = 3
        
        
            let bgImg = images[indexPath.row]
            bgImg.frame = cell!.frame
            bgImg.alpha = 0.66
            cell!.backgroundView = bgImg
            return cell!
            
  
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let toURL = NSURL(string: self.articleURLs[indexPath.row])
        let leftPadding = CGFloat(10)
        let rightPadding = CGFloat(25)
        var y = 75
        
        //set up the view controller and the views here adding them the same way but with the view controller at the root
        //for the view controller give it an identifier. then at the bottom after the view has been set up perform
        //show/push segue to the new viewcontroller from this one
        
        
        //THINK THERE NEEDS TO BE A NEW VIEW CONTROLLER
        //ADD THE VIEWS TO THE VC AND THEN PUSH THE VC
        //THIS SHOULD CREATE A NEW BACK BUTTON THAT JUST GOES BACK ONE SCREEN
        let newViewController:UIViewController = UIViewController()
        
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
                label.font = UIFont(name:"Helvetica-bold", size: 40.0)
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
                //for x in doc.
                for content in doc.css(".sqs-block-content"){
                    if(content.css("p").text != "" && content.css("p").text != " "){
                        let spacing = CGFloat(y)
                        let label = UILabel()
                        label.frame.origin = CGPoint(x: leftPadding, y: spacing)
                        label.frame.size.width = UIScreen.mainScreen().bounds.width-rightPadding
                        label.text = content.css("p").text
                        //print(content.text)
                        label.resizeToText()
                        scrollView.addSubview(label)
                        y += Int(label.frame.size.height)
                        numItems += 1;
                    }
                    if(content.css("p").text == " "){
                        y += 50 //add some extra space for blank <p>s
                    }
                    let img = content.at_css("img")
                    //get image link
                    //load it in a UIVIEW
                    //determine the size
                    //  if image width > screen width
                    //  scale image to screen width -10 (how to adjust height for proper scale?)
                    
                    //how to add constraints programatically?
                    //want to add so that each new label should be x amount of pixels from closest item on top
                    //this should leave some space for the imgs and will resize when the image loads
                    if(img?["src"] != nil){
                        y+=10
                        let newImg = UIImageView()
                        newImg.imageFromUrl(img!["src"]!)
                        let spacing = CGFloat(y)
                        newImg.frame.origin = CGPoint(x: leftPadding, y:spacing)
                        //let imgHeight = newImg.image?.size.height //need to get this after the image is finsihed loading
                        newImg.frame.size.height = 200 //this should be the original height of the image
                        //scaled down by whatever the width has to be scaled
                        
                        //NEW CODE
                        //this kind of works but it leaves white space on the sides of portrait images
                        newImg.contentMode = UIViewContentMode.ScaleAspectFit
                        //WEFBWIWEONEWONEWOFNIEWFEWOIFNEWOFINDSLDMC;SKX
                        
                        //maybe have 200 hundred as a placeholder
                        //then when the screen loads get the height of the image
                        //and adjust y according to the new height?
                        newImg.frame.size.width = UIScreen.mainScreen().bounds.width-rightPadding
                        scrollView.addSubview(newImg)
                        y += Int(newImg.frame.size.height)
                        numItems += 1;
                        y+=10
                    }
                }
                //spacing between the last item and the bottom of the screen
                y+=20
            }
        } catch {
            print("Error : \(error)")
        }
        //there's some extra space at the top of the article reader
        //maybe it has something to do with the scroll view offsets/insets 
        
        scrollView.contentSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: CGFloat(y)) //after all the item heights are added to the y resize the scrollview apropriately
        articleView.addSubview(scrollView) //then add to article view
        self.view.addSubview(articleView) //display article view //this might be replaced with the push/show segue
        newViewController.view = articleView //put the newViewcontroller under everything else
        newViewController.automaticallyAdjustsScrollViewInsets = false        
        self.navigationController?.pushViewController(newViewController, animated: true) // this will push the new controller
        newViewController.title = self.vTitle.title
        //make sure the title carries over to the new view controller
        self.navigationController!.hidesBarsOnSwipe = true
    }

}