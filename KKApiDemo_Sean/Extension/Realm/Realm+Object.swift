//
//  Realm+Object.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2019/1/4.
//  Copyright © 2019 Sean.Yue. All rights reserved.
//

import Foundation
import RealmSwift

protocol UnmanagedCopy {
    func unmanagedCopy() -> Self
}

extension Object:UnmanagedCopy{
    func unmanagedCopy() -> Self {
        let o = type(of:self).init()
        for p in objectSchema.properties {
            let value = self.value(forKey: p.name)
            switch p.type {
            case .linkingObjects:
                break
            default:
                o.setValue(value, forKey: p.name)
            }
        }
        
        return o
    }
}
