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
            if let userMentions = tweet?.userMentions where userMentions.count != 0 {
                specialMentions.append(userMentions)
            }
            if let urls = tweet?.urls where urls.count != 0 {
                specialMentions.append(urls)
            }
            tableView?.reloadData()
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
        return numSections
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let numRows = specialMentions[section].count
            return numRows
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("specialMention", forIndexPath: indexPath)
        let specialMention = specialMentions[indexPath.section][indexPath.row]
        cell.textLabel?.text = specialMention.keyword
        
        return cell
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
