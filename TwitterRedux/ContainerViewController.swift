//
//  ContainerViewController.swift
//  TwitterRedux
//
//  Created by Faith Cox on 10/4/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit


class ContainerViewController: UIViewController {
    
    var tweetsViewController: UIViewController!
    var menuViewController: UIViewController!
    var startx : CGFloat = 0
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        tweetsViewController = storyboard.instantiateViewControllerWithIdentifier("TweetsViewController") as UIViewController
        menuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as UIViewController
        
        tweetsViewController.view.frame = containerView.frame
        containerView.addSubview(tweetsViewController.view)
        
        println("here")
        
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

    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        var location = sender.locationInView(view)
        //println("\(location.x), \(location.y)")
        if (sender.state == UIGestureRecognizerState.Began) {
            println("Loc X: \(location.x), Fram Width: \(self.view.frame.width)")
            startx = location.x
            menuViewController.view.frame.origin.x = -self.view.frame.width
            containerView.addSubview(menuViewController.view)
        }
        else if (sender.state == UIGestureRecognizerState.Changed) {
            println("\(location.x), \(location.y)")
            menuViewController.view.frame.origin.x = -self.view.frame.width + (location.x - startx)
            
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            var velocity = sender.velocityInView(view)
            println("velocity \(velocity)")
            //UIView.animateWithDuration(0.3, animations: { () -> Void in
            //    self.menuViewController.view.frame.origin.x = 0
            //})
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
            //menuViewController.view.frame = containerView.frame
            //containerView.addSubview(menuViewController.view)
        }
    }
}
