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
    let select: () -> Void
}

extension ItemViewModel {
    init(post: Post, selection: @escaping () -> Void) {
        id = post.id
        title = post.title
        select = selection
    }
    
    init(comment: Comment) {
        id = comment.id
        title = comment.name
        select = {}
    }
}
