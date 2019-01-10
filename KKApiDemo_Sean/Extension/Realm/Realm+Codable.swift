//
//  Realm+Codable.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/26.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import Foundation
import RealmSwift

extension List: Codable where Element: Codable {
    public convenience init(from decoder: Decoder) throws {
        self.init()
        var container = try decoder.unkeyedContainer()
        while !container.isAtEnd {
            let element = try container.decode(Element.self)
            self.append(element)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for element in self {
            try element.encode(to: container.superEncoder())
        }
    }
}
