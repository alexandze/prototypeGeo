//
//  UIButtonHosting.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-03.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

struct UIButtonRepresentable: UIViewRepresentable {
    let action: () -> Void

    func makeUIView(context: Context) -> UIButton {
        let button = createButton()
        addTargetTo(button: button, context)
        return button
    }

    func makeCoordinator() -> UIButtonRepresentable.Coordinator {
        Coordinator(self)
    }

    func updateUIView(_ uiView: UIButton, context: Context) {

    }
    
    static func dismantleUIView(_ uiView: UIButton, coordinator: Coordinator) {
        print("***** deinit close button *****")
    }

    class Coordinator: NSObject {
        var parent: UIButtonRepresentable

        init(_ parent: UIButtonRepresentable) {
            self.parent = parent
        }

        @objc func handleActionButton(_ sender: UIButton) {
            self.parent.action()
        }
    }

    private func createButton() -> UIButton {
        let button = UIButton(type: .close)
        button.sizeToFit()
        return button
    }

    private func addTargetTo(button: UIButton, _ context: Context) {
        button.addTarget(context.coordinator, action: #selector(Coordinator.handleActionButton(_:)), for: .touchUpInside)
    }
}
