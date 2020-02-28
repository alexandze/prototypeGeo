//
//  mapFieldMiddleware.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift

class MapFieldMiddleware {
    let disposeBag = DisposeBag()
    static let shared = MapFieldMiddleware()
    let mapFieldService = MapFieldService.shared
}
