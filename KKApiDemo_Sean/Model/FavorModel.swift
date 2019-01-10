//
//  FavorModel.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2019/1/8.
//  Copyright © 2019 Sean.Yue. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
import RxDataSources

class FavorModel: Object, Codable {
    
    @objc dynamic var id: String = ""
//    @objc dynamic var name: String = ""
//    @objc dynamic var artistName: String = ""
//    @objc dynamic var albumName: String = ""
//    @objc dynamic var albumImageUrl: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    init(id: String) {
        self.id = id
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

struct FavorSection {
    var header: String
    var items: [Item]
}

extension FavorSection: SectionModelType {
    
    typealias Item = FavorModel
    
    init(original: FavorSection, items: [Item]) {
        self = original
        self.items = items
    }
}
