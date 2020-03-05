//
//  GetAllFieldMiddleware.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

extension MapFieldMiddleware {
    func makeGetAllFieldMiddleware() -> Middleware<AppState> {
        let getAllFieldMiddleware: Middleware<AppState> = {dispatch, getState in
            return { next in
                return { action in
                    switch action {
                    case _ as MapFieldAction.GetAllField:
                        let fieldPolygonAnnotationTuple = self.mapFieldService.getFields()
                        
                        if let tupleUtilPolygon = fieldPolygonAnnotationTuple?.0,
                            let tupleUtilMultiPolygon = fieldPolygonAnnotationTuple?.1 {
                             
                            let mapFieldAllFieldState = MapFieldState(uuidState: NSUUID().uuidString, fieldPolygonAnnotation: tupleUtilPolygon, fieldMultiPolygonAnnotation: tupleUtilMultiPolygon)
                            
                            dispatch(MapFieldAction.GetAllFieldSuccess(mapFieldAllFieldState: mapFieldAllFieldState))
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
