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
    }
}
