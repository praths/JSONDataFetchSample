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
