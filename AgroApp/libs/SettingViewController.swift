//
//  SettingViewController.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-02.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import SwiftUI

class SettingViewController<T: View & SettingViewControllerProtocol>: UIHostingController<T> {

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(myView: T) {
        super.init(rootView: myView)
        rootView.dismiss = self.dismissVC
        rootView.setBackgroundColor = self.setBackgroundColor
        rootView.setAlpha = self.setAlpha
        rootView.setIsModalInPresentation = self.setIsModalInPresentation
    }

    func dismissVC(completion: (() -> Void)?) {
        self.dismiss(animated: true, completion: completion)
    }

    func setBackgroundColor(_ color: UIColor) {
        view.backgroundColor = color
    }

    func setAlpha(_ value: CGFloat) {
        view.alpha = value
    }

    func setIsModalInPresentation(_ value: Bool) {
        isModalInPresentation = value
    }
}

protocol SettingViewControllerProtocol {
    var dismiss: ((FuncVoid) -> Void)? {get set}
    var setBackgroundColor: ((UIColor) -> Void)? {get set}
    var setAlpha: ((CGFloat) -> Void)? {get set }
    var setIsModalInPresentation: ((Bool) -> Void)? {get set}
}

typealias FuncVoid = (() -> Void)?
