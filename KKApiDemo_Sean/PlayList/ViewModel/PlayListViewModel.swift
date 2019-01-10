//
//  PlayListViewModel.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/24.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class PlayListViewModel: NSObject, ViewModelType {
    
    typealias Input = PlaylistInput
    typealias Output = PlaylistOutput
    
    struct PlaylistInput {}
    
    struct PlaylistOutput {
        let section: Driver<[PlaylistSection]>
        let isFetching: Driver<Bool>
    }
    
    private let sectionRelay: BehaviorRelay<[PlaylistSection]> = BehaviorRelay(value: [])
    private let isFetchingSubject = PublishSubject<Bool>()
    
    public let input: Input
    public let output: Output
    
    override init() {
        self.input = Input()
        self.output = Output(section: sectionRelay.asDriver(), isFetching: isFetchingSubject.asDriver(onErrorJustReturn: false))
        super.init()
    }
    
    func fetchInfo() {
        self.isFetchingSubject.onNext(true)
        
        KKAPI.shared.getPlaylist()
            .observeOn(MainScheduler.instance)
            .catchError({ (playlists) -> Observable<[PlaylistModel]> in
                return Observable.just(RealmManager.shared.fetchAry(type: PlaylistModel.self))
            })
            .map({ (playlists) -> [PlaylistSection] in
                RealmManager.shared.add(ob: playlists)
                return [PlaylistSection(header: "Playlists", items: playlists)]
            })
            .subscribe(onNext: { [weak self] (playSection) in
                guard let self = self else { return }
                self.sectionRelay.accept(playSection)
                self.isFetchingSubject.onNext(false)
            })
            .disposed(by: rx.disposeBag)
    }
    
}
