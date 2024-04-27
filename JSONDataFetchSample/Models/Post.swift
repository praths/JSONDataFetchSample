//
//  Post.swift
//  JSONDataFetchSample
//
//  Created by Prathamesh Dabre on 27/04/24.
//

import Foundation

struct Post: Codable {
    var id: Int
    var title: String
}

struct PostsAPIItemsServiceAdapter: ItemsService {
    let api: PostsAPI
    let select: (Post) -> Void
    
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) async {
        await api.loadPosts { result in
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

struct InValidURL: Error {}

class PostsAPI {
    static var shared = PostsAPI()
    
    /// For demo purposes, this method simulates an API request with a pre-defined response and delay.
    func loadPosts(completion: @escaping (Result<[Post], Error>) -> Void) async {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
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

//class PostsCache {
//    private var posts: [Post]?
//    
//    private struct NoPostsFound: Error {}
//    
//    /// For demo purposes, this method simulates an database lookup with a pre-defined in-memory response and delay.
//    func loadPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
//        DispatchQueue.global().asyncAfter(deadline: .now() + 0.25) {
//            if let posts = self.posts {
//                completion(.success(posts))
//            } else {
//                completion(.failure(NoPostsFound()))
//            }
//        }
//    }
//    
//    /// For demo purposes, this method simulates a cache with an in-memory reference to the provided friends.
//    func save(_ newPosts: [Post]) {
//        posts = newPosts
//    }
//}

