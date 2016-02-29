//
//  LoadViewController.swift
//  POND Magazine
//
//  Created by Tanner Wells on 2/28/16.
//  Copyright © 2016 PONDMAG. All rights reserved.
//

import Foundation
class LoadViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        _ = NSTimer.scheduledTimerWithTimeInterval(9.0, target: self, selector: "timeToMoveOn", userInfo: nil, repeats: false)
    }
    
    func timeToMoveOn() {
        self.performSegueWithIdentifier("loadFinished", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}