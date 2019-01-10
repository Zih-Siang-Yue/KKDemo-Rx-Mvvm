//
//  KKAPI+Category.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/24.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import Foundation
import RxSwift

extension KKAPI {
    func getCategory() -> Observable<[CategoryModel]> {
        return try! getInfo(path: KKApiPath.Category(id: nil, isTracks: false).path).asObservable()
    }
    
    func getCategory(id: String) -> Observable<CategoryModel> {
        return try! getInfo(path: KKApiPath.Category(id: id, isTracks: false).path).asObservable()
    }
}
