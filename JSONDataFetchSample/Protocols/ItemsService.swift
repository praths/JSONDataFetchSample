//
//  ItemsService.swift
//  JSONDataFetchSample
//
//  Created by Prathamesh Dabre on 03/05/24.
//

import Foundation

protocol ItemsService {
    var memoizedLoadComments: ((String, @escaping ((Result<[ItemViewModel], Error>) -> Void)) -> Void)? { get set }
    
    func loadIntialPage(completion: @escaping (Result<[ItemViewModel], Error>) -> Void)
    func shouldFetchNextPage(row: Int) -> Bool
    mutating func loadNextPage(completion: @escaping (Result<[ItemViewModel], Error>) -> Void)
}
