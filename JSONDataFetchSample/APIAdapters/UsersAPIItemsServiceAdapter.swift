//
//  UsersAPIItemsServiceAdapter.swift
//  JSONDataFetchSample
//
//  Created by Prathamesh Dabre on 05/05/24.
//

import Foundation

struct UsersAPIItemsServiceAdapter {
    let api: UsersAPI
    
    func loadUser(userId: String, completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        Task {
            await api.loadUser(userId: "\(userId)") { result in
                DispatchQueue.mainAsyncIfNeeded {
                    completion(result.map{ items in
                        return items.map { item in
                            ItemViewModel(user: item)
                        }
                    })
                }
            }
        }
    }
}
