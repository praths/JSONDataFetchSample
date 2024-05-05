//
//  Post.swift
//  JSONDataFetchSample
//
//  Created by Prathamesh Dabre on 27/04/24.
//

import Foundation

struct Post: Codable {
    var id: Int
    var userId: Int
    var title: String
    var body: String
}
