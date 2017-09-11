//
//  DetailViewController.swift
//  Reddit Top
//
//  Created by Bruce Johnson on 9/7/17.
//  Copyright © 2017 Proviz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {


    public var redditManager: RedditManager? = nil

    func configureView() {
        // Update the user interface for the detail item.
        if let redditEntry = redditEntryItem {
            
            if let redditManager = self.redditManager {
                
                let imageView = UIImageView(frame: self.view.bounds)
                imageView.contentMode = .scaleAspectFit
                imageView.translatesAutoresizingMaskIntoConstraints = true
                
                let path = redditEntry.imageURL.pathExtension
                
                print("\(path)")

                
                redditManager.getImage(redditEntry.imageURL, completion: { (image) in
                    
                    if let img = image {
                        imageView.image = img
                        self.view.addSubview(imageView)
                        // support rotation
                        imageView.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]

                    }
                    
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var redditEntryItem: RedditEntry? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

