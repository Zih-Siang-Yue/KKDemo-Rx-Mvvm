//
//  TrackViewController.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/28.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TrackViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favorBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var albumContentLabel: UILabel!
    @IBOutlet weak var artistContentLabel: UILabel!
    
    private let vm: TrackViewModel
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configFavorBtn()
        self.binding()
    }
    
    //MARK: init
    init(vm: TrackViewModel) {
        self.vm = vm
        super.init(nibName: "TrackViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configFavorBtn() {
        self.favorBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.vm.modifyFavorState()
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func binding() {
        self.vm.output.titleStr
            .drive(self.titleLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        self.vm.output.albumStr
            .drive(self.albumContentLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        self.vm.output.artistStr
            .drive(self.artistContentLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        self.vm.output.albumImage
            .drive(self.imageView.rx.image)
            .disposed(by: rx.disposeBag)
        
        self.vm.output.isFavor
            .drive(onNext: { (isFavor) in
                let image = isFavor ? UIImage(named: "Like_H") : UIImage(named: "Like_N")
                self.favorBtn.setImage(image, for: .normal)
            })
            .disposed(by: rx.disposeBag)
    }
    
}
