//
//  PlaylistModel.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/21.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import Foundation
import RxDataSources
import RealmSwift
import Realm

class PlaylistModel: Object, Codable {
    @objc dynamic var id: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var updatedTime: String = ""
    @objc dynamic var owner: OwnerModel!
    var images = List<ImageModel>()

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case name = "title"
        case desc = "description"
        case updatedTime = "updated_at"
        case owner
        case images
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Playlists: Object, Codable {
    var data = List<PlaylistModel>()
}

struct PlaylistSection {
    var header: String
    var items: [Item]
}

extension PlaylistSection: SectionModelType {
    
    typealias Item = PlaylistModel
    
    init(original: PlaylistSection, items: [Item]) {
        self = original
        self.items = items
    }
}
