//
//  RedditEntry.swift
//  Reddit Top
//
//  Created by Bruce Johnson on 9/8/17.
//  Copyright © 2017 Proviz. All rights reserved.
//

import Foundation

enum RedditEntryError: Error {
    case missing(String)
}

public struct RedditEntry {

    public let title: String
    public let author: String
    public let thumbnailURL: URL
    public let imageURL: URL
    public let createdAt_UTC: Date
    public let num_comments: Int
    
    public let dateFormat = "EEE, MMM d, yyyy - h:mm a"
    
    public init(json: [String: Any]) throws {
        
        //title
        guard let container = json["data"] as? [String: Any],
            let title = container["title"] as? String else {
                throw RedditEntryError.missing("title")
        }
        self.title = title
        //thunbnail URL
        guard let thumbnailLink = container["thumbnail"] as? String,
            let thumbNailURL = URL(string: thumbnailLink) else {
            throw RedditEntryError.missing("thumbnail")
        }
        self.thumbnailURL = thumbNailURL
        //image URL
        guard let imageLink = container["url"] as? String,
            let imageLinkURL = URL(string: imageLink) else {
            throw RedditEntryError.missing("url")
        }
        self.imageURL = imageLinkURL
        //author
        guard let author = container["author"] as? String else {
            throw RedditEntryError.missing("author")
        }
        self.author = author
        //created
        guard let created = container["created_utc"] as? TimeInterval else {
            throw RedditEntryError.missing("created_utc")
        }
        let createdDate = Date(timeIntervalSince1970: created)
        self.createdAt_UTC = createdDate
        //number of comments
        guard let numComments = container["num_comments"] as? Int else {
            throw RedditEntryError.missing("num_comments")
        }
        self.num_comments = numComments
    }

}


