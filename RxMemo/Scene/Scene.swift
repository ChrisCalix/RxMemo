//
//  Scene.swift
//  RxMemo
//
//  Created by Sonic on 14/7/23.
//

import UIKit

enum Scene {
    case list(MemoListViewModel)
    case detail(MemoDetailViewModel)
    case compose(MemoComposeViewModel)
}

extension Scene {
    func instantiate(from storyboard: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        
        switch self {
        case .list(let memoListViewModel):
            let nav = storyboard.instantiateViewController(withIdentifier: "ListNav") as! UINavigationController
            var listVC = nav.viewControllers.first as! MemoListViewController
            listVC.bind(viewModel: memoListViewModel)
            return nav
        case .detail(let memoDetailViewModel):
            var detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as! MemoDetailViewController
            detailVC.bind(viewModel: memoDetailViewModel)
            return detailVC
        case .compose(let memoComposeViewModel):
            let nav = storyboard.instantiateViewController(withIdentifier: "ComposeNav") as! UINavigationController
            var listVC = nav.viewControllers.first as! MemoComposeViewController
            listVC.bind(viewModel: memoComposeViewModel)
            return nav
        }
    }
}
