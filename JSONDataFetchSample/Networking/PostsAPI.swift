//
//  PostsAPI.swift
//  JSONDataFetchSample
//
//  Created by Prathamesh Dabre on 02/05/24.
//

import Foundation

struct InValidURL: Error {}

class PostsAPI {
    static var shared = PostsAPI()
    
    func loadPosts(page: Int, limit: Int, completion: @escaping (Result<[Post], Error>) -> Void) async {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts?_page=\(page)&_limit=\(limit)")
        else {
            completion(.failure(InValidURL()))
            return
        }
        do
        {
            let (data, _) = try await URLSession.shared.data(from: url)
            let posts = try JSONDecoder().decode([Post].self, from: data)
            completion(.success(posts))
        }
        catch(let error)
        {
            completion(.failure(error))
        }
    }
}
