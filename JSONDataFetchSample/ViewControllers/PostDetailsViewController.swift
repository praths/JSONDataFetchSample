//
//  PostDetailsViewController.swift
//  JSONDataFetchSample
//
//  Created by Prathamesh Dabre on 27/04/24.
//

import UIKit

class PostDetailsViewController: UITableViewController {
    var service: ItemsService?
    var items = [ItemViewModel](){
        didSet {
            reloadData()
        }
    }
    
    var post: Post?
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        spinner.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        spinner.backgroundColor = .white
        spinner.startAnimating()
        spinner.center = self.tableView.center
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        loadComments()
    }
    
    private func configureTableView() {
        self.tableView.separatorColor = .clear
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 300
        self.tableView.backgroundView = spinner
    }
    
    private func loadComments() {
        let start = Date()
        Task {
            service?.memoizedLoadComments?("\(post?.id ?? 0)") { [weak self]  result in
                let seconds = Date().calculateTimeDifferenceInSeconds(from: start)
                print("Took \(String(format: "%.3f", seconds)) seconds")
                
                self?.tableView.backgroundView = nil
                self?.handleAPIResult(result)
            }
        }
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
}

extension PostDetailsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as? CommentTableViewCell ?? CommentTableViewCell(style: .default, reuseIdentifier: "CommentCell")
        let item = items[indexPath.row]
        cell.configure(item, service: nil)
        cell.setConstraints(tableViewWidth: tableView.bounds.width)
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        item.select()
    }
}
