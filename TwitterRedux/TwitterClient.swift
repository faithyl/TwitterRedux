//
//  TwitterClient.swift
//  Twitter
//
//  Created by Faith Cox on 9/29/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

let twitterConsumerKey = "WTmT6vVjQ6ULkzKtl98p9TEVb"
let twitterConsumerSecret = "gywhjH6E3NLkrDphdVrdLtwH0IxbfBZuiAW17I7uaYdd5Vy5qE"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion : ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        
    struct  Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
    
        return Static.instance
    }
    
    func homeTimeLineWithParams(params: NSDictionary?,
        completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
            GET("1.1/statuses/home_timeline.json" ,
                parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                    //println("timeline : \(response)")
                    var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
                    completion(tweets: tweets, error: nil)
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("error getting timeline")
                    //self.loginCompletion? (user: nil, error: error)
                    completion(tweets: nil, error: error)
            })
    }
    
    func mentionTimeLineWithParams(params: NSDictionary?,
        completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
            GET("/1.1/statuses/mentions_timeline.json" ,
                parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                    //println("mentiontimeline : \(response)")
                    var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
                    completion(tweets: tweets, error: nil)
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("error getting mentions timeline")
                    //self.loginCompletion? (user: nil, error: error)
                    completion(tweets: nil, error: error)
            })
    }
    
    func userTimeLineWithParams(params: NSDictionary?,
        completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
            GET("/1.1/statuses/user_timeline.json" ,
                parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                    println("Usertimeline : \(response)")
                    var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
                    completion(tweets: tweets, error: nil)
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("error getting mentions timeline")
                    //self.loginCompletion? (user: nil, error: error)
                    completion(tweets: nil, error: error)
            })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        //Fetch request token and redirect to authorization page
        requestSerializer.removeAccessToken()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterredux://oauth"), scope: nil, success: { (requestToken : BDBOAuthToken!) -> Void in
            println("Got the request Token")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL)
            }) { (error : NSError!) -> Void in
                println("Unable to get the request Token")
                self.loginCompletion? (user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuthToken(queryString: url.query), success: { (accessToken: BDBOAuthToken!) -> Void in
            println("Suceesfully got the Access Token")
        TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json" ,
            parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //println("User : \(response)")
            var user = User(dictionary: response as NSDictionary)
            User.currentUser = user
            println("User : \(user.name)")
            self.loginCompletion? (user: user, error: nil)
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("error getting user")
            self.loginCompletion? (user: nil, error: error)
            })
        }) { (error : NSError!) -> Void in
            println("Failed to recieve Access Token")
            self.loginCompletion? (user: nil, error: error)
        }
    }
    
    func sendGetRequest(endpoint: String, parameters: [String: String]!, callback: (response: AnyObject!, error: NSError!) -> Void) {
        GET(endpoint,
            parameters: parameters,
            success: {
                // Success
                (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                callback(response: response, error: nil)
            },
            failure: {
                // Failure
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                callback(response: nil, error: error)
        })
    }
    
    func sendPostRequest(endpoint: String, parameters: [String: String]!, callback: (error: NSError!) -> Void) {
        POST(endpoint,
            parameters: parameters,
            success: {
                // Success
                (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                callback(error: nil)
            },
            failure: {
                // Failure
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                callback(error: error)
        })
    }
    func tweet(status: String, callback: (error: NSError!) -> Void) {
        sendPostRequest("statuses/update.json",
            parameters: [ "status": status ],
            callback: callback)
    }
}
