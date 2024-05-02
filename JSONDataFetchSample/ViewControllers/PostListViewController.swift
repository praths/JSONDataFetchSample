//
//  PostListViewController.swift
//  JSONDataFetchSample
//
//  Created by Prathamesh Dabre on 27/04/24.
//

import UIKit

protocol ItemsService {
    func loadItems(page: Int, limit: Int, postId: String, completion: @escaping (Result<[ItemViewModel], Error>) -> Void)
}

class PostListViewController: UITableViewController {
    var service: ItemsService?
    var items = [ItemViewModel]() {
        didSet {
            reloadData()
        }
    }
    
    private var page: Int = 1
    private var limit: Int = 15
    
    private var memoizedLoadComments: ((Int, Int, String, @escaping ((Result<[ItemViewModel], Error>) -> Void)) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service?.loadItems(page: page, limit: limit, postId: "", completion: handleAPIResult)
        
        let api = CommentsAPIItemsServiceAdapter(api: CommentsAPI.shared)
        memoizedLoadComments = memoize(api.loadItems)
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
        if shouldFetchNextPage(row: indexPath.row) {
            page += 1
            service?.loadItems(page: page, limit: limit, postId: "", completion: handleAPIResult)
        }
    }
    
    private func shouldFetchNextPage(row: Int) -> Bool {
        return row > (page * limit) - 2
    }
    
    func select(post: Post) {
        let vc = PostDetailsViewController()
        vc.title = "Comments"
        
        let start = CFAbsoluteTimeGetCurrent()
        Task {
            memoizedLoadComments?(1, 10, "\(post.id)") {  result in
                switch result {
                case let .success(items):
                    vc.items = items
                case let .failure(error):
                    vc.showError(error: error)
                }
            }
        }
        let diff = CFAbsoluteTimeGetCurrent() - start
        print("Took \(diff) seconds")
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func memoize<Input: Hashable, Output>(_ function: @escaping (Int, Int, Input, @escaping ((Result<[Output], Error>) -> Void)) -> Void) -> (Int, Int, Input, @escaping ((Result<[Output], Error>) -> Void)) -> Void
    {
        var cachedComments: [Input : [Output]?] = [ : ]
        
        return { (page: Int, limit: Int, postId: Input, callback: @escaping ((Result<[Output], Error>) -> Void)) in
            if let comments = cachedComments[postId] as? [Output] {
                callback(.success(comments))
                return
            }
            
            function(page, limit, postId) { result in
                switch result {
                case .success(let comments):
                    cachedComments[postId] = comments
                    callback(.success(comments))
                case .failure(let error):
                    callback(.failure(error))
                }
            }
        }
    }
}
