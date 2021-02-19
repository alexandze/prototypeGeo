//
//  EnterpriseMakeNimSelectValue.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class EnterpriseMakeNimSelectValueImpl: EnterpriseMakeNimSelectValue {
    func makeNimSelectValueByEnterpriseList(_ enterpriseList: [Enterprise]) -> NimSelectValue? {
        let nimValueList = enterpriseList
            .map { $0.nim?.value }
            .filter(Util.filterTValueNotNil(String.self))
            .map(Util.mapUnwrapTValue(String.self))
        
        guard !nimValueList.isEmpty else { return nil }
        
        return NimSelectValue.make(nimValueList, nil) as? NimSelectValue
    }
}

protocol EnterpriseMakeNimSelectValue {
    func makeNimSelectValueByEnterpriseList(_ enterpriseList: [Enterprise]) -> NimSelectValue?
}
