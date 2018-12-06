//
//  ViewController.swift
//  TestTask
//
//  Created by Davit Baghdagyulyan on 12/6/18.
//  Copyright © 2018 Davit Baghdagyulyan. All rights reserved.
//

import UIKit

class ArticlesViewController: UIViewController {

    private var articlesLoader: ArticleDataLoader!
    private var articles = [Article?]()
    private var articlesTableView: UITableView!
    private var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red// todo delete
        self.title = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String // dynamically read app name from budle
        self.setUp()
    }
    
    func setUp() {
        self.setUpDataLoader()
        self.setUpTableView()
    }
    // MARK: configure data loader
    func setUpDataLoader() {
        articlesLoader = ArticleDataLoader()
        articlesLoader.loadDada { (articles, error) in
            if (articles != nil) {
                self.articles = articles!
            }
            DispatchQueue.main.async {
                self.articlesTableView.reloadData()
            }
        }
    }
    
    // MARK: configure tableview
    func setUpTableView() {
        articlesTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        articlesTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(articlesTableView)
    }

}

