//
//  ContainerMapAndListFieldViewController.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-02-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class ContainerMapAndListFieldViewController: UIViewController, ContainerViewController, Identifier {
    var viewControllers: [UIViewController] = []
    static var identifier: String = "ContainerMapAndListFieldViewController"
    
    
    let mapFieldViewController: MapFieldViewController
    let fieldListNavigationController: UINavigationController
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(
        mapFieldViewController: MapFieldViewController,
        fieldListNavigationController: UINavigationController
    ) {
        self.mapFieldViewController = mapFieldViewController
        self.fieldListNavigationController = fieldListNavigationController
        viewControllers.append(mapFieldViewController)
        viewControllers.append(fieldListNavigationController)
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
