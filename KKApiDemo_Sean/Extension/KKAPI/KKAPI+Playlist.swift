//
//  KKAPI+Playlist.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/24.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension KKAPI {
    func getPlaylist() -> Observable<[PlaylistModel]> {
        do {
            return try getInfo(path: KKApiPath.PlayList(id: nil, isTracks: false).path)
                .map({ (playlists: Playlists) -> [PlaylistModel] in
                    return Array(playlists.data)
                })
                .asObservable()
        }
        catch let error {
            print("get playlist failure: \(error.localizedDescription)")
            return .error(error)
        }
    }
    
    func getPlaylist(id: String) -> Observable<TrackInfo> {
        do {
            return try getInfo(path: KKApiPath.PlayList(id: id, isTracks: false).path).asObservable()
        }
        catch let error {
            print("get playlist by id failure: \(error.localizedDescription)")
            return .error(error) 
        }
    }
}
