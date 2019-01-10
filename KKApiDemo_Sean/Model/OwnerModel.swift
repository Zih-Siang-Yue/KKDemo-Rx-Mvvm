//
//  OwnerModel.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/24.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import Foundation
import RealmSwift

class OwnerModel: Object, Codable {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var desc: String = ""
    var images = List<ImageModel>()

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case url
        case desc = "description"
        case images
    }
    
//    override static func primaryKey() -> String? {
//        return "id"
//    }
}
