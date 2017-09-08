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
    case URLNotValid(String)
}

public struct RedditEntry {

    public let title: String
    public let thumbnailURL: URL
    public let imageURL: URL
    
    public init(json: [String: Any]) throws {
        
        guard let container = json["data"] as? [String: Any],
            let title = container["title"] as? String else {
                throw RedditEntryError.missing("title")
        }
        
        self.title = title

        guard let thumbnailLink = container["thumbnail"] as? String else {
            throw RedditEntryError.missing("thumbnail")
        }
        
        guard let thumbNailURL = URL(string: thumbnailLink) else {
            throw RedditEntryError.URLNotValid(thumbnailLink)
        }
        
        self.thumbnailURL = thumbNailURL
        
        
        guard let imageLink = container["url"] as? String else {
            throw RedditEntryError.missing("url")
        }
        
        guard let imageLinkURL = URL(string: imageLink) else {
            throw RedditEntryError.URLNotValid(imageLink)
        }

        self.imageURL = imageLinkURL
    }

}
