//
//  Article.swift
//  TestTask
//
//  Created by Davit Baghdagyulyan on 12/6/18.
//  Copyright © 2018 Davit Baghdagyulyan. All rights reserved.
//

import Foundation
import RealmSwift

// class for main news type

class Article: Object {
    @objc private(set) dynamic var author: String?
    @objc private(set) dynamic var title: String?
    @objc private(set) dynamic var desc: String?
    @objc private(set) dynamic var urlToImage: String?
    @objc private(set) dynamic var content: String?
    @objc private(set) dynamic var publicDate: String?
    
    convenience init(json: [String : Any]) {
        self.init()
        author = json["author"] as? String
        title = json["title"] as? String
        desc = json["description"] as? String
        urlToImage = json["urlToImage"] as? String
        content = json["content"] as? String
        
        let dateStr = json["publishedAt"] as? String
        let dateFormatter = ISO8601DateFormatter()
        let publishDate = dateFormatter.date(from:dateStr!)!
        let currentDate = Date()
        
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: publishDate, to: currentDate)
        if components.day! == 1 {
            publicDate = "\(components.day!) day"
        } else  if components.day! > 1 {
            publicDate = "\(components.day!) days"
        } else if components.hour! == 1 {
            publicDate = "\(components.hour!) hour"
        } else  if components.hour! > 1 {
            publicDate = "\(components.hour!) hours"
        } else  if components.minute! <= 1  {
            publicDate = "\(components.minute!) minute"
        } else {
            publicDate = "\(components.minute!) minutes"
        }
    }
}
