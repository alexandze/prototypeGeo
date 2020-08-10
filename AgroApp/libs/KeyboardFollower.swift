//
//  KeyboardFollower.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-04.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

import UIKit

class KeyboardFollower : ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    @Published var maxY: CGFloat = 0
    @Published var minY: CGFloat = 0
    @Published var isVisible = false

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardVisibilityChanged), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc private func keyboardVisibilityChanged(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        isVisible = keyboardEndFrame.minY < UIScreen.main.bounds.height
        keyboardHeight = isVisible ? keyboardEndFrame.height : 0
        maxY = isVisible ? keyboardEndFrame.maxY : 0
        minY = isVisible ? keyboardEndFrame.minY : 0
    }
}
