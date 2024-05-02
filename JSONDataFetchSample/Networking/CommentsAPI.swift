//
//  CommentsAPI.swift
//  JSONDataFetchSample
//
//  Created by Prathamesh Dabre on 02/05/24.
//

import Foundation

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
