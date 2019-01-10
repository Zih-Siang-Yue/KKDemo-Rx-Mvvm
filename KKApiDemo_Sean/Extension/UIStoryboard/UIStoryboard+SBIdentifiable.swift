//
//  UIStoryboard+SBIdentifiable.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/24.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    func instantiateVC<T: BaseViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.sbIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.sbIdentifier) ")
        }
        return viewController
    }
    
}
