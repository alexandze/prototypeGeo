//
//  CulturalPracticeRemoveFactory.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-22.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class CulturalPracticeRemoveFactoryImpl: CulturalPracticeRemoveFactory {

    func makeCulturalPraticeByRemove(_ culturalPractice: CulturalPractice, section: Section<ElementUIData>) -> CulturalPractice {
        guard let typeSection = section.typeSection,
            typeSection == ElementUIListData.TYPE_ELEMENT,
            let index = section.index else {
                return culturalPractice
        }

        var copyCulturalPractice = culturalPractice

        if var doseFumiers = copyCulturalPractice.doseFumier,
            Util.hasIndexInArray(doseFumiers, index: index) {
            doseFumiers.remove(at: index)
            copyCulturalPractice.doseFumier = doseFumiers
        }

        if var periodeApplicationFumier = copyCulturalPractice.periodeApplicationFumier,
            Util.hasIndexInArray(periodeApplicationFumier, index: index) {
            periodeApplicationFumier.remove(at: index)
            copyCulturalPractice.periodeApplicationFumier = periodeApplicationFumier
        }

        if var delaiIncorporationFumier = copyCulturalPractice.delaiIncorporationFumier,
            Util.hasIndexInArray(delaiIncorporationFumier, index: index) {
            delaiIncorporationFumier.remove(at: index)
            copyCulturalPractice.delaiIncorporationFumier = delaiIncorporationFumier
        }

        return copyCulturalPractice
    }
}

protocol CulturalPracticeRemoveFactory {
    func makeCulturalPraticeByRemove(_ culturalPractice: CulturalPractice, section: Section<ElementUIData>) -> CulturalPractice
}
