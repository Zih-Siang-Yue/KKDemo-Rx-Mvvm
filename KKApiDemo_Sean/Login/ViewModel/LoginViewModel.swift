//
//  LoginViewModel.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2019/1/2.
//  Copyright © 2019 Sean.Yue. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Action

class LoginViewModel: NSObject, ViewModelType {
    
    typealias Input = LoginInput
    typealias Output = LoginOutput
    
    struct LoginInput {
        var acStr: Driver<String>
        var pwStr: Driver<String>
    }

    struct LoginOutput {
        var acValid: Driver<ValidationResult>
        var pwValid: Driver<ValidationResult>
        var btnValid: Driver<Bool>
        var btnAction: Action<(String, String), Bool>
        
        init(ac: Driver<String>, pw: Driver<String>) {
            acValid = ac
                .flatMapLatest({ (acStr) -> Driver<ValidationResult> in
                    return LoginService().validateAc(ac: acStr)
                    .asDriver(onErrorJustReturn: .failed(message: "服務器發生錯誤！"))
                })
            
            pwValid = pw
                .flatMapLatest({ (pwStr) -> Driver<ValidationResult> in
                    return LoginService().validatePw(pw: pwStr)
                        .asDriver(onErrorJustReturn: .failed(message: "服務器發生錯誤！"))
                })
            
            btnValid = Driver.combineLatest(acValid, pwValid)
                .flatMapLatest {
                    return Driver.just($0.isValid && $1.isValid)
                }
                .distinctUntilChanged()
            
            btnAction = Action(workFactory: { (input) -> Observable<Bool> in
                let (ac, pw) = input
                if (ac == "1234" || ac == "abcd") && (pw == "1234" || pw == "abcd") {
                    return KKAPI.shared.getToken()
                }
                else {
                    return Observable.just(false)
                }
            })
        }
    }
    
    func transform(input: Input) -> Output {
        return Output(ac: input.acStr, pw: input.pwStr)
    }
    
}
