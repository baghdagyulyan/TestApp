//
//  ViewController.swift
//  TestTask
//
//  Created by Davit Baghdagyulyan on 12/6/18.
//  Copyright © 2018 Davit Baghdagyulyan. All rights reserved.
//

import UIKit
import Kingfisher

class ArticlesViewController: UIViewController {

    private var articlesLoader: ArticleDataLoader!
    private var articles = [Article?]()
    private var articlesTableView: UITableView!
    private var segmentedControl: UISegmentedControl!
    private let segmentedControllHeight = CGFloat(50.0)
    private let articleCellReuseIdentifier = "ArticleCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String // dynamically read app name from budle
        self.setUp()
    }
    // MARK: setup all stuff
    func setUp() {
        self.setUpDataLoader()
        self.setUpTableView()
        self.setUpSegmentedControll()
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
        articlesTableView.delegate = self
        articlesTableView.dataSource = self
        articlesTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: articleCellReuseIdentifier)
        self.view.addSubview(articlesTableView)
    }
    
    // MARK: configure segmented controll
    func setUpSegmentedControll() {
        let segments = ["NEWS", "SAVED NEWS"]
        segmentedControl = UISegmentedControl(items: segments)
        segmentedControl.addTarget(self, action: #selector(tabChanged(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.height, height: segmentedControllHeight)
        self.view.addSubview(segmentedControl)
    }
    
    // MARK:  reload table views
    override func viewWillAppear(_ animated: Bool) {
        if segmentedControl.selectedSegmentIndex == 0 {
            self.loadNews()
        } else {
            self.loadSavedNews()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        segmentedControl.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.view.frame.size.width, height: segmentedControllHeight)
        articlesTableView.frame = CGRect(x: 0, y: segmentedControl.frame.maxY, width: self.view.frame.size.width, height: self.view.frame.size.height - segmentedControl.frame.maxY - self.view.safeAreaInsets.bottom)
    }
    
    // MARK: load news from server or cache
    func loadNews() {
        articlesLoader.loadDada { (articles, error) in
            if (articles != nil) {
                self.articles = articles!
            } else {
                self.articles.removeAll()
            }
            DispatchQueue.main.async {
                self.articlesTableView.reloadData()
            }
        }
    }
    
    // MARK: load news from db
    func loadSavedNews() {
        let results = RealmManager.sharedManager.getObjects(type: Article.self)
        articles.removeAll()
        
        for result in results! {
            articles.append((result as! Article))
        }
        DispatchQueue.main.async {
            self.articlesTableView.reloadData()
        }
    }

    // MARK: handle segmented tabs change
    @objc func tabChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.loadNews()
        case 1:
            self.loadSavedNews()
        default:
            break
        }
        
    }
}

// MARK: UITableView DataSource and UITableView Delegate
extension ArticlesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: articleCellReuseIdentifier, for: indexPath) as! ArticleTableViewCell
        if (tableView.indexPathsForVisibleRows!.contains(indexPath)) {
            let article = self.articles[indexPath.row]
            if let articleCreation = article?.publicDate {
                cell.publiclabel.text = String(format:"\(articleCreation) before")
            }

            if let urlOfImage = article?.urlToImage {
                let url = URL(string:urlOfImage)
                cell.articleImageView.kf.setImage(with: url)
            } else {
                cell.articleImageView.image = UIImage(named: "noImage")
            }
            cell.authorLabel.text = article?.author
            cell.titleLabel.text = article?.title

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let article = self.articles[indexPath.row]

        let results = RealmManager.sharedManager.getObjects(type: Article.self)
        //        articles.removeAll()
        
        var isSaveMode = true
        for result in results! {
            if (result as! Article).title ==  article?.title{
                isSaveMode = false
            }
        }
        
        let detailViewController = DetailViewController.init(article: article!, saveMode: isSaveMode ? .unSave : .save)
        self.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

}

