//
//  MasterViewController.swift
//  Reddit Top
//
//  Created by Bruce Johnson on 9/7/17.
//  Copyright © 2017 Proviz. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, thumbNailSelectedProtocol {

    var redditEntries = [RedditEntry]()

    let redditManager = RedditManager();

    override func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(getRedditEntries(_:)))
        navigationItem.rightBarButtonItem = addButton
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getRedditEntries(_ sender: Any) {
        
        redditManager.getEntries { (entries, error) in
            
            if let redditEntries = entries {
                self.redditEntries = redditEntries
                self.tableView.reloadData()
            }
            
        }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show-detail" {
            if let entry = sender as? RedditEntry {
                let controller = segue.destination as! DetailViewController
                controller.redditManager = self.redditManager
                controller.redditEntryItem = entry
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return redditEntries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RedditEntryCell", for: indexPath) as? RedditEntryTableViewCell

        let redditEntry = redditEntries[indexPath.row]
        
        let localCreatedDate = redditEntry.createdAt_UTC.timeAgoSinceDate()
        
        cell?.updateText(redditEntry.title, redditEntry.author, localCreatedDate, redditEntry.num_comments)
        cell?.tag = indexPath.row
        cell?.delegate = self;
        
        redditManager.getImage(redditEntry.thumbnailURL) { (image) in

            //make sure the cell is on screen
            if let updateCell = tableView.cellForRow(at: indexPath) as? RedditEntryTableViewCell {
                //do we have an image
                if let img = image {
                    updateCell.updateThumbNailImage(img)
                } else {
                    updateCell.setPlaceholderImage()
                }
            } else {
                cell?.setPlaceholderImage()
            }
            
        }
        
        return cell!
    }

    // MARK: - thumbNailSelectedProtocol
    
    func didSelectThumbnail(row: Int) {
        
        let entry = redditEntries[row]
        self.performSegue(withIdentifier: "show-detail", sender: entry)
    }

}

