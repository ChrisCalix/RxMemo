//
//  MemoDetailViewController.swift
//  RxMemo
//
//  Created by Sonic on 14/7/23.
//

import UIKit

class MemoDetailViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var viewModel: MemoDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func bindViewModel() {
        
    }
}
