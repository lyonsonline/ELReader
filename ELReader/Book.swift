//
//  Book.swift
//  ELReader
//
//  Created by Lyons Eric on 2017/3/23.
//  Copyright © 2017年 Lyons Eric. All rights reserved.
//

import Foundation
import Fuzi

extension NodeSet
{
    func bookListFilterMap(_ transform: (XMLElement) -> Book ) -> [Book] {
        var result: [Book] = []
        for element in self where element[0] != nil && element[1] != nil {
            result.append(transform(element))
        }
        return result
    }
    
}
protocol BaseBookProtocol {
    var uri: String {get}
    var name: String {get}
    var category: String {get}
    var author: String? {get}
}
struct Book: BaseBookProtocol {
    let uri: String
    let name: String
    let category: String
    let author: String?
    
    static func creatBooks(from html: HTMLDocument) -> [Book] {
        return html.css(".list p").bookListFilterMap { (element) -> Book in
            let category = element[0]!.stringValue
            let name = element[1]!.stringValue
            let uri = element[1]!.attr("href")!.replacingOccurrences(of: "/xiazai", with: "")
            let author = element.firstChild(xpath: "text()")?.stringValue.replacingOccurrences(of: "/", with: "")
            return Book(uri: uri, name: name, category: category, author: author)
        }
    }
}
