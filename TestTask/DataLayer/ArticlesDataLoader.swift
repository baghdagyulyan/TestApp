//
//  ArticlesDataLoader.swift
//  TestTask
//
//  Created by Davit Baghdagyulyan on 12/6/18.
//  Copyright © 2018 Davit Baghdagyulyan. All rights reserved.
//

import Foundation

typealias CompletionHandler = ([Article?]?, Error?) -> Void

class ArticleDataLoader {
    private let baseURL = "https://newsapi.org/v2/top-headlines" // base url
    private let apiKey = "2eef6ca9d9ac4fd6bca3bd7511a71513" // API key from registration
    var articles = [Article?]() // loaded articles array
    private var url: String? {
        get {
            return String(format: "\(baseURL)?country=us&apiKey=\(apiKey)")
        }
    }
    
    // MARK: function for getting Articles array from json
    static func newArticles(articles:[[String : AnyObject]]) -> [Article?] {
        return articles.map{ element in
            return Article.init(json: element)
        }
    }
    
    // MARK: session configuration load from cahce or not
    static func configureSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession.init(configuration: config)
    }
    
    // MARK: load data from server
    func loadDada(completion: @escaping CompletionHandler) {
        DispatchQueue.global().async {
            let requestUrl = URL(string: self.url!)
            ArticleDataLoader.configureSession().dataTask(with: requestUrl!) {(data, response, error) in
                guard let jsonData = data, error == nil else {
                    completion(nil, error)
                    return
                }
                do {
                    if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: AnyObject],
                        let results = json["articles"] as? [[String:AnyObject]] {
                        let items = ArticleDataLoader.newArticles(articles: results)
                        completion(items, nil)
                    } else {
                        completion(nil, error)
                    }
                } catch {
                    completion(nil, error)
                }
            }.resume()
        }
    }
}
