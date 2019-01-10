//
//  FavoriteViewModel.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2019/1/3.
//  Copyright © 2019 Sean.Yue. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FavoriteViewModel: NSObject, ViewModelType {
    
    typealias Input = FavorInput
    typealias Output = FavorOutput
    
    struct FavorInput {}
    
    struct FavorOutput {
        let section: Driver<[TrackSection]>
        let isFetching: Driver<Bool>
    }
    
    private let sectionRelay: BehaviorRelay<[TrackSection]> = BehaviorRelay(value: [])
    private let isFetchingSubject = PublishSubject<Bool>()
    
    public let input: Input
    public let output: Output

    override init() {
        self.input = Input()
        self.output = Output(section: sectionRelay.asDriver(), isFetching: isFetchingSubject.asDriver(onErrorJustReturn: false))
        super.init()
        self.fetchInfo()
    }
 
    func fetchInfo() {
        let favorList = RealmManager.shared.fetchAry(type: FavorModel.self)
        var tracks = [TrackModel]()
        favorList.forEach { (model) in
            tracks.append(RealmManager.shared.fetch(type: TrackModel.self, primaryKey: model.id)!)
        }
        let trackSection = [TrackSection(header: "Favor", items: tracks)]
        self.sectionRelay.accept(trackSection)
    }
    
}
