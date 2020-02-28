//
//  NavigationState.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-08.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

struct NavigationState: Equatable {
    static func == (lhs: NavigationState, rhs: NavigationState) -> Bool {
        return lhs.url == rhs.url
    }
    
    
    var url: String?
    var data: [AnyHashable : Any]?
    
}
