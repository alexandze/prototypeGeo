//
//  MapField.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift

class MapFieldService {
    public func getFieldsObs() -> Single<[Int: Field]> {
        Single.create { event in
            guard let fieldDictionnary = MapFieldRepository().getFieldGeoJsonArray()
                else {
                    event(.error(MapFieldRepository.MapFieldRepositoryError.getFieldError))
                    return Disposables.create()
            }

            event(.success(fieldDictionnary))
            return Disposables.create()
        }.subscribeOn(Util.getSchedulerBackgroundForRequestServer())
    }
}
