//
//  RedditManager.swift
//  Reddit Top
//
//  Created by Bruce Johnson on 9/7/17.
//  Copyright © 2017 Proviz. All rights reserved.
//

import UIKit

class RedditManager {

    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([RedditEntry]?, String) -> ()

    var entries: [RedditEntry] = []
    var errorMessage = ""

    var dataTask: URLSessionDataTask?
    
    var imageCache: NSCache<AnyObject, AnyObject>
    
    init() {
        
        self.imageCache = NSCache()
        
    }
    
    func getEntries(completion: @escaping QueryResult) {
        
        dataTask?.cancel()

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://www.reddit.com/top.json?limit=50")!
        
        dataTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            defer { self.dataTask = nil }
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                
                do {
                    if let responseJSON = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? JSONDictionary {
                        self.updateEntries(responseJSON)
                        DispatchQueue.main.async {
                            completion(self.entries, self.errorMessage)
                        }
                    }
                } catch let parseError as NSError {
                    completion(self.entries, parseError.localizedDescription)
                }
            }
        })
        
        dataTask?.resume()
    }

    
    fileprivate func updateEntries(_ jsonDict: JSONDictionary) {
        
        self.entries.removeAll()
        
        guard let feed = jsonDict["data"] as? [String: Any],
            let redditEndtries = feed["children"] as? [[String: Any]] else {
                print("empty dictionary")
                return;
        }

        for entry in redditEndtries {
            
            do {
                let redditEntry = try RedditEntry(json: entry)
                self.entries.append(redditEntry)
            } catch let error {
                print(error)
            }
        }
    }
    
    func getImage(_ imageURL: URL, completion: @escaping (UIImage?) -> ()) {
        
        if (self.imageCache.object(forKey: imageURL as AnyObject)) != nil {
            
            let img = self.imageCache.object(forKey: imageURL as AnyObject) as? UIImage
            DispatchQueue.main.async {
                completion(img)
            }
        }
        else {
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            var imageTask = URLSessionDownloadTask()
            
            imageTask = session.downloadTask(with: imageURL, completionHandler: { (location, response, error) -> Void in
                
                if let data = try? Data(contentsOf: imageURL) {
                    
                    if let img: UIImage = UIImage(data: data) {
                        
                        self.imageCache.setObject(img, forKey: (forKey: imageURL as AnyObject) as AnyObject)
                        
                        DispatchQueue.main.async {
                            completion(img)
                        }
                    }
                }
            })
            
            imageTask.resume()
        }
    }
    
    
}

extension Date {
    
    func localStringWithFormat(_ dateFormat: String) -> String {
        // change to a readable time format and change to local time zone
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: self)
        
        return timeStamp
    }
    
    func timeAgoSinceDate() -> String {
        let calendar = Calendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < self ? now : self
        let latest = (earliest == now) ? self : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1) {
            return "1 year ago"
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1) {
            return "1 month ago"
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1) {
            return "1 week ago"
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1) {
            return "1 day ago"
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1) {
            return "1 hour ago"
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1) {
            return "1 minute ago"
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
    }

}

