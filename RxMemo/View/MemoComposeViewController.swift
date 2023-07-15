//
//  MemoComposeViewController.swift
//  RxMemo
//
//  Created by Sonic on 14/7/23.
//

import UIKit
import RxSwift
import RxCocoa
import Action

class MemoComposeViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    
    var viewModel: MemoComposeViewModel!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: bag)
        
        viewModel.initialText
            .drive(textView.rx.text)
            .disposed(by: bag)
        
        cancelBarButton.rx.action = viewModel.cancelAction
        saveBarButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(textView.rx.text.orEmpty)
            .bind(to: viewModel.saveAction.inputs)
            .disposed(by: rx.disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if textView.isFirstResponder {
            textView.resignFirstResponder()
        }
    }
}
