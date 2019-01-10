//
//  ImageModel.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/24.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import Foundation
import RealmSwift

class ImageModel: Object, Codable {
    @objc dynamic var height: Int = 0
    @objc dynamic var width: Int = 0
    @objc dynamic var url: String = ""
    
    override static func primaryKey() -> String? {
        return "url"
    }
}
