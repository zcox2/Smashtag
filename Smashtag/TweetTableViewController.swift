//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Zachary Cox on 6/16/16.
//  Copyright © 2016 Zachary Cox. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate {

    
    var tweet: Tweet? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl?.addTarget(self, action: #selector(TweetTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        searchText = "#spreadsomelove"
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationItem.title = "tweets"
    }

    func refresh(sender: UIRefreshControl) {
        searchForTweets()
        self.refreshControl?.endRefreshing()
    }
    
    var tweets = [Array<Tweet>]() {
        didSet {
            tableView.reloadData()
        }
    }

    var searchText: String? {
        didSet {
            tweets.removeAll()
            searchForTweets()
            title = searchText
        }
    }
    
    private var lastTwitterRequest: TwitterRequest?
    
    private var twitterRequest: TwitterRequest? {
        if let query = searchText where !query.isEmpty {
            return TwitterRequest(search: query + " -filter:retweets", count: 100)
        }
        return lastTwitterRequest?.requestForNewer
    }
    
    private func searchForTweets() {
        if let request = twitterRequest {
            lastTwitterRequest = request
            request.fetchTweets { [weak weakSelf = self] newTweets in
                dispatch_async(dispatch_get_main_queue()) {
                    if request == weakSelf?.lastTwitterRequest {
                        if !newTweets.isEmpty {
                            weakSelf?.tweets.insert(newTweets, atIndex: 0)
                        }
                    }
                    weakSelf?.refreshControl?.endRefreshing()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }

    private struct Storyboard {
        static let TweetCellIdentifier = "Tweet"
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TweetCellIdentifier, forIndexPath: indexPath)
        
        let tweet = tweets[indexPath.section][indexPath.row]
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        
        return cell
        
    }
    
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            self.searchTextField.delegate = self
            self.searchTextField.text = searchText
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showTweetDetail", sender: tweets[indexPath.section][indexPath.row])
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        var destinationVC = segue.destinationViewController
        if let navcon = segue.destinationViewController as? UINavigationController {
            destinationVC = navcon.visibleViewController ?? destinationVC
        }
        
        
            //weak var weakSelf = self
        if let detailTweetVC = destinationVC as? DetailTweetTableViewController {
            if segue.identifier == "showTweetDetail" {
                if let selectedTweet = sender as? Tweet {
                    detailTweetVC.tweet = selectedTweet
                    detailTweetVC.navigationItem.title = selectedTweet.user.screenName
                    
                }
            }
        }
    }
    

}

extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}

