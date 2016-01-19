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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 200
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            
            //revealViewController().rightViewRevealWidth = 200
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            let tapGesture = UITapGestureRecognizer(target: self, action: "imageTapped:")
            
            // add it to the image view;
            EditorialsThumb.addGestureRecognizer(tapGesture)
            // make sure imageView can be interacted with by user
            EditorialsThumb.userInteractionEnabled = true
        }
        
        func imageTapped(gesture: UIGestureRecognizer) {
            performSegueWithIdentifier("editorialPush", sender: self)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
