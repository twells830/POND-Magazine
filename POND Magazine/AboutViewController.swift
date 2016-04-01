//
//  FeaturedController.swift
//  POND Magazine
//
//  Created by Tanner Wells on 1/15/16.
//  Copyright © 2016 PONDMAG. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var aboutText: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        aboutText.frame = CGRectMake(0, 0, 183, 21)
        self.ScrollView.addSubview(aboutText)


        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 200
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            
            //revealViewController().rightViewRevealWidth = 200
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}