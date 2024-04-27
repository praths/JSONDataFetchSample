//
//  PostListViewController.swift
//  JSONDataFetchSample
//
//  Created by Prathamesh Dabre on 27/04/24.
//

import UIKit

protocol ItemsService {
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) async
}

class PostListViewController: UITableViewController {
    var service: ItemsService?
    var items = [ItemViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await service?.loadItems(completion: handleAPIResult)
        }
        
    }
    
    private func handleAPIResult(_ result: Result<[ItemViewModel], Error>) {
        switch result {
        case let .success(items):
            self.items = items
            self.tableView.reloadData()
        case let .failure(error):
                self.showError(error: error)
        }
    }
    
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
    
    func select(post: Post) {
        let vc = PostDetailsViewController()
        vc.title = "Comments"
        let api = CommentsAPIItemsServiceAdapter(api: CommentsAPI.shared, postId: post.id)
        vc.service = api
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UITableViewCell {
    func configure(_ vm: ItemViewModel) {
        textLabel?.text = "\(vm.id)"
        detailTextLabel?.text = vm.title
        
    }
}


