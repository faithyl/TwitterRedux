//
//  TweetsViewController.swift
//  TwitterRedux
//
//  Created by Faith Cox on 10/4/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweets: [Tweet]?
    var user: User?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 75
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.reloadData()
        
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserverForName("showTweetInfo", object: nil, queue: nil) { (notification: NSNotification!) -> Void in
            TwitterClient.sharedInstance.homeTimeLineWithParams(nil, completion: { (tweets, error) -> () in
                //println("Timeline: \(tweets)")
                self.tweets = tweets
                self.tableView.reloadData()
            })
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName("showMentionInfo", object: nil, queue: nil) { (notification: NSNotification!) -> Void in
            TwitterClient.sharedInstance.mentionTimeLineWithParams(nil, completion: { (tweets, error) -> () in
                //println("Mention: \(tweets)")
                self.tweets = tweets
                self.tableView.reloadData()
            })
            
        }
        
        var userURL = User.currentUser!.profileImageUrl!
        userImage.setImageWithURL(NSURL(string: userURL))
        userLabel.text = User.currentUser!.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell
        var tweet = self.tweets?[indexPath.row]
        println("tweet: \(tweet)")
        cell.tweet = tweet
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
