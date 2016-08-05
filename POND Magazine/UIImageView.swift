//
//  UIImageView.swift
//  POND Magazine
//
//  Created by Tanner Wells on 4/11/16.
//  Copyright © 2016 PONDMAG. All rights reserved.
//

import Foundation
//maybe add a doneloading boolean variable
//that becomes true after self.image
//then could base the height adjustment on the boolean



//but where would the conditional go that checks the true?


extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    self.image = UIImage(data: imageData)
                    print(self.image!.size.height)//this should be a function that sends this info back to 
                                                    //update the size of the image in the UIImage 
                                                    //based on the information from the incoming image
                    

                }
            }
        }
    }
    public func enlarge(prevVC:UIViewController){
        print("makes it to enlarge")
        let newVC: UIViewController = UIViewController()
        newVC.view = self
        self.frame.size.height = UIScreen.mainScreen().bounds.size.height - 10
        self.frame.size.width = UIScreen.mainScreen().bounds.size.width - 10
        prevVC.navigationController?.pushViewController(newVC, animated: true)
    }
}