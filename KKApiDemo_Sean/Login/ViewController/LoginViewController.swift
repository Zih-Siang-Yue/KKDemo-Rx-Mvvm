//
//  LoginViewController.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2019/1/2.
//  Copyright © 2019 Sean.Yue. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: BaseViewController {

    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var acLabel: UILabel!
    @IBOutlet weak var acTextField: UITextField!
    @IBOutlet weak var acReminderLabel: UILabel!
    @IBOutlet weak var pwLabel: UILabel!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pwReminderLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var indicatorBgView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    private var vm: LoginViewModel

    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        binding()
    }

    //MARK: init
    init(vm: LoginViewModel) {
        self.vm = vm
        super.init(nibName: "LoginViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configUI() {
        self.indicatorView.hidesWhenStopped = true
        self.indicatorBgView.layer.cornerRadius = 5.0
        self.pwTextField.isSecureTextEntry = true
        self.loginBtn.layer.cornerRadius = 5.0
    }
    
    func binding() {
        let acOb = acTextField.rx.text.orEmpty.asDriver()
        let pwOb = pwTextField.rx.text.orEmpty.asDriver()
        let acAndPwOb = Driver.combineLatest(acOb, pwOb)

        let input = LoginViewModel.Input(acStr: acOb, pwStr: pwOb)
        let output = vm.transform(input: input)
        
        //Reminder label binding
        output.acValid
            .drive(acReminderLabel.rx.validationResult)
            .disposed(by: rx.disposeBag)
        
        output.pwValid
            .drive(pwReminderLabel.rx.validationResult)
            .disposed(by: rx.disposeBag)
        
        
        //Btn binding
        output.btnValid.drive(onNext: { [weak self] (valid) in
            guard let self = self else { return }
            let color = valid ? UIColor.yellow : UIColor.lightGray
            self.loginBtn.setTitleColor(color, for: .normal)
            self.loginBtn.isEnabled = valid
        })
            .disposed(by: rx.disposeBag)

        self.loginBtn.rx.tap.asObservable()
            .withLatestFrom(acAndPwOb)
            .bind(to: output.btnAction.inputs)
            .disposed(by: rx.disposeBag)
        
        output.btnAction.executing
            .subscribe(onNext: { [weak self] (isExecuting) in
                guard let self = self else { return }
                self.indicatorBgView.isHidden = !isExecuting
                if isExecuting {
                    self.indicatorView.startAnimating()
                }
                else {
                    self.indicatorView.stopAnimating()
                }
            })
            .disposed(by: rx.disposeBag)
        
        output.btnAction.elements
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (isSuccessful) in
                guard let self = self else { return }
                if isSuccessful {
                    Router.shared.goTo()
                }
                else {
                    self.showAlert(title: "Wrong! Accout / Password", msg: "Please, try again.")
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    func showAlert(title: String, msg: String?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}

