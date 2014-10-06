//
//  ViewController.swift
//  TwitterRedux
//
//  Created by Faith Cox on 10/4/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

//
//  ViewController.swift
//  Twitter
//
//  Created by Faith Cox on 9/27/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(sender: AnyObject) {
        
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if user != nil {
                self.user = user
                //perform segue
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                //handle login error
            }
        }

    }
    
}

