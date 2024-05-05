//
//  PostListViewController.swift
//  JSONDataFetchSample
//
//  Created by Prathamesh Dabre on 27/04/24.
//

import UIKit

class PostListViewController: UITableViewController {
    var service: ItemsService?
    var items = [ItemViewModel]() {
        didSet {
            reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        loadPosts()
    }
    
    private func configureTableView() {
        self.tableView.separatorColor = .clear
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 300
    }
    
    private func loadPosts() {
        service?.loadIntialPage(completion: handleAPIResult)
    }

    private func handleAPIResult(_ result: Result<[ItemViewModel], Error>) {
        switch result {
        case let .success(items):
            self.items += items
        case let .failure(error):
            self.showError(error: error)
        }
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func select(post: Post) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let postDetailsVC = storyboard.instantiateViewController(withIdentifier: "PostDetailsVC") as? PostDetailsViewController {
            postDetailsVC.title = "Comments"
            postDetailsVC.post = post
            postDetailsVC.service = service
            self.navigationController?.pushViewController(postDetailsVC, animated: true)
        }
    }
}

extension PostListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostTableViewCell ?? PostTableViewCell(style: .default, reuseIdentifier: "PostCell")
        let item = items[indexPath.row]
        cell.configure(item, service: service)
        cell.setConstraints(tableViewWidth: tableView.bounds.width)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        item.select()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if service?.shouldFetchNextPage(row: indexPath.row) ?? false {
            showSpinnerAtTheBottom()
            service?.loadNextPage(completion: { [weak self] result in
                guard let self = self else {
                    return
                }
                self.handleAPIResult(result)
                DispatchQueue.main.async {
                    self.hideSpinnerAtTheBottom()
                }
            })
        }
    }
}
