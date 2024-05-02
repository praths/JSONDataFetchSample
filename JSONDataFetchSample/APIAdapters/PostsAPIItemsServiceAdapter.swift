//
//  PostsAPIItemsServiceAdapter.swift
//  JSONDataFetchSample
//
//  Created by Prathamesh Dabre on 02/05/24.
//

import Foundation

struct PostsAPIItemsServiceAdapter: ItemsService {
    let api: PostsAPI
    let select: (Post) -> Void
    
    func loadItems(page: Int, limit: Int, postId: String, completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        Task {
            await api.loadPosts(page: page, limit: limit) { result in
                DispatchQueue.mainAsyncIfNeeded {
                    completion(result.map{ items in
                        return items.map { item in
                            ItemViewModel(post: item) {
                                select(item)
                            }
                        }
                    })
                }
            }
        }
        
    }
}
