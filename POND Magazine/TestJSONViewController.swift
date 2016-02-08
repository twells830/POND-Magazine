//
//  TestJSONViewController.swift
//  POND Magazine
//
//  Created by Tanner Wells on 2/8/16.
//  Copyright © 2016 PONDMAG. All rights reserved.
//

import Foundation

class TestJSONViewController: UIViewController, UITableViewDataSource{

    @IBOutlet weak var menuButton: UIButton!
    
    var json: [String: AnyObject]!

    // = = = = = = =
    @IBOutlet weak var tableView: UITableView!

    @IBAction func addName(sender: AnyObject) {
        
        let alert = UIAlertController(title: "New Name",
            message: "Add a new name",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default,
            handler: { (action:UIAlertAction) -> Void in
                
                let textField = alert.textFields!.first
                self.names.append(textField!.text!)
                self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
    }
    var names = [String]()
    // = = = = = = =
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //using the core data code to test output
        title = "\"The List\""
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
            
          /*  // 2
            guard let list = listPage(json: self.json) else {
                print("Error initializing object")
            }
            
            // 3 this cycles through every title in the body
            var bodyCount = list.count! - 1
            for(var i = 0; i < bodyCount; i++){
                guard let firstItem = list.results?.body![i].title?.text else {
                    print("No such item")
                }
                print(firstItem)
            }*/
            
            self.test(self.json)
            
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
    func test(json: [String: AnyObject]){
    
        guard let list = listPage(json: json) else{
            print("error here")
        }
        
        
        print(list)
    }
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return names.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell")
            
            cell!.textLabel!.text = names[indexPath.row]
            
            return cell!
    }
}
