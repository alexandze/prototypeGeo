//
//  FieldListViewModel.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-02-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift

class FieldListViewModelImpl: FieldListViewModel {
    
    let fieldListState$: Observable<FieldListState>
    let fieldListInteraction: FieldListInteraction
    
    init(
        fieldListState$: Observable<FieldListState>,
        fieldListInteraction: FieldListInteraction
    ) {
        self.fieldListState$ = fieldListState$
        self.fieldListInteraction = fieldListInteraction
    }
    
    
}

protocol FieldListViewModel {
    
}
