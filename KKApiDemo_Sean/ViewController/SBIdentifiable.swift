//
//  SBIdentifiable.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/24.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import Foundation
import UIKit

protocol SBIdentifiable {
    static var sbIdentifier: String { get }
}

extension SBIdentifiable where Self: BaseViewController {
    static var sbIdentifier: String {
        return String(describing: self)
    }
}
