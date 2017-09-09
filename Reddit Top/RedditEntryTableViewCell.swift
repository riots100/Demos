//
//  RedditEntryTableViewCell.swift
//  Reddit Top
//
//  Created by Bruce Johnson on 9/8/17.
//  Copyright © 2017 Proviz. All rights reserved.
//

import UIKit

class RedditEntryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateText(_ title: String, _ author: String, _ date: String) {
        
        self.titleLabel.text = title
        self.titleLabel.sizeToFit()
        
        self.authorLabel.text = author
        self.dateLabel.text = date
    }

}
