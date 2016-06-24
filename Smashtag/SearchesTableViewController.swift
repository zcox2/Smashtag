//
//  SearchesTableViewController.swift
//  Smashtag
//
//  Created by Zachary Cox on 6/24/16.
//  Copyright © 2016 Zachary Cox. All rights reserved.
//

import UIKit

class SearchesTableViewController: UITableViewController {
    var searchTableCounter: Int = 0
 
    var searches = [String]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        searchTableCounter += 1
        print("loaded, we're at \(searchTableCounter) tables")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        retrieveSearchHistory()
    }

    
    @IBAction func clearSearches(sender: UIBarButtonItem) {
        searches.removeAll()
        defaults.setObject(searches, forKey: "Searches")

    }
    
    func retrieveSearchHistory() {
        if let archivedSearches = defaults.arrayForKey("Searches") as? Array<String>? {
            if (archivedSearches != nil)  {
                searches = archivedSearches!
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searches.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCell", forIndexPath: indexPath)
        if let searchCell = cell as? SearchTableViewCell {
            searchCell.title.text = searches[indexPath.row]
            return searchCell
        }
        // Configure the cell...

        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("newSearch", sender: searches[indexPath.row])
    }
    
    // MARK: Memory Cycle Checking
    
    deinit {
        searchTableCounter -= 1
        print("deinitialized, we're at \(searchTableCounter) tables")
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationVC = segue.destinationViewController
        
        if let tabController = destinationVC as? UITabBarController {
            let twitterNavController = tabController.viewControllers![0]
            tabController.selectedViewController = twitterNavController
            destinationVC = twitterNavController
        }
        if let navController = destinationVC as? UINavigationController {
            destinationVC = navController.topViewController!
        }
        if let tweetTableVC = destinationVC as? TweetTableViewController {
            tweetTableVC.searchText = sender as? String
        }
    }


}
