//
//  BaseViewController.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/17.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RealmSwift
import SDWebImage
import NSObject_Rx

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

}

extension BaseViewController: SBIdentifiable {
    @objc func logout() {
        let vc = LoginViewController(vm: LoginViewModel())
        AppDelegate.shareDelegate().window?.rootViewController = vc
    }
}
