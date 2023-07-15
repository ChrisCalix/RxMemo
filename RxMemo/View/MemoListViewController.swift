//
//  MemoListViewController.swift
//  RxMemo
//
//  Created by Sonic on 14/7/23.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MemoListViewController: UIViewController, ViewModelBindableType {
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    let bag = DisposeBag()
    var viewModel: MemoListViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: bag)
        
        viewModel.memoList
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) {row, memo, cell in
                cell.textLabel?.text = memo.content
            }
            .disposed(by: bag)
        
        addBarButton
            .rx
            .action = viewModel.makeCreationAction()
        
        Observable.zip(tableView.rx.modelSelected(Memo.self), tableView.rx.itemSelected)
            .do(onNext: { [weak self] _, indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
                .map { $0.0 }
                .bind(to: viewModel.detailAction.inputs)
                .disposed(by: rx.disposeBag)
        
        tableView.rx.modelDeleted(Memo.self)
            .bind(to: viewModel.deleteAction.inputs)
            .disposed(by: rx.disposeBag)
    }
}
