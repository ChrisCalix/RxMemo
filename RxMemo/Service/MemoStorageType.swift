//
//  MemoStorageType.swift
//  RxMemo
//
//  Created by Sonic on 14/7/23.
//

import Foundation
import RxSwift

protocol MemoStorageType {
    @discardableResult
    func createMemo(using content: String) -> Observable<Memo>
    
    @discardableResult
    func memoList() -> Observable<[Memo]>
    
    @discardableResult
    func update(using memo: Memo, content: String) -> Observable<Memo>
    
    @discardableResult
    func delete(using memo: Memo) -> Observable<Memo>
}
