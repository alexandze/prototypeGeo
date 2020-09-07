//
//  GetFarmersMiddleware.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-03.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift
import RxSwift

extension FarmerMiddleware {
    func makeGetFarmersMiddleware() -> Middleware<AppState> {
        let getFarmersMiddleware: Middleware<AppState> = {dispatch, getState in
            return { next in
                return { action in
                    switch action {
                    case _ as ProducerListAction:
                        break
                    default:
                        break
                    }

                    return next(action)
                }
            }
        }

        return getFarmersMiddleware
    }

    private func getSectionFromFarmers(farmers: [Farmer]) -> [Section<FarmerFormated>] {
        let farmersFormated = createFarmersFormatedFromFarmers(farmers: farmers)
        let farmerFormatedGrouping = createDictionaryGroupingFromFarmers(farmersFormated: farmersFormated)
        let farmerSorted = sortedFarmersFormatedDictionnary(farmersFormated: farmerFormatedGrouping)
        return tupleFarmersToSection(farmers: farmerSorted)
    }

    private func createFarmersFormatedFromFarmers(farmers: [Farmer]) -> [FarmerFormated] {
        farmers.map {
            FarmerFormated(farmer: $0, lastNameFormated: $0.lastName.uppercased())
        }
    }

    private func createDictionaryGroupingFromFarmers(
        farmersFormated: [FarmerFormated]
    ) -> [String: [FarmerFormated]] {
        Dictionary(grouping: farmersFormated) { String($0.lastNameFormated.prefix(1)) }
    }

    private func sortedFarmersFormatedDictionnary(
        farmersFormated: [String: [FarmerFormated]]
    ) -> [(key: String, value: [FarmerFormated])] {
        Array(farmersFormated).sorted(by: {$0.key < $1.key})
    }

    private func tupleFarmersToSection(farmers: [(key: String, value: [FarmerFormated])] ) -> [Section<FarmerFormated>] {
        farmers.map {
            Section<FarmerFormated>(sectionName: $0.key, rowData: $0.value)
        }
    }

    // swiftlint:disable:next force_cast
    private func getFamers() -> Single<[Farmer]> {
        let farmers = [
            Farmer(firstName: "APrenom", lastName: "BNom"),
            Farmer(firstName: "AWPrenom", lastName: "BNom"),
            Farmer(firstName: "ASPrenom", lastName: "BNom"),
            Farmer(firstName: "ABPrenom", lastName: "BNom"),
            Farmer(firstName: "BPrenom", lastName: "BNom"),
            Farmer(firstName: "BPrenom", lastName: "BNom"),
            Farmer(firstName: "IPrenom", lastName: "DNom"),
            Farmer(firstName: "IPrenom", lastName: "XNom"),
            Farmer(firstName: "ZPrenom", lastName: "BNom"),
            Farmer(firstName: "ZPrenom", lastName: "BNom"),
            Farmer(firstName: "APrenom", lastName: "BNom"),
            Farmer(firstName: "APrenom", lastName: "BNom"),
            Farmer(firstName: "ASPrenom", lastName: "BNom"),
            Farmer(firstName: "APrenom", lastName: "BNom"),
            Farmer(firstName: "asdfasPrenom", lastName: "BNom"),
            Farmer(firstName: "kfghmPrenom", lastName: "BNom"),
            Farmer(firstName: "mgvcbnPrenom", lastName: "BNom"),
            Farmer(firstName: "xcfhjbvPrenom", lastName: "BNom"),
            Farmer(firstName: "dfghPrenom", lastName: "BNom"),
            Farmer(firstName: "sdfgPrenom", lastName: "BNom"),
            Farmer(firstName: "APrenom", lastName: "BNom"),
            Farmer(firstName: "APrenom", lastName: "BNom"),
            Farmer(firstName: "APrenom", lastName: "BNom"),
            Farmer(firstName: "APrenom", lastName: "BNom"),
            Farmer(firstName: "APrenom", lastName: "BNom"),
            Farmer(firstName: "APrenom", lastName: "BNom"),
            Farmer(firstName: "hgjfgPrenom", lastName: "BNom"),
            Farmer(firstName: "dsfPrenom", lastName: "BNom"),
            Farmer(firstName: "AdsfdsPrenom", lastName: "BNom"),
            Farmer(firstName: "AdsfsPrenom", lastName: "BNom"),
            Farmer(firstName: "AfsdfPrenom", lastName: "llkBNom"),
            Farmer(firstName: "qwerwqPrenom", lastName: "xxcxBNom"),
            Farmer(firstName: "sadaPrenom", lastName: "xzxcBNom"),
            Farmer(firstName: "asdasPrenom", lastName: "BxzNom"),
            Farmer(firstName: "asdPrenom", lastName: "BxzcxNom"),
            Farmer(firstName: "nbvsdaPrenom", lastName: "BNom"),
            Farmer(firstName: "xcxcPrenom", lastName: "hhBjhjNom"),
            Farmer(firstName: "xbhgfPrenom", lastName: "gjhjkBNom"),
            Farmer(firstName: "NjjikPrenom", lastName: "hghBNom"),
            Farmer(firstName: "cnbvPrenom", lastName: "fgfBNom"),
            Farmer(firstName: "lhkjPrenom", lastName: "BNom"),
            Farmer(firstName: "sgfjhPrenom", lastName: "sdfNom")
        ]
        // TODO appeler le service qui recupere le farmer
        return Single.create { singleObser in
            singleObser(.success(farmers))
            return Disposables.create()
        }

    }

}
