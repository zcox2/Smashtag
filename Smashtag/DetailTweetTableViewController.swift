//
//  DetailTweetTableViewController.swift
//  Smashtag
//
//  Created by Zachary Cox on 6/17/16.
//  Copyright © 2016 Zachary Cox. All rights reserved.
//

import UIKit

class DetailTweetTableViewController: UITableViewController {
    
    var linksList = Links()
    
    var tweet: Tweet? {
        didSet {
            if let mediaList = tweet?.media {
                linksList.mediaList = mediaList
            }
            if let hashtags = tweet?.hashtags {
                linksList.hashtags = hashtags
            }
            if let userMentions = tweet?.userMentions {
                linksList.userMentions = userMentions
            }
            if let urls = tweet?.urls {
                linksList.urls = urls
            }
            print("tweetSet")
            print(tweet?.user ?? nil)
        }
    }
    
    struct Links {
        var mediaList = [MediaItem]()
        var hashtags: MentionList = []
        var userMentions: MentionList = []
        var urls: MentionList = []
    }
    
    func removeAllLinksFrom(listOfLinks: Links) -> Links{
        var links = listOfLinks
        links.mediaList.removeAll()
        links.hashtags.removeAll()
        links.userMentions.removeAll()
        links.urls.removeAll()
        return links
    }
    
    typealias MediaList = [MediaItem]
    typealias MentionList = [Tweet.IndexedKeyword]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let numSections = 4
        print("number of sections is \(numSections)")
        return numSections
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("Checking number of rows in section \(section)")
        switch (section) {
        case 0: return linksList.mediaList.count
        case 1: return linksList.hashtags.count
        case 2: return linksList.userMentions.count
        case 3: return linksList.urls.count
        default: return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch (indexPath.section) {
        case 0: // mediaList
            let cell = tableView.dequeueReusableCellWithIdentifier("imageCell", forIndexPath: indexPath)
            let mediaItem = linksList.mediaList[indexPath.row]
            if let imageCell = cell as? LinkedImageTableViewCell {
                if let linkedImageURL = mediaItem.url {
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                        if let imageData = NSData(contentsOfURL: linkedImageURL) {
                            dispatch_async(dispatch_get_main_queue()) {
                                imageCell.linkedImageView?.image = UIImage(data: imageData)
                            }
                        }
                    }
                }
                return imageCell
            }
            return cell
        case 1:
            let hashtags = linksList.hashtags
            let cell = tableView.dequeueReusableCellWithIdentifier("specialMention", forIndexPath: indexPath)
            let hashtag = hashtags[indexPath.row]
            cell.textLabel?.text = hashtag.keyword
            return cell
        case 2:
            let userMentions = linksList.userMentions
            let cell = tableView.dequeueReusableCellWithIdentifier("specialMention", forIndexPath: indexPath)
            let userMention = userMentions[indexPath.row]
            cell.textLabel?.text = userMention.keyword
            return cell
        case 3:
            let urls = linksList.urls
            let cell = tableView.dequeueReusableCellWithIdentifier("specialMention", forIndexPath: indexPath)
            let url = urls[indexPath.row]
            cell.textLabel?.text = url.keyword
            return cell
        default:
            break
        }
        return tableView.dequeueReusableCellWithIdentifier("specialMention", forIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let mediaItem = linksList.mediaList[indexPath.row]
            let width = 350.0
            return CGFloat(width / mediaItem.aspectRatio)
        }
        return CGFloat(65.0)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 0:
            if linksList.mediaList.count > 0 { return "Linked Media" }
        case 1:
            if linksList.hashtags.count > 0 { return "Hashtags"}
        case 2:
            if linksList.userMentions.count > 0 { return "User Mentions"}
        case 3:
            if linksList.urls.count > 0 { return "Linked URLs" }
        default:
            return "Not sure what these are"
        }
        return nil
    }
    
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
