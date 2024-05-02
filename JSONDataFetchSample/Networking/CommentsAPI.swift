//
//  CommentsAPI.swift
//  JSONDataFetchSample
//
//  Created by Prathamesh Dabre on 02/05/24.
//

import Foundation

class CommentsAPI {
    static var shared = CommentsAPI()
    
    func loadComments(postId: String, completion: @escaping (Result<[Comment], Error>) -> Void) async {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(postId)/comments")
        else {
            completion(.failure(InValidURL()))
            return
        }
        do
        {
            let (data, _) = try await URLSession.shared.data(from: url)
            let comments = try JSONDecoder().decode([Comment].self, from: data)
            completion(.success(comments))
        }
        catch(let error)
        {
            completion(.failure(error))
        }
    }
}
