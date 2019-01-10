//
//  NetworkAgent.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/17.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import Foundation
import RxSwift

public typealias Json = [String: Any]

enum NetworkError: String, Error {
    case DataIsNil = "Data return nil."
    case TokenIsNil = "Token is nil."
    case JsonParseError = "Json Parse Failure."
}

class NetworkAgent {
    static let shared = NetworkAgent()
    
    private init() {}
    
    func query<T: Codable>(request: URLRequest) -> Single<T> {
        return URLSession.shared.rx.data(request: request)
            .map({ (data) -> T in
                #if DEBUG
                if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? Json {
                    print("This json is for debug = \(json)")
                }
                #endif
                
                return try JSONDecoder().decode(T.self, from: data)
            })
            .asSingle()
    }
}
