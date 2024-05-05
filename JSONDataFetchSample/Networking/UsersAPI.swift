//
//  UsersAPI.swift
//  JSONDataFetchSample
//
//  Created by Prathamesh Dabre on 05/05/24.
//

import Foundation

class UsersAPI {
    static var shared = UsersAPI()
    
    func loadUser(userId: String, completion: @escaping (Result<[User], Error>) -> Void) async {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users/\(userId)")
        else {
            completion(.failure(InValidURL()))
            return
        }
        do
        {
            let (data, _) = try await URLSession.shared.data(from: url)
            let user = try JSONDecoder().decode(User.self, from: data)
            completion(.success([user]))
        }
        catch(let error)
        {
            completion(.failure(error))
        }
    }
}
