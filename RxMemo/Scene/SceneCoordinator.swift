//
//  SceneCoordinator.swift
//  RxMemo
//
//  Created by Sonic on 14/7/23.
//

import Foundation
import RxSwift
import RxCocoa

extension UIViewController {
    var sceneViewConrtoller: UIViewController {
        return self.children.first ?? self
    }
}

class SceneCoordinator: SceneCoordinatorType {
    private let bag = DisposeBag()
    private var window: UIWindow
    private var currentVC: UIViewController?
    
    required init(window: UIWindow) {
        self.window = window
        currentVC = window.rootViewController
    }
    
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
        let subject = PublishSubject<Void>()
        
        let target = scene.instantiate()
        
        switch style {
        case .root:
            currentVC = target.sceneViewConrtoller
            window.rootViewController = target
            window.makeKeyAndVisible()
            subject.onCompleted()
        case .push:
            guard let nav = currentVC?.navigationController else {
                subject.onError(TransitionError.navigationControllerMissing)
                break
            }
            
            nav.rx.willShow
                .subscribe(onNext: {[weak self] event in
                    self?.currentVC = event.viewController.sceneViewConrtoller
                })
                .disposed(by: bag)
            
            
            nav.pushViewController(target, animated: animated)
            currentVC = target.sceneViewConrtoller
            subject.onCompleted()
        case .modal:
            currentVC?.present(target, animated: animated) {
                subject.onCompleted()
            }
            currentVC = target.sceneViewConrtoller
        }
        
        return subject.ignoreElements().asCompletable()
    }
    
    @discardableResult
    func close(animated: Bool) -> RxSwift.Completable {
        return Completable.create { [weak self] completable in
            if let presentingVC = self?.currentVC?.presentingViewController {
                self?.currentVC?.dismiss(animated: animated) {
                    self?.currentVC = presentingVC.sceneViewConrtoller
                    completable(.completed)
                }
            } else if let nav = self?.currentVC?.navigationController {
                guard nav.popViewController(animated: animated) != nil else {
                    completable(.error(TransitionError.cannotPop))
                    return Disposables.create()
                }
                self?.currentVC = nav.viewControllers.last!
                completable(.completed)
            } else {
                completable(.error(TransitionError.unknown))
            }
            
            return Disposables.create()
        }
    }
}
