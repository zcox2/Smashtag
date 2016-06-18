//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Zachary Cox on 6/16/16.
//  Copyright © 2016 Zachary Cox. All rights reserved.
//

import UIKit
import QuartzCore

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var tweeter: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
   
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        // reset any existing tweet information
        tweetText?.attributedText = nil
        tweeter?.text = nil
        profilePicture?.image = nil
        tweetCreatedLabel?.text = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet
        {
            let formattedTweet = NSMutableAttributedString(string: tweet.text)
            
            // if user mentions another user, make that mention teal
            if tweet.userMentions.count != 0 {
                let redOrange = UIColor(red: 191/255, green: 46/255, blue: 37/255, alpha: 1.0)
                for mention in tweet.userMentions {
                    formattedTweet.addAttribute(NSForegroundColorAttributeName,
                                                value: redOrange,
                                                range: mention.nsrange)
                }
            }
            
            // if user hastags, make it GREEN
            if tweet.hashtags.count != 0 {
                for hashtag in tweet.hashtags {
                    formattedTweet.addAttribute(NSForegroundColorAttributeName,
                                                value: UIColor.greenColor(),
                                                range: hashtag.nsrange)
                }
            }
            
            // if user links url, make it blue
            if tweet.urls.count != 0 {
                for url in tweet.urls {
                    formattedTweet.addAttribute(NSForegroundColorAttributeName,
                                                value: UIColor.blueColor(),
                                                range: url.nsrange)
                }
            }
            
            
            tweetText?.attributedText = formattedTweet
            
            // Add camera emoticon if image is attached
            if tweetText?.text != nil  {
                for _ in tweet.media {
                    tweetText.text! += " 📷"
                }
            }
            
            tweeter?.text = "\(tweet.user)" // tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                if let imageData = NSData(contentsOfURL: profileImageURL) { // blocks main thread!
                    profilePicture?.image = UIImage(data: imageData)
                    profilePicture?.layer.cornerRadius = profilePicture.frame.size.width / 2
                }
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }
        
        
    }
}
