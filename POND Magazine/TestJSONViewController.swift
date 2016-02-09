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
    
    //add this to the top of every view controller with correct url
    let url = "http://www.pond-mag.com/spotlight/"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //using the core data code to test output
        tableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
        //==== = = = = = = = =
        
        
        //should get all the data and set fill the table
        DataSort.fillTable(self.url)
        
        tableView.reloadData()
        
        //menu code
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 200
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            
            //revealViewController().rightViewRevealWidth = 200
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return DataSort.getRowNum();
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
                cell!.imageView?.image = DataSort.getImages()[indexPath.row].image
                cell!.textLabel!.text = DataSort.getTitles()[indexPath.row]

            return cell!
    }
}
