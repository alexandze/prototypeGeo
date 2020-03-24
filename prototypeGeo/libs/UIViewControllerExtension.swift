//
//  UIViewControllerExtension.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-02.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

extension UIViewController {
    func addChilds(_ viewControllers: UIViewController...) {
        viewControllers.forEach { self.addChild($0) }
    }

    func addSubviews(_ views: UIView ...) {
        views.forEach { self.view.addSubview($0) }
    }

    func getAppDelegate() -> AppDelegate? {
        UIApplication.shared.delegate as? AppDelegate
    }
}
