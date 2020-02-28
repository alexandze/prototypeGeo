//
//  ActionDispatcher.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-03.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

public protocol ActionDispatcher {
    func dispatch(_ action: Action)
}

extension Store: ActionDispatcher { }
