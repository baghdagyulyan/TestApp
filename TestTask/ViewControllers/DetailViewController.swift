//
//  DetailViewController.swift
//  TestTask
//
//  Created by Davit Baghdagyulyan on 12/6/18.
//  Copyright © 2018 Davit Baghdagyulyan. All rights reserved.
//

import UIKit

enum SaveMode {
    case save
    case unSave
}

class DetailViewController: UIViewController {
    private var heightOfRows = [Int: CGFloat]()
    private var article : Article!
    private var detialTableView : UITableView!
    private let descriptionCellReuseIdentifier = "DescriptionCell"
    private var saveMode : SaveMode!
    private var tmpSaveMode : SaveMode!
    
    convenience init(article: Article, saveMode: SaveMode) {
        self.init()
        self.article = article
        self.saveMode = saveMode
        self.tmpSaveMode = saveMode
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: self.saveMode == .save ? "UnSave" : "Save", style: .plain, target: self, action: #selector(addTapped))
        
        self.setup()
    }
    
    // MARK:  updating db befor view will disappear
    override func viewWillDisappear(_ animated: Bool) {
        guard self.tmpSaveMode != self.saveMode else {
            return
        }
        if self.tmpSaveMode == .unSave {
            let results = RealmManager.sharedManager.getObjects(type: Article.self)
            for result in results! {
                if (result as! Article).title ==  article?.title {
                    RealmManager.sharedManager.deleteObject(objs: result)
                    break
                }
            }
        } else {
            RealmManager.sharedManager.saveObjects(objs: self.article)
        }
    }
    
    // MARK: setup all stuff
    private func setup() {
        self.view.backgroundColor = UIColor.white
        self.setupHeightOfRows()
        self.setupTableView()
    }
    
    // MARK: calculate height for rows regarding texts
    private func setupHeightOfRows() {
        var height1 = CGFloat(0)
        var height2 = CGFloat(0)
        var height3 = CGFloat(0)
        var height4 = CGFloat(0)
        
        if article.author != nil {
            height1 = CGFloat((article.author?.heightWithConstrainedWidth(width: self.view.frame.size.width - 30, font: UIFont.systemFont(ofSize: 18)))!) + 20.0
        }
        
        if article.title != nil {
            height2 = CGFloat((article.title?.heightWithConstrainedWidth(width: self.view.frame.size.width - 30, font: UIFont.systemFont(ofSize: 18)))!) + 20.0
        }
        
        if article.desc != nil {
            height3 = CGFloat((article.desc?.heightWithConstrainedWidth(width: self.view.frame.size.width - 30, font: UIFont.systemFont(ofSize: 18)))!) + 20.0
        }
        
        if article.content != nil {
            height4 = CGFloat((article.content?.heightWithConstrainedWidth(width: self.view.frame.size.width - 30, font: UIFont.systemFont(ofSize: 18)))!) + 20.0
        }
        
        heightOfRows = [0: height1, 1: height2, 2: height3, 3: height4] 
    }
    
    // MARK: setup table view
    private func setupTableView() {
        detialTableView = UITableView.init(frame:(CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)))
        detialTableView.delegate = self
        detialTableView.dataSource = self
        detialTableView.tableHeaderView = self.viewForHeaderInSection()
        detialTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        detialTableView.register(UINib(nibName: "DescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: descriptionCellReuseIdentifier)
        self.detialTableView.separatorStyle = .none
        self.view.addSubview(detialTableView)
    }
    
    // MARK: view for showing image
    func viewForHeaderInSection() -> UIView {
        let imageView = UIImageView(frame: CGRect(x: 0, y:0, width: self.view.frame.size.width, height: self.view.frame.size.width/2))
        imageView.backgroundColor = UIColor.gray
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        if let urlOfImage = article?.urlToImage {
            let url = URL(string:urlOfImage)
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage(named: "noImage")
        }
        return imageView
    }
    
    // MARK: save unSave button click handling
    @objc func addTapped() {
        if self.tmpSaveMode == .save {
            self.tmpSaveMode = .unSave
        } else {
            self.tmpSaveMode = .save
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: self.tmpSaveMode == .save ? "UnSave" : "Save", style: .plain, target: self, action: #selector(addTapped))
    }
}

// MARK: UITableView DataSource and UITableView Delegate
extension DetailViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heightOfRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: descriptionCellReuseIdentifier, for: indexPath) as! DescriptionTableViewCell
        switch indexPath.row {
        case 0:
            cell.descriptionTextLabel?.text = self.article.author
            break
        case 1:
            cell.descriptionTextLabel?.text = self.article.title
            break
        case 2:
            cell.descriptionTextLabel?.text = self.article.desc
            break
        case 3:
            cell.descriptionTextLabel?.text = self.article.content
            break
        default:
            break
        }
        cell.selectionStyle = .none
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfRows[indexPath.row]!
    }
}
