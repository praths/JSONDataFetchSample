//
//  Comment.swift
//  JSONDataFetchSample
//
//  Created by Prathamesh Dabre on 27/04/24.
//

import Foundation
import Combine

struct Comment: Codable {
    var id: Int
    var name: String
    var email: String
    var body: String
}

func memoize<Input: Hashable, Output>(_ function: @escaping (Input, @escaping ((Result<[Output], Error>) -> Void)) -> Void) -> (Input, @escaping ((Result<[Output], Error>) -> Void)) -> Void
{
    
    var cachedComments: [Input : [Output]?] = [ : ]
    
    return { (postId: Input, callback: @escaping ((Result<[Output], Error>) -> Void)) in
        if let comments = cachedComments[postId] as? [Output] {
            callback(.success(comments))
            return
        }
        
        function(postId) { result in
            switch result {
            case .success(let comments):
                cachedComments[postId] = comments
                callback(.success(comments))
            case .failure(let error):
                callback(.failure(error))
            }
            
            
            
        }
    }
}

struct CommentsAPIItemsServiceAdapter: ItemsService {
    let api: CommentsAPI
    let postId: Int
    
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) async {
        
        let memoizedLoadComments = memoize(api.loadComments)
        
        memoizedLoadComments("\(postId)") { result in
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

class CommentsAPI {
    static var shared = CommentsAPI()
    
    func loadComments(postId: String, completion: @escaping (Result<[Comment], Error>) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(postId)/comments")
        else {
            completion(.failure(InValidURL()))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            do {
                let comments = try JSONDecoder().decode([Comment].self, from: data)
                completion(.success(comments))
            }
            catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
