//
//  DetailTweetTableViewController.swift
//  Smashtag
//
//  Created by Zachary Cox on 6/17/16.
//  Copyright © 2016 Zachary Cox. All rights reserved.
//

import UIKit

class DetailTweetTableViewController: UITableViewController {

    
    var tweet: Tweet? {
        didSet {
            linksList.removeAll()
            if let mediaList = tweet?.media {
                linksList.append(mediaList)
            }
            if let hashtags = tweet?.hashtags {
                linksList.append(hashtags)
            }
            if let userMentions = tweet?.userMentions {
                linksList.append(userMentions)
            }
            if let urls = tweet?.urls {
                linksList.append(urls)
            }
            print("tweetSet")
            print(tweet?.user ?? nil)
        }
    }
    
    struct links {
        var mediaList = [MediaItem]()
    }
    
    var linksList = [Any]()
    
    typealias MediaList = [MediaItem]
    typealias MentionList = [Tweet.IndexedKeyword]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let numSections = linksList.count
        print("number of sections is \(numSections)")
        return numSections
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let mediaList = linksList[section] as? [MediaItem] {
            print("\(mediaList.count) MediaItems, also we're section \(section)")
            return mediaList.count
        } else if let specialMentionList = linksList[section] as? MentionList {
            print("number of rows in section \(section) is \(specialMentionList.count)")
            let numRows = specialMentionList.count
            return numRows
        } else {
            print("returned zero rows")
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let specialMention = linksList[indexPath.section] as? MentionList {
            let cell = tableView.dequeueReusableCellWithIdentifier("specialMention", forIndexPath: indexPath)
            let specialMention = specialMention[indexPath.row]
            cell.textLabel?.text = specialMention.keyword
            
            print("it fucking called \(specialMention.keyword)")
            return cell
        }
        if let mediaList = linksList[indexPath.section] as? MediaList {
            let cell = tableView.dequeueReusableCellWithIdentifier("imageCell", forIndexPath: indexPath)
            let mediaItem = mediaList[indexPath.row]
            
            if let imageCell = cell as? LinkedImageTableViewCell {
                if let linkedImageURL = mediaItem.url {
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                        if let imageData = NSData(contentsOfURL: linkedImageURL) { // blocks main thread!
                            dispatch_async(dispatch_get_main_queue()) {
                                imageCell.linkedImageView?.image = UIImage(data: imageData)
                                
                            }
                        }
                    }
                }
                return imageCell
            }
            
            return cell
        }
        
        return tableView.dequeueReusableCellWithIdentifier("specialMention", forIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let mediaList = linksList[indexPath.section] as? MediaList {
            
            let mediaItem = mediaList[indexPath.row]
            let width = 350.0
            return CGFloat(width / mediaItem.aspectRatio)
            
        }
        return tableView.rowHeight
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let mediaList = linksList[section] as? MediaList {
            if mediaList.count > 0 {
                return "Linked Media"
            }
        }
        if let mentionList = linksList[section] as? MentionList {
            if mentionList.count > 0 {
                switch (section) {
                case 1: return "Hashtags"
                case 2: return "User Mentions"
                case 3: return "Linked URLs"
                default: return "Not sure what these are"
                }
            }
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
