//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by Sonic on 14/7/23.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import RxDataSources

typealias MemoSectionModel =  AnimatableSectionModel<Int, Memo>

class MemoListViewModel: CommonViewModel {
    let dataSource: RxTableViewSectionedAnimatedDataSource<MemoSectionModel> = {
        let ds = RxTableViewSectionedAnimatedDataSource<MemoSectionModel>(configureCell: { dataSource, tableView, indexPath, memo in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = memo.content
            return cell
        })
        ds.canEditRowAtIndexPath = { _, _ in return true }
        return ds
    }()
    
    var memoList: Observable<[MemoSectionModel]> {
        return storage.memoList()
    }
    
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action { input in
            return self.storage.update(using: memo, content: input)
                .map { _ in }
        }
    }
    
    func performCancel(memo: Memo) -> CocoaAction {
        return Action {
            return self.storage.delete(using: memo).map { _ in }
        }
    }
    
    func makeCreationAction() -> CocoaAction {
        return CocoaAction { _ in
            return self.storage.createMemo(using: "")
                .flatMap { memo -> Observable<Void> in
                    let composeViewModel = MemoComposeViewModel(
                        title: "Model",
                        sceneCoordinator: self.sceneCoordinator,
                        storage: self.storage,
                        saveAction: self.performUpdate(memo: memo),
                        cancelAction: self.performCancel(memo: memo)
                    )
                    let composeScene = Scene.compose(composeViewModel)
                    return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true)
                        .asObservable()
                        .map { _ in }
                }
        }
    }
    
    lazy var detailAction: Action<Memo, Void> = {
        return Action { memo in
            let detailViewModel = MemoDetailViewModel(memo: memo, title: "DetailViewModel", sceneCoordinator: self.sceneCoordinator, storage: self.storage)
            
            let detailScene = Scene.detail(detailViewModel)
            
            return self.sceneCoordinator
                .transition(to: detailScene, using: .push, animated: true)
                .asObservable()
                .map { _ in }
        }
    }()
    
    lazy var deleteAction: Action<Memo, Swift.Never> = {
        return Action { memo in
            return self.storage.delete(using: memo).ignoreElements()
        }
    }()
}
