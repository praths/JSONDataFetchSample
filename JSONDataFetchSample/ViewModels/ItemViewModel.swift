//
//  ItemViewModel.swift
//  JSONDataFetchSample
//
//  Created by Prathamesh Dabre on 27/04/24.
//

import Foundation

struct ItemViewModel {
    let id: Int
    let parentId: Int
    let title: String
    let subtitle: String
    let content: String
    let select: () -> Void
}

extension ItemViewModel {
    init(post: Post, selection: @escaping () -> Void) {
        id = post.id
        parentId = post.userId
        title = post.title
        subtitle = post.body
        content = ""
        select = selection
    }
    
    init(comment: Comment) {
        id = comment.id
        parentId = comment.postId
        title = comment.name
        subtitle = comment.email
        content = comment.body
        select = {}
    }
    
    init(user: User) {
        id = user.id
        parentId = 0
        title = user.name
        subtitle = user.username
        content = user.email
        select = {}
    }
}
