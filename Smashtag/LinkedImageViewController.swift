//
//  LinkedImageViewController.swift
//  Smashtag
//
//  Created by Zachary Cox on 6/18/16.
//  Copyright © 2016 Zachary Cox. All rights reserved.
//

import UIKit

class LinkedImageViewController: UIViewController, UIScrollViewDelegate {

    var imageURL: NSURL? {
        didSet {
            linkedImageView = nil
            fetchImage()
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = linkedImageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.5
            scrollView.maximumZoomScale = 1.5
        }
    }
    private func fetchImage() {
        weak var weakSelf = self
        if let url = imageURL {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                    if let imageData = NSData(contentsOfURL: url) {
                        dispatch_async(dispatch_get_main_queue()) {
                            weakSelf?.image = UIImage(data: imageData)
                        }
                    }
            }
            
        }
    }
    @IBOutlet var detailImageView: UIView!
    
    @IBOutlet weak var linkedImageView: UIImageView!
    
    var image: UIImage? {
        get {
            return linkedImageView.image
        } set {
            linkedImageView.image = newValue
            linkedImageView.sizeToFit()
            scrollView?.contentSize = linkedImageView.frame.size
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return linkedImageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(linkedImageView)

        linkedImageView.contentMode = UIViewContentMode.Center
        linkedImageView.sizeToFit()
        scrollView?.contentSize = linkedImageView.frame.size
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if linkedImageView == nil {
            fetchImage()
            linkedImageView.contentMode = UIViewContentMode.ScaleAspectFill
            linkedImageView.sizeToFit()
            scrollView?.contentSize = linkedImageView.frame.size
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
