//
//  AlbumModel.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/22.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import Foundation
import RealmSwift

class AlbumModel: Object, Codable {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var exp: Bool = false
    @objc dynamic var rDate: String?
    @objc dynamic var artist: ArtistModel!
    var availTy = List<String>()
    var images = List<ImageModel>()

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case url
        case exp = "explicitness"
        case availTy = "available_territories"
        case rDate = "release_date"
        case artist
        case images
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
