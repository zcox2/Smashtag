//
//  LinkedImageViewController.swift
//  Smashtag
//
//  Created by Zachary Cox on 6/18/16.
//  Copyright © 2016 Zachary Cox. All rights reserved.
//

import UIKit

class LinkedImageViewController: UIViewController, UIScrollViewDelegate {
    
//    weak var imageViewBottomConstraint: NSLayoutConstraint!
//    weak var imageViewTrailingConstraint: NSLayoutConstraint!
//    weak var imageViewLeadingConstraint: NSLayoutConstraint!
//    weak var imageViewTopConstraint: NSLayoutConstraint!
//    
    
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    
    var imageURL: NSURL? {
        didSet {
            if image == nil {
                fetchImage()
            }
        }
    }
    
    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            
            scrollView.minimumZoomScale = 1
            scrollView.maximumZoomScale = 2
        }
    }
    private func fetchImage() {
        print("image fetching")
        //weak var weakSelf = self
        if let url = imageURL {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                if let imageData = NSData(contentsOfURL: url) {
                    print("image fetched off main queue")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.image = UIImage(data: imageData)
                        print("image assigned to self.image on main queue")
                    }

                }
            }
            
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    // private var linkedImageView = UIImageView()
    
    private var image: UIImage? {
        get {
            return imageView?.image
        } set {
            if imageView != nil { print("Image set") }
            imageView?.image = newValue
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        print("view did load")
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if image == nil {
            fetchImage()
        }
        print("view did appear")
        scrollView.contentSize = imageView.frame.size
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.clipsToBounds = true
        imageView.sizeToFit()

        scrollView.addSubview(imageView)
        scrollView.contentSize = imageView.frame.size
        if scrollView != nil { print("image formatted") }
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        scrollView.contentSize = imageView.frame.size

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
