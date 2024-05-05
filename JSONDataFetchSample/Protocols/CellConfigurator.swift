//
//  CellConfigurator.swift
//  JSONDataFetchSample
//
//  Created by Prathamesh Dabre on 05/05/24.
//

import Foundation

protocol CellConfigurator {
    func configure(_ item: ItemViewModel, service: ItemsService?)
    func setConstraints(tableViewWidth: CGFloat)
}
