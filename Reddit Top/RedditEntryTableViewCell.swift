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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateTitle(title: String) {
        
        self.titleLabel.text = title
        self.titleLabel.sizeToFit()
        
    }

}
