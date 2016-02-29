//
//  SubMenu.swift
//  POND Magazine
//
//  Created by Tanner Wells on 2/29/16.
//  Copyright © 2016 PONDMAG. All rights reserved.
//

import Foundation

class SubMenuController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 200
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
}