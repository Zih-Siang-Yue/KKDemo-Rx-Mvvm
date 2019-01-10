//
//  String+Encoding.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/24.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import Foundation

extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}
