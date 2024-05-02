//
//  ItemViewModel.swift
//  JSONDataFetchSample
//
//  Created by Prathamesh Dabre on 27/04/24.
//

import Foundation

struct ItemViewModel {
    let id: Int
    let title: String
    let subtitle: String
    let select: () -> Void
}

extension ItemViewModel {
    init(post: Post, selection: @escaping () -> Void) {
        id = post.id
        title = post.title
        subtitle = post.body
        select = selection
    }
    
    init(comment: Comment) {
        id = comment.id
        title = comment.name
        subtitle = comment.email
        select = {}
    }
}
