//
//  AuthModel.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/20.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import Foundation

struct AuthModel: Codable {
    let access_token: String
    let expires_in: Int
    let token_type: String
}

