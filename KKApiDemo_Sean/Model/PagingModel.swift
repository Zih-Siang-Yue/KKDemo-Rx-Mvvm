//
//  PagingModel.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/24.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import Foundation

struct PagingModel: Codable {
    let offset: Int
    let limit: Int
    let previous: String
    let next: String
}
