//
//  ListModel.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/20.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import Foundation

struct ListModel<T: Codable>: Codable {
    let data: T?
    let paging: PagingModel
    let summary: SummaryModel
}
