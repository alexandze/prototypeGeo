//
//  ContainerMapAndTitleNavigationMiddleware.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-13.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

class ContainerMapAndTitleNavigationMiddleware {
    var middleware: Middleware<AppState> = { dispatch, getState in
        return { next in
            return { action in
                // TODO creer le producteur avec ses entreprises
                // print(action)
                
                // call next middleware
                return next(action)
            }
        }
    }
}
