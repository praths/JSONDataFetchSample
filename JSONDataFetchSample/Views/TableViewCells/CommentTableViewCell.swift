//
//  CommentTableViewCell.swift
//  JSONDataFetchSample
//
//  Created by Prathamesh Dabre on 05/05/24.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

extension CommentTableViewCell: CellConfigurator {
    func configure(_ item: ItemViewModel, service: (any ItemsService)?) {
        lblId.text = "ID: \(item.id)"
        lblTitle.text = item.title
        lblEmail.text = "by \(item.subtitle)"
        lblContent.text = item.content
    }
    
    func setConstraints(tableViewWidth: CGFloat) {
        lblId.preferredMaxLayoutWidth = tableViewWidth
        lblTitle.preferredMaxLayoutWidth = tableViewWidth
        lblEmail.preferredMaxLayoutWidth = tableViewWidth
        lblContent.preferredMaxLayoutWidth = tableViewWidth
    }
}
