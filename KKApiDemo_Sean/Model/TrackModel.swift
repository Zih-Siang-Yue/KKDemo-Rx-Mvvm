//
//  TrackModel.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/22.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import RxDataSources

class TrackModel: Object, Codable {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var duration: Float = 0.0
    @objc dynamic var album: AlbumModel!
    @objc dynamic var isFavorited: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case url
        case duration
        case album
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: CodingKeys.id)
        name = try container.decode(String.self, forKey: CodingKeys.name)
        url = try container.decode(String.self, forKey: CodingKeys.url)
        duration = try container.decode(Float.self, forKey: CodingKeys.duration)
        album = try container.decode(AlbumModel.self, forKey: CodingKeys.album)
        super.init()
    }

    required init() {
        super.init()
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
}

class Tracks: Object, Codable {
    var data = List<TrackModel>()
}

class TrackInfo: Object, Codable {
    @objc dynamic var tracks: Tracks!
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var url: String = ""

    enum CodingKeys: String, CodingKey {
        case tracks
        case id
        case title
        case desc = "description"
        case url
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}

struct TrackSection {
    var header: String
    var items: [Item]
}

extension TrackSection: SectionModelType {
    
    typealias Item = TrackModel
    
    init(original: TrackSection, items: [Item]) {
        self = original
        self.items = items
    }
}
