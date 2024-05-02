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
        self.tableView.reloadData()
    }
    
    func select(post: Post) {
        let postDetailsVC = PostDetailsViewController(post: post)
        postDetailsVC.title = "Comments"
        postDetailsVC.service = service
        self.navigationController?.pushViewController(postDetailsVC, animated: true)
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
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "ItemCell")
        cell.configure(item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        item.select()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if service?.shouldFetchNextPage(row: indexPath.row) ?? false {
            service?.loadNextPage(completion: handleAPIResult)
        }
    }
}
