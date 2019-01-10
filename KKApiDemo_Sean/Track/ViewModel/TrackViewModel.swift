//
//  TrackViewModel.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/28.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Action
import RealmSwift

class TrackViewModel: NSObject, ViewModelType {
    
    typealias Input = TrackInput
    typealias Output = TrackOutput
    
    struct TrackInput {
        let model: TrackModel
    }
    
    struct TrackOutput {
        let titleStr: Driver<String>
        let albumStr: Driver<String>
        let artistStr: Driver<String>
        var albumImage: Driver<UIImage>
        var isFavor: Driver<Bool>
        //TODO:
//        var favorBtnAction: CocoaAction
    }
    
    //MARK: private
    private let titleRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
    private let albumRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
    private let artistRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
    private let albumImageRelay: BehaviorRelay<UIImage> = BehaviorRelay(value: UIImage())
    private let isFavorRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    //MARK: public
    public let input: Input
    public let output: Output
    
    //MARK: init
    init(input: Input) {
        self.input = input
        self.output = Output(titleStr: titleRelay.asDriver(),
                             albumStr: albumRelay.asDriver(),
                             artistStr: artistRelay.asDriver(),
                             albumImage: albumImageRelay.asDriver(),
                             isFavor: isFavorRelay.asDriver())
        super.init()
        self.transform()
    }
    
    func transform() {
        guard let url = self.input.model.album.images.first?.url,
            let data = try? Data(contentsOf: URL(string: url)!),
            let image = UIImage(data: data)
            else { return }
        
        self.titleRelay.accept(self.input.model.name)
        self.albumRelay.accept(self.input.model.album.name)
        self.artistRelay.accept(self.input.model.album.artist.name)
        self.albumImageRelay.accept(image)
        self.updateFavorState()
    }
    
    //TODO: Optimization
    private func updateFavorState() {
        guard let _ = RealmManager.shared.fetch(type: FavorModel.self, primaryKey: self.input.model.id) else {
            self.isFavorRelay.accept(false)
            return
        }
        self.isFavorRelay.accept(true)
    }
    
    public func modifyFavorState() {
        guard let _ = RealmManager.shared.fetch(type: FavorModel.self, primaryKey: self.input.model.id) else {
            let fModel = FavorModel(id: self.input.model.id)
            RealmManager.shared.add(ob: fModel)
            updateFavorState()
            return
        }
        
        RealmManager.shared.delete(type: FavorModel.self, primaryKey: self.input.model.id)
        updateFavorState()
    }

}
