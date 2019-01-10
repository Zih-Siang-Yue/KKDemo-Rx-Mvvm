//
//  LogoutViewController.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2019/1/9.
//  Copyright © 2019 Sean.Yue. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LogoutViewController: BaseViewController {

    @IBOutlet weak var logoutBtn: UIButton!
    
    private var vm: LogoutViewModel

    //MARK: init
    init(vm: LogoutViewModel) {
        self.vm = vm
        super.init(nibName: "LogoutViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        self.binding()
    }
    
    private func configUI() {
        logoutBtn.layer.cornerRadius = 5.0
    }
    
    private func binding() {
        let output = vm.transform()
        
        self.logoutBtn.rx.tap.asObservable()
            .bind(to: output.btnAction.inputs)
            .disposed(by: rx.disposeBag)
        
        output.btnAction.elements
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (_) in
                Router.shared.goTo()
            })
            .disposed(by: rx.disposeBag)
    }
    
}
