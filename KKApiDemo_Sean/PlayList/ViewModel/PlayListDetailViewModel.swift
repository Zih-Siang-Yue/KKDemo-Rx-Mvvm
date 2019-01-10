//
//  PlayListDetailViewModel.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/25.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PlayListDetailViewModel: NSObject, ViewModelType {
    
    typealias Input = PlaylistDetailInput
    typealias Output = PlaylistDetailOutput
    
    struct PlaylistDetailInput {
        let id: String
    }
    
    struct PlaylistDetailOutput {
        let section: Driver<[TrackSection]>
        let isFetching: Driver<Bool>
    }
    
    private let sectionRelay: BehaviorRelay<[TrackSection]> = BehaviorRelay(value: [])
    private let isFetchingSubject = PublishSubject<Bool>()
    
    public let input: Input
    public let output: Output
    
    
    //MARK: init
    init(input: Input) {
        self.input = input
        self.output = Output(section: sectionRelay.asDriver(), isFetching: isFetchingSubject.asDriver(onErrorJustReturn: false))
        super.init()
    }
    
    func fetchInfo() {
        self.isFetchingSubject.onNext(true)

        KKAPI.shared.getPlaylist(id: input.id)
            .observeOn(MainScheduler.instance)
            .catchError({ [unowned self] (error) -> Observable<TrackInfo> in
                guard let result = RealmManager.shared.fetch(type: TrackInfo.self, primaryKey: self.input.id) else {
                    return Observable.empty()
                }
                return Observable.just(result)
            })
            .map({ (trackInfo) -> [TrackSection] in
                RealmManager.shared.add(ob: trackInfo)
                return [TrackSection(header: "Tracks", items: Array(trackInfo.tracks.data))]
            })
            .subscribe(onNext: { [weak self] (trackSection) in
                guard let self = self else { return }
                self.sectionRelay.accept(trackSection)
                self.isFetchingSubject.onNext(false)
            })
            .disposed(by: rx.disposeBag)
    }
}
