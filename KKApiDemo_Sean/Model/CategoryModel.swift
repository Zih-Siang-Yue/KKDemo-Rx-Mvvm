//
//  CategoryModel.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/21.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryModel: Object, Codable {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    var images = List<ImageModel>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
