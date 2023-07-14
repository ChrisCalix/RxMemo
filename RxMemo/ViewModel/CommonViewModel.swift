//
//  CommonViewModel.swift
//  RxMemo
//
//  Created by Sonic on 14/7/23.
//

import Foundation
import RxSwift
import RxCocoa

class CommonViewModel {
    let title: Driver<String>
    let sceneCoordinator: SceneCoordinatorType
    let storage: MemoStorageType
    
    init(title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    }
}
