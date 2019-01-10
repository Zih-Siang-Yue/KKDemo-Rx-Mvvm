//
//  ArtistModel.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/22.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import Foundation
import RealmSwift

class ArtistModel: Object, Codable {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var url: String = ""
    var images = List<ImageModel>()

    override static func primaryKey() -> String? {
        return "id"
    }
}
