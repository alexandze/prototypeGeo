//
//  mapFieldMiddleware.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift
import ReSwift

class MapFieldMiddleware {
    let disposeBag = DisposeBag()

    func makeGetAllFieldMiddleware() -> Middleware<AppState> {
        let getAllFieldMiddleware: Middleware<AppState> = {dispatch, getState in
            return { next in
                return { action in
                    switch action {
                    case _ as MapFieldAction.GetAllField:
                        let fieldDictionnary = MapFieldService().getFields()

                        if let fieldDictionnary = fieldDictionnary {

                            let mapFieldAllFieldState = MapFieldState(
                                uuidState: NSUUID().uuidString,
                                fieldDictionnary: fieldDictionnary
                            )

                                dispatch(
                                    MapFieldAction.GetAllFieldSuccess(
                                        mapFieldAllFieldState: mapFieldAllFieldState
                                    )
                                )
                        }
                    default:
                        break
                    }

                    return next(action)
                }
            }
        }

        return getAllFieldMiddleware
    }
}
