//
//  LoginService.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2019/1/9.
//  Copyright © 2019 Sean.Yue. All rights reserved.
//

import UIKit
import RxSwift

class LoginService {
    let validRange = 4...12
    lazy var service = {
        return LoginService()
    }
    
    func validateAc(ac: String) -> Observable<ValidationResult> {
        if ac.isEmpty {
            return .just(.empty)
        }
        else if !validRange.contains(ac.count) {
            return .just(.failed(message: "帳號長度須符合4~12個字"))
        }
        
        if ac.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return .just(.failed(message: "只能輸入數英文與數字"))
        }
        
        return .just(.ok(message: "帳號有效"))
    }
    
    func validatePw(pw: String) -> Observable<ValidationResult> {
        if pw.isEmpty {
            return .just(.empty)
        }
        else if !validRange.contains(pw.count) {
            return .just(.failed(message: "密碼長度須符合4~12個字"))
        }
        
        if pw.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return .just(.failed(message: "只能輸入數英文與數字"))
        }
        
        return .just(.ok(message: "密碼有效"))
    }
}
