//
//  ProfileViewController.swift
//  TwitterRedux
//
//  Created by Faith Cox on 10/7/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweets: [Tweet]?
    var user: User?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetcountLabel: UILabel!
    @IBOutlet weak var followcountLabel: UILabel!
    @IBOutlet weak var friendscountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 75
        tableView.rowHeight = UITableViewAutomaticDimension
        
        TwitterClient.sharedInstance.userTimeLineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })

        // Do any additional setup after loading the view.
        var userURL = User.currentUser!.profileImageUrl!
        profileImage.setImageWithURL(NSURL(string: userURL))
        nameLabel.text = User.currentUser!.name
        screennameLabel.text = "@ \(User.currentUser!.screenname!)"
        tweetcountLabel.text = "\(User.currentUser!.statuses_count!) tweets"
        followcountLabel.text = "\(User.currentUser!.followers_count!) followers"
        friendscountLabel.text = "\(User.currentUser!.friends_count!) friends"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("UserCell") as UserCell
        var tweet = self.tweets?[indexPath.row]
        //println("tweet: \(tweet)")
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
