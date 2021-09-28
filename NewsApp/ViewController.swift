//
//  ViewController.swift
//  NewsApp
//
//  Created by Franco Garza on 27/09/21.
//

import UIKit
import SafariServices

// CONSTANTS


class ViewController: UIViewController{

    let viewModel = NewsListModel()
    
    let topics = ["Business", "Entertainment", "Health", "Technology", "Sports"]
    var selectedRow = Int()
    
    private lazy var headerView: HeaderView = {
        let v = HeaderView(fontSize: 32)
        return v
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        v.backgroundColor = .white
        v.allowsSelection = true
        v.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        v.showsHorizontalScrollIndicator = false
        return v
    }()
    
    private lazy var tableView: UITableView = {
        let v = UITableView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.tableFooterView = UIView()
        v.register(NewsTableViewCell.self, forCellReuseIdentifier: viewModel.reuseID)
        v.delegate = self
        v.dataSource = self
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.topic = "general"
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupView()
        fetchNews()
    }

    func setupView(){
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(collectionView)
        
        setupConstraints()
    }
    
    func setupConstraints(){
        // header
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
            
        ])
        // collectionView
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 30)
        ])
        // tableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func fetchNews(){
        viewModel.getNews { (_) in
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.newsVM.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.reuseID, for: indexPath) as? NewsTableViewCell
        let news = viewModel.newsVM[indexPath.row]
        cell?.newsVM = news
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = viewModel.newsVM[indexPath.row]
        guard let url = URL(string: news.url) else {
            return
        }
        
        let config = SFSafariViewController.Configuration()
        let safariViewController = SFSafariViewController(url: url, configuration: config)
//        safariViewController.modalPresentationStyle = .formSheet
        safariViewController.modalPresentationStyle = .fullScreen
        present(safariViewController, animated: true)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height * 5, height: collectionView.frame.height/1)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        cell.title.textColor = .systemBlue
        cell.contentView.backgroundColor = .white
        if indexPath.row == selectedRow {
            cell.title.textColor = .white
            cell.contentView.backgroundColor = .systemBlue
        }
        cell.title.text = topics[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
        viewModel.topic = cell.title.text!
        fetchNews()
    }
    
}
