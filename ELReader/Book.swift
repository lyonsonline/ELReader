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
class Book: BaseBookProtocol {
    let uri: String
    let name: String
    let category: String
    let author: String?
    var currentChapterNumber: Int = 0
    var catalogues: [(uri: String, title: String)]?
    
    init(uri: String, name: String, category: String, author: String? = nil) {
        self.uri = uri
        self.name = name
        self.category = category
        self.author = author
    }
    func catalogueURL() -> String {
        return "http://www.ybdu.com/xiaoshuo" + self.uri
    }
    
    func chapterURL(index: Int = -1) -> String {
        if index == -1 {
            return self.chapterURL(index: currentChapterNumber)
        }
        guard let catalogues = self.catalogues, index < catalogues.count else { return "" }
        let catalogue = catalogues[index]
        return "http://m.ybdu.com/xiaoshuo" + self.uri + catalogue.uri
    }
    
    func chapterHeader(index: Int = -1) -> String {
        if index == -1 {
            return self.chapterHeader(index: currentChapterNumber)
        }
        guard let catalogues = self.catalogues, index >= catalogues.count else { return "" }
        let catalogue = catalogues[index]
        return catalogue.title
    }
    
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
