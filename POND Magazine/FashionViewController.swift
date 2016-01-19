//
//  FeaturedController.swift
//  POND Magazine
//
//  Created by Tanner Wells on 1/15/16.
//  Copyright © 2016 PONDMAG. All rights reserved.
//

import UIKit

class FashionViewController: UIViewController, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var EditorialsThumb: UIImageView!

    @IBOutlet weak var SpotlightThumb: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 200
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            
            //revealViewController().rightViewRevealWidth = 200
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            var UITapRecognizer = UITapGestureRecognizer(target: self, action: "tappedImage")
            UITapRecognizer.delegate = self
            EditorialsThumb.addGestureRecognizer(UITapRecognizer)
            
            
        }
    }
    
    func tappedImage(sender: AnyObject){
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
