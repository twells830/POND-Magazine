//
//  SpotifyLoginViewController.swift
//  POND Magazine
//
//  Created by Tanner Wells on 2/5/16.
//  Copyright © 2016 PONDMAG. All rights reserved.
//

import UIKit


class SpotifyLoginViewController: UIViewController, SPTAuthViewDelegate, SPTAudioStreamingPlaybackDelegate{

    let clientID = "3f1b7c3568e34353ba38fe76a12d7bef"
    let callbackURL = "pondMagazine://returnAfterLogin"
    let kTokenSwapURL = "http://localhost:1234/swap"
    let kTokenRefreshURL = "http://localhost:1234/refresh"
    
    @IBOutlet weak var loginButton: UIButton!
    
    var player: SPTAudioStreamingController?

    let spotifyAuthenticator = SPTAuth.defaultInstance()
    
    @IBAction func loginWithSpotify(sender: AnyObject) {
        spotifyAuthenticator.clientID = clientID
        spotifyAuthenticator.requestedScopes = [SPTAuthStreamingScope]
        spotifyAuthenticator.redirectURL = NSURL(string: callbackURL)
        spotifyAuthenticator.tokenSwapURL = NSURL(string: kTokenSwapURL)
        spotifyAuthenticator.tokenRefreshURL = NSURL(string: kTokenRefreshURL)
        
        let spotifyAuthenticationViewController = SPTAuthViewController.authenticationViewController()
        spotifyAuthenticationViewController.delegate = self
        spotifyAuthenticationViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        spotifyAuthenticationViewController.definesPresentationContext = true
        presentViewController(spotifyAuthenticationViewController, animated: false, completion: nil)
    }
    
    // SPTAuthViewDelegate protocol methods
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {
        setupSpotifyPlayer()
        loginWithSpotifySession(session)
    }
    
    func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!) {
        print("login cancelled")
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
        print("login failed")
    }
    
    // SPTAudioStreamingPlaybackDelegate protocol methods
    
    private
    
    func setupSpotifyPlayer() {
        player = SPTAudioStreamingController(clientId: spotifyAuthenticator.clientID) // can also use kClientID; they're the same value
        player!.playbackDelegate = self
        player!.diskCache = SPTDiskCache(capacity: 1024 * 1024 * 64)
    }
    
    func loginWithSpotifySession(session: SPTSession) {
        player!.loginWithSession(session, callback: { (error: NSError!) in
            if error != nil {
                print("Couldn't login with session: \(error)")
                return
            }
            self.useLoggedInPermissions()
        })
    }
    
    func useLoggedInPermissions() {
        let spotifyURI = "spotify:track:1WJk986df8mpqpktoktlce"
        player!.playURIs([NSURL(string: spotifyURI)!], withOptions: nil, callback: nil)
    }
}