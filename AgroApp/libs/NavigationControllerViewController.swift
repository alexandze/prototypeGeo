//
//  NavigationControllerViewController.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class NavigationControllerViewController<T: UIViewController>: UINavigationController {

    let rootViewController: T

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(rootViewController: T) {
        super.init(rootViewController: rootViewController)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
