//
//  RxSwift+UILabel.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2019/1/9.
//  Copyright © 2019 Sean.Yue. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UILabel {
    var validationResult: Binder<ValidationResult> {
        return Binder(base) { label, result in
            label.textColor = result.textColor
            label.text = result.description
        }
    }
}
