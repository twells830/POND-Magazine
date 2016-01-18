//
//  FeaturedController.swift
//  POND Magazine
//
//  Created by Tanner Wells on 1/15/16.
//  Copyright © 2016 PONDMAG. All rights reserved.
//

import UIKit

class CultureViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var webView: UIWebView!
    var URLPath = "http://www.pond-mag.com/new-page-4/"
    
    func loadURL(){
        let requestURL = NSURL(string: URLPath)
        let request = NSURLRequest(URL: requestURL!)
        webView.loadRequest(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 200
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            
            //revealViewController().rightViewRevealWidth = 200
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            loadURL()
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}