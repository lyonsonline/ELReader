//
//  HTMLResponseSerializer.swift
//  ELReader
//
//  Created by Lyons Eric on 2017/3/22.
//  Copyright © 2017年 Lyons Eric. All rights reserved.
//

import Foundation
import Fuzi
import Alamofire

func UTF8ToGB2312(str: String) -> (NSData?, UInt) {
    let enc = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
    let data = str.data(using: String.Encoding(rawValue: enc), allowLossyConversion: false)
    return (data as NSData?, enc)
}

enum BackendError: Error {
    case network(error: Error)
    case dataSerialization(error: Error)
    case jsonSerialization(error: Error)
    case xmlSerialization(error: Error)
    case objectSerialization(error: Error)
}

extension DataRequest {
    
    public static func HTMLResponseSerializer() -> DataResponseSerializer<HTMLDocument> {
        return DataResponseSerializer { request, response, data, error in
            //catch web error
            guard error == nil else {
                return .failure(BackendError.network(error: error!))
            }
            //使用 alamofire 解决 data 的提取
            let result = Request.serializeResponseData(response: response, data: data, error: nil)
            guard case let .success(validData) = result else {
                return .failure(BackendError.dataSerialization(error: result.error! as! AFError))
            }
            //使用 Fuzi 解析 html
            do {
                let html = try HTMLDocument(data: validData)
                return .success(html)
            } catch {
                return .failure(BackendError.xmlSerialization(error: error))
            }
        }
        
    }
    //解析 HTML
    @discardableResult
    func responseHTMLDocument(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<HTMLDocument>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.HTMLResponseSerializer(), completionHandler: completionHandler)
    }
}
