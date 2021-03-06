//
//  RedditEntryTableViewCell.swift
//  Reddit Top
//
//  Created by Bruce Johnson on 9/8/17.
//  Copyright © 2017 Proviz. All rights reserved.
//

import UIKit

protocol thumbNailSelectedProtocol: class {
    
    func didSelectThumbnail(row: Int)
    
}

class RedditEntryTableViewCell: UITableViewCell {

    weak var delegate: thumbNailSelectedProtocol?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action:  #selector(thumbnailTapped(_:)))
        thumbnailImageView.addGestureRecognizer(tapRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func thumbnailTapped(_ tapRecognizer: UITapGestureRecognizer) {

        delegate?.didSelectThumbnail(row: self.tag)
        
    }
    
    func updateText(_ title: String, _ author: String, _ date: String, _ commentCount: Int) {
        
        self.titleLabel.text = title
        self.titleLabel.sizeToFit()
        
        self.authorLabel.text = author
        self.dateLabel.text = date
        self.commentCountLabel.text = "\(commentCount)"
    }

    func updateThumbNailImage(_ image: UIImage) {
        
        self.thumbnailImageView.image = image
        self.thumbnailImageView.alpha = 1.0
        
    }
    
    func setPlaceholderImage() {
        
        self.thumbnailImageView.image = UIImage(named: "Reddit_Logo.png")
        self.thumbnailImageView.alpha = 0.5
    }
    
}
