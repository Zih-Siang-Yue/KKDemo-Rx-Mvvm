//
//  LogoutViewModel.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2019/1/9.
//  Copyright © 2019 Sean.Yue. All rights reserved.
//

import UIKit
import Action
import RxCocoa
import RxSwift

class LogoutViewModel: NSObject, ViewModelType {

    typealias Input = LogoutInput
    typealias Output = LogoutOutput
    
    struct LogoutInput {}
    
    struct LogoutOutput {
        var btnAction = CocoaAction { (_) -> Observable<Void> in
            UserDefaults.standard.set(nil, forKey: "accessToken")
            return Observable.just(Void())
        }
    }
    
    public func transform() -> Output {
        return Output()
    }
    
}
