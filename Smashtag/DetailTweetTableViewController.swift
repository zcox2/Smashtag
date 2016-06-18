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
            specialMentions.removeAll()
            if let hashtags = tweet?.hashtags where hashtags.count != 0 {
                specialMentions.append(hashtags)
            }
            if let userMentions = tweet?.userMentions {
                specialMentions.append(userMentions)
            }
            if let urls = tweet?.urls {
                specialMentions.append(urls)
            }
            print("tweetSet")
            print(tweet?.user ?? nil)
        }
    }

    var specialMentions = [Array<Tweet.IndexedKeyword>]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let numSections = specialMentions.count
        print("number of sections is \(numSections)")
        return numSections
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numRows = specialMentions[section].count
        print("number of sections is \(numRows)")
        return numRows
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("it finally was fucking called")
        let cell = tableView.dequeueReusableCellWithIdentifier("specialMention", forIndexPath: indexPath)
        let specialMention = specialMentions[indexPath.section][indexPath.row]
        cell.textLabel?.text = specialMention.keyword
        print(specialMention.keyword)
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 0: return "Hashtags"
        case 1: return "User Mentions"
        case 2: return "Linked URLs"
        default: return "Not sure what these are"
        }
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
