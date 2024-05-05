//
//  PostTableViewCell.swift
//  JSONDataFetchSample
//
//  Created by Prathamesh Dabre on 05/05/24.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    
    var service: ItemsService?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private func loadUser(service: (any ItemsService)?, id: Int) {
        let start = Date()
        Task {
            service?.memoizedLoadUser?("\(id)") { [weak self]  result in
                let seconds = Date().calculateTimeDifferenceInSeconds(from: start)
                print("Took \(String(format: "%.3f", seconds)) seconds")
                
                self?.handleAPIResult(result)
            }
        }
    }
    
    private func handleAPIResult(_ result: Result<[ItemViewModel], Error>) {
        switch result {
        case let .success(items):
            if let user = items.first {
                lblUsername.text = "by \(user.title)"
            }
            else {
                lblUsername.text = "by N/A"
            }
        case .failure(_):
            lblUsername.text = "by N/A"
        }
    }
}

extension PostTableViewCell: CellConfigurator {
    func configure(_ item: ItemViewModel, service: (any ItemsService)?) {
        lblId.text = "ID: \(item.id)"
        lblTitle.text = item.title
        lblContent.text = item.subtitle
        loadUser(service: service, id: item.parentId)
    }
    
    func setConstraints(tableViewWidth: CGFloat) {
        lblId.preferredMaxLayoutWidth = tableViewWidth
        lblTitle.preferredMaxLayoutWidth = tableViewWidth
        lblContent.preferredMaxLayoutWidth = tableViewWidth
        lblUsername.preferredMaxLayoutWidth = tableViewWidth
    }
}
