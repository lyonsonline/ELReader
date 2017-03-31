//
//  Router.swift
//  ELReader
//
//  Created by Lyons Eric on 2017/3/23.
//  Copyright © 2017年 Lyons Eric. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    case loadAllList
    case loadMonthList
    case loadWeekList
    case loadDayList
    
    static let baseURLString = "http://m.ybdu.com/book"
    
    var method: HTTPMethod {
        switch self {
        case .loadAllList, .loadMonthList, .loadWeekList, .loadDayList:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .loadAllList:
            return "/allvisit/0/1/"
        case .loadMonthList:
            return "monthvisit/0/1/"
        case .loadWeekList:
            return "weekvisit/0/1/"
        case .loadDayList:
            return "dayvisit/0/1/"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        return urlRequest
    }
    
}
