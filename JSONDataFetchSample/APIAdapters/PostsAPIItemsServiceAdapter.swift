//
//  PostsAPIItemsServiceAdapter.swift
//  JSONDataFetchSample
//
//  Created by Prathamesh Dabre on 02/05/24.
//

import Foundation

struct PostsAPIItemsServiceAdapter: ItemsService {
    var page: Int
    let limit: Int
    let api: PostsAPI
    let select: (Post) -> Void
    
    var memoizedLoadComments: ((String, @escaping ((Result<[ItemViewModel], Error>) -> Void)) -> Void)?
    
    var memoizedLoadUser: ((String, @escaping ((Result<[ItemViewModel], Error>) -> Void)) -> Void)?
    
    func loadIntialPage(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        loadItems(page: page, limit: limit, completion: completion)
    }
    
    func shouldFetchNextPage(row: Int) -> Bool {
        return row > (page * limit) - 2
    }
    
    mutating func loadNextPage(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        page += 1
        loadItems(page: page, limit: limit, completion: completion)
    }
    
    private func loadItems(page: Int, limit: Int, completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
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
