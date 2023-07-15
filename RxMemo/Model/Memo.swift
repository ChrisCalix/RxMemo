//
//  Memo.swift
//  RxMemo
//
//  Created by Sonic on 14/7/23.
//

import Foundation
import RxDataSources

struct Memo: Equatable, IdentifiableType {
    var content: String
    let insertDate: Date
    let identity: String
    
    init(content: String, insertDate: Date = Date()) {
        self.content = content
        self.insertDate = insertDate
        self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    init(original: Memo, updateContent: String) {
        self = original
        self.content = updateContent
    }
}
