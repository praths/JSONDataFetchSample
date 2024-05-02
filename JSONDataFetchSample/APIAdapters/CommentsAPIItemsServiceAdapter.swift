//
//  CommentsAPIItemsServiceAdapter.swift
//  JSONDataFetchSample
//
//  Created by Prathamesh Dabre on 02/05/24.
//

import Foundation

struct CommentsAPIItemsServiceAdapter {
    let api: CommentsAPI
    
    func loadItems(postId: String, completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        Task {
            await api.loadComments(postId: "\(postId)") { result in
                DispatchQueue.mainAsyncIfNeeded {
                    completion(result.map{ items in
                        return items.map { item in
                            ItemViewModel(comment : item)
                        }
                    })
                }
            }
        }
    }
}
