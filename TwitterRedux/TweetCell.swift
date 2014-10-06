//
//  TweetCell.swift
//  TwitterRedux
//
//  Created by Faith Cox on 10/4/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var tweet : Tweet! {
        willSet(tweet) {
            userLabel.text = tweet?.user?.name
            var screenname = tweet?.user?.screenname as String!
            screennameLabel.text = "@\(screenname)"
            var tweetString = tweet?.text
            //var tweetMutable = NSMutableAttributedString(string: tweetString!)
            //println(tweetMutable)
            //tweetMutable.addAttribute(NSURLComponents, value: NSURLComponents.componentsWithString(URLString: tweetMutable), range: 30)
            tweetLabel.text = tweet?.text
            timeLabel.text = tweet?.createdAt?.prettyTimestampSinceNow()
            var profileURL = tweet?.user?.profileImageUrl as String!
            profileImage.setImageWithURL(NSURL(string: profileURL))
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
