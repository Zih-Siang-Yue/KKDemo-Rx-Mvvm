//
//  EndPointBuilder.swift
//  KKApiDemo_Sean
//
//  Created by Sean.Yue on 2018/12/20.
//  Copyright © 2018 Sean.Yue. All rights reserved.
//

import Foundation

class EndPointBuilder {
    var endPoint: EndPoint
    
    init(domain: String) {
        self.endPoint = EndPoint(domain: domain)
    }
    
    func path(_ path: String) -> EndPointBuilder {
        self.endPoint.path = path
        return self
    }
    
    func param(_ param: String) -> EndPointBuilder {
        self.endPoint.param = param
        return self
    }
    
    func method(_ method: HTTPMethod) -> EndPointBuilder {
        self.endPoint.method = method
        return self
    }
    
    func headers(_ headers: HTTPHeaders) -> EndPointBuilder {
        self.endPoint.headers = headers
        return self
    }
    
    func build() -> URLRequest {
        var request = URLRequest(url: URL(string: self.endPoint.url)!)
        request.httpMethod = self.endPoint.method.rawValue
        request.allHTTPHeaderFields = self.endPoint.headers
        if self.endPoint.method == .Post {
            request.httpBody = self.endPoint.param?.data(using: .utf8)
        }
        return request
    }
    
}

