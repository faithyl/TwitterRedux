//
//  ContainerViewController.swift
//  TwitterRedux
//
//  Created by Faith Cox on 10/4/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit


class ContainerViewController: UIViewController {
    
    var tweetsVC: UIViewController!
    var profileVC: UIViewController!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var menuView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    
    // menu
    let menu = [
        ["type": "tweet"],
        ["type": "item", "id": "profile", "displayName": "Profile"],
        ["type": "item", "id": "tweet", "displayName": "Home Timeline"],
        ["type": "item", "id": "tweet", "displayName": "Mentions Timeline"]
    ]
    
    var menuToVCMap = Dictionary<String, UIViewController>()

    var activeViewController: UIViewController? {
        didSet(oldViewControllerorNil) {
            if let oldVC = oldViewControllerorNil {
                oldVC.willMoveToParentViewController(nil)
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
            }
            if let newVC = activeViewController {
                self.addChildViewController(newVC)
                newVC.view.frame = self.containerView.frame
                self.containerView.addSubview(newVC.view)
                newVC.didMoveToParentViewController(self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initSubViewControllers()
        
        NSNotificationCenter.defaultCenter().postNotificationName("showTweetInfo", object: nil)
        
        /*
        NSNotificationCenter.defaultCenter().addObserverForName("ShowTweetimeline", object: nil, queue: nil) { (notification: NSNotification!) -> Void in
            if (notification.object != nil) {
                var tweet = notification.object as Tweet
                self.activeViewController = self.tweetsVC
            }
        }
        */
    }

    
    func initSubViewControllers() {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        tweetsVC = storyboard.instantiateViewControllerWithIdentifier("TweetsViewController") as UIViewController
        profileVC = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as UIViewController
        
        menuToVCMap.updateValue(tweetsVC, forKey: "tweet")
        menuToVCMap.updateValue(tweetsVC, forKey: "profile")
        
        self.activeViewController = tweetsVC
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onSwipe(sender: UISwipeGestureRecognizer) {
        if (sender.direction == .Right && sender.state == .Ended) {
            println("right")
            self.showMenu()
        }
        if (sender.direction == .Left && sender.state == .Ended) {
            println("Left")
            self.hideMenu()
        }
        
    }
    
    @IBAction func onTap(sender: UITapGestureRecognizer) {
        if (sender.state == .Ended) {
            menuToVCMap.updateValue(tweetsVC, forKey: "profile")
            self.activeViewController = profileVC
            //self.profileVC.view.frame.origin.x = self.view.frame.width
            UIView.animateWithDuration(0.4, animations:{ () -> Void in
                self.profileVC.view.frame.origin.x = 0
                self.hideMenu()
            })
        }
    }
    
    func showMenu() {
        var userURL = User.currentUser!.profileImageUrl!
        self.userImage.setImageWithURL(NSURL(string: userURL))
        self.userLabel.text = User.currentUser!.name
        self.screennameLabel.text = "@" + User.currentUser!.screenname!
        self.userImage.userInteractionEnabled = true
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            //println("\(self.containerView.frame.origin.x), \(self.menuView.frame.width)")
            self.containerView.frame.origin.x = self.menuView.frame.width
        })
    }
    
    func hideMenu() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.containerView.frame.origin.x = 0
        })
    }
    
    @IBAction func onTimeline(sender: AnyObject) {
        menuToVCMap.updateValue(tweetsVC, forKey: "tweet")
        NSNotificationCenter.defaultCenter().postNotificationName("showTweetInfo", object: nil)
        self.activeViewController = tweetsVC
        //self.tweetsVC.view.frame.origin.x = self.view.frame.width
        UIView.animateWithDuration(0.4, animations:{ () -> Void in
            self.tweetsVC.view.frame.origin.x = 0
            self.hideMenu()
        })
    }

    @IBAction func onMention(sender: AnyObject) {
        menuToVCMap.updateValue(tweetsVC, forKey: "tweet")
        NSNotificationCenter.defaultCenter().postNotificationName("showMentionInfo", object: nil)
        self.activeViewController = tweetsVC
        //self.tweetsVC.view.frame.origin.x = self.view.frame.width
        UIView.animateWithDuration(0.4, animations:{ () -> Void in
            self.tweetsVC.view.frame.origin.x = 0
            self.hideMenu()
        })
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
}


/*
    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        var location = sender.locationInView(view)
        //println("\(location.x), \(location.y)")
        if (sender.state == UIGestureRecognizerState.Began) {
            println("Loc X: \(location.x), Fram Width: \(self.view.frame.width)")
            startx = location.x
            self.menuView.frame.origin.x = -self.view.frame.width
            containerView.addSubview(menuView)
        }
        else if (sender.state == UIGestureRecognizerState.Changed) {
            println("\(location.x), \(location.y)")
            self.menuView.frame.origin.x = -self.view.frame.width + (location.x - startx)
            
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            var velocity = sender.velocityInView(view)
            println("velocity \(velocity)")
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.menuView.frame.origin.x = 0
            })
            /*
            UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.menuViewController.view.frame.origin.x = 0
            }) {(finished: Bool) -> Void in
            println(self.view)
            if (self.view == self.containerView) {
            self.panGesture.enabled = false
            } else {
            self.panGesture.enabled = true
            }
            }
            */
            //menuViewController.view.frame = containerView.frame
            //containerView.addSubview(menuViewController.view)
        }

    }
    */
