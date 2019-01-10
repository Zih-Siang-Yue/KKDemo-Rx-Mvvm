//
//  EndPoint.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/20.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]

protocol EndPointType {
    var domain: String { get }
    var path: String? { get }
    var param: String? { get }
    var url: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
}

public enum HTTPMethod: String {
    case Get = "GET"
    case Post = "POST"
    case Head = "HEAD"
    case Put = "PUT"
    case Delete = "DELETE"
    case Patch = "PATCH"
}

class EndPoint: EndPointType {
    var domain: String
    var path: String?
    var param: String?
    var url: String {
        get {
            if let path = path, let param = param, method == .Get {
                return domain + path + param
            }
            else if let path = path {
                return domain + path
            }
            return domain
        }
    }
    var method: HTTPMethod = .Get
    var headers: HTTPHeaders?
    
    init(domain: String) {
        self.domain = domain
    }
}
