//
//  KKAPI.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/19.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import Foundation
import RxSwift

enum KKApiDomain: String {
    case AuthDomain = "https://account.kkbox.com"
    case ApiDomain = "https://api.kkbox.com"
}

enum KKApiPath {
    case Auth
    case PlayList(id: String?, isTracks: Bool)
    case Category(id: String?, isTracks: Bool)
    
    var path: String {
        switch self {
        case .Auth:
            return "/oauth2/token"
        case .PlayList(let id, let isTracks):
            var url = "/v1.1/featured-playlists"
            assemble(url: &url, id: id, isTracks: isTracks)
            return url
        case .Category(let id, let isTracks):
            var url = "/v1.1/featured-playlist-categories"
            assemble(url: &url, id: id, isTracks: isTracks)
            return url
        }
    }
    
    private func assemble(url: inout String, id: String?, isTracks: Bool) {
        if let id = id {
            url += "/\(id.urlEscaped)"
        }
        if isTracks { url += "/tracks" }
    }
}

class KKAPI {
    public static let shared = KKAPI()
    private let appID = "aaa496e0ea4f2bfb2beb899384f048f6"
    private let appSecret = "6a383b62e769cce6fdca9f736fde87cd"

    private init() {}

    func getToken() -> Observable<Bool> {
        return Observable.create({ (ob) -> Disposable in
            let auth: String = "\(self.appID):\(self.appSecret)".data(using: .utf8)!.base64EncodedString()
            let header: HTTPHeaders = [
                "Authorization": "Basic \(auth)",
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            
            let request: URLRequest = EndPointBuilder(domain: KKApiDomain.AuthDomain.rawValue)
                .path(KKApiPath.Auth.path)
                .method(.Post)
                .param("grant_type=client_credentials")
                .headers(header)
                .build()
            
            return NetworkAgent.shared
                .query(request: request)
                .subscribe(onSuccess: { (authModel: AuthModel) in
                    print("accessToken: \(authModel.access_token)")
                    self.save(token: authModel.access_token)
                    ob.onNext(true)
                }, onError: { (error) in
                    print("get token failure: \(error)")
                    ob.onError(error)
                })
        })
    }
    
    func getInfo<T: Codable>(path: String) throws -> Single<T> {
        guard let token = UserDefaults.standard.object(forKey: "accessToken") else {
            throw NetworkError.TokenIsNil
        }
        
        let header: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        let request: URLRequest = EndPointBuilder(domain: KKApiDomain.ApiDomain.rawValue)
                                    .path(path)
                                    .method(.Get)
                                    .param("?territory=TW&offset=0&limit=500")
                                    .headers(header)
                                    .build()

        return NetworkAgent.shared.query(request: request)
    }
    
    private func save(token: String) {
        let userDf = UserDefaults.standard
        userDf.set(token, forKey: "accessToken")
        userDf.synchronize()
    }
}


