//
//  TransitionModel.swift
//  RxMemo
//
//  Created by Sonic on 14/7/23.
//

import Foundation

enum TransitionStyle {
    case root
    case push
    case modal
}

enum TransitionError: Error {
    case navigationControllerMissing
    case cannotPop
    case unknown
}
