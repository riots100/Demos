//
//  RedditManager.swift
//  Reddit Top
//
//  Created by Bruce Johnson on 9/7/17.
//  Copyright © 2017 Proviz. All rights reserved.
//

import Foundation

class RedditManager {

    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([RedditEntry]?, String) -> ()

    var entries: [RedditEntry] = []
    var errorMessage = ""

    func getEntries(completion: @escaping QueryResult) {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://www.reddit.com/top.json?limit=2")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                
                do {
                    if let responseJSON = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? JSONDictionary {
                        self.updateEntries(responseJSON)
                        completion(self.entries, self.errorMessage)
                    }
                } catch let parseError as NSError {
                    completion(self.entries, parseError.localizedDescription)
                }
            }
        })
        
        task.resume()
    }

    
    fileprivate func updateEntries(_ jsonDict: JSONDictionary) {
        
        self.entries.removeAll()
        
        guard let feed = jsonDict["data"] as? [String: Any],
            let apps = feed["children"] as? [[String: Any]] else {
                print("empty dictionary")
                return;
        }

        for entry in apps {
            
            do {
                let redditEntry = try RedditEntry(json: entry)
                self.entries.append(redditEntry)
            } catch let error {
                print(error)
            }
        }
    }
    
}
