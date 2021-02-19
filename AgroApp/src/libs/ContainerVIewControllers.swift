//
//  ContainerVIewControllers.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

protocol ContainerViewController {
    var viewControllers: [UIViewController] {get set}
    static var identifier: String {get set}
}
