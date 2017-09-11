//
//  MasterViewController.swift
//  Reddit Top
//
//  Created by Bruce Johnson on 9/7/17.
//  Copyright © 2017 Proviz. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
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
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let entry = redditEntries[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
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
    
        redditManager.getThumbNail(redditEntry.thumbnailURL) { (image) in

            //make sure the cell is on screen
            if let updateCell = tableView.cellForRow(at: indexPath) as? RedditEntryTableViewCell {
                if let img = image {
                    updateCell.updateThumbNailImage(img)
                }
            }
            
        }
        
        return cell!
    }


}

