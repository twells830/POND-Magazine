//
//  TestJSONViewController.swift
//  POND Magazine
//
//  Created by Tanner Wells on 2/8/16.
//  Copyright © 2016 PONDMAG. All rights reserved.
//

import Foundation

class TestJSONViewController: UIViewController, UITableViewDataSource{

    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let url = "http://www.pond-mag.com/spotlight/"
    
    var json: [String: AnyObject]!
    
    var titles = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //using the core data code to test output
        tableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
        //==== = = = = = = = =
        
        //get json data
        DataManager.getTopAppsDataFromItunesWithSuccess { (data) -> Void in
            // 1
            do {
                //self because json isn't passed to the viewDidLoad
                self.json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String: AnyObject]
            } catch {
                print(error)
            }
            
           // 2
           /* guard let list = listPage(json: self.json) else {
                print("Error initializing object")
                return
            }
            
            // 3 this cycles through every title in the body and puts them in titles array
            let bodyCount = list.count! - 1
            for(var i = 0; i < bodyCount; i++){
                guard let item = list.results?.body![i].title?.text else {
                    print("No such item")
                    return
                }
                self.titles.append(item)
            }
            */
            //self.test(self.json)
            self.fillTable()
        }
        
        //menu code
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 200
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            
            //revealViewController().rightViewRevealWidth = 200
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    //PLAYING WITH PASSING THE JSON VARIABLE AROUND
    func fillTable(){
    
        guard let list = listPage(json: self.json) else {
            print("Error initializing object")
            return
        }
        
        let bodyCount = list.count! - 1
        
        for(var i = 0; i < bodyCount; i++){
            
            let itemURL = list.results?.body![i].url
            if(itemURL == self.url){
                guard let item = list.results?.body![i].title?.text else {
                    print("No such item")
                    return
                }
            
                self.titles.append(item)
            }
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
