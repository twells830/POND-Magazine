//
//  SpotifyLoginViewController.swift
//  POND Magazine
//
//  Created by Tanner Wells on 2/5/16.
//  Copyright © 2016 PONDMAG. All rights reserved.
//

import UIKit


class SpotifyLoginViewController: UIViewController, SPTAuthViewDelegate{
    let kclientID = "3f1b7c3568e34353ba38fe76a12d7bef"
    let kcallbackURL = "pondMagazine://returnAfterLogin"
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 200
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            
            //revealViewController().rightViewRevealWidth = 200
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    @IBAction func loginSpotify(sender: AnyObject){
        SPTAuth.defaultInstance().clientID = kclientID
        SPTAuth.defaultInstance().redirectURL = NSURL(string: kcallbackURL)
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope]
        SPTAuth.defaultInstance().sessionUserDefaultsKey = "SpotifySession"
        //SPTAuth.defaultInstance().tokenSwapURL = NSURL(string: ktokenSwapURL) //you will not need this initially, unless you want to refresh tokens
       // SPTAuth.defaultInstance().tokenRefreshURL = NSURL(string: ktokenRefreshServiceURL)//you will not need this unless you want to refresh tokens
        
        let spotifyAuthViewController = SPTAuthViewController.authenticationViewController()
        spotifyAuthViewController.delegate = self
        spotifyAuthViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        spotifyAuthViewController.definesPresentationContext = true
        presentViewController(spotifyAuthViewController, animated: false, completion: nil)
        
    }
    
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {
        print("Logged In")
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
        print("Failed to Log In")
        print(error)
        authenticationViewController.clearCookies(nil)
    }
    
    func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!) {
        print("User Canceled Log In")
        authenticationViewController.clearCookies(nil)
    }
}