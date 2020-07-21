//
//  FieldGeoJsonArray.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct FieldGeoJsonArray: Codable {
    var features: [Feature]
}

struct Feature: Codable {
    var id: Int
    var geometry: Geometry
}

struct Geometry: Codable {
    var type: String?
    var coordinates: [[[Double]]]?
    var coordinatesMulti: [[[[Double]]]]?

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decode(String.self, forKey: .type)

        if type == "Polygon" {
            coordinates = try? values.decode([[[Double]]].self, forKey: .coordinates)
        }

        if type == "MultiPolygon" {
            coordinatesMulti = try values.decode([[[[Double]]]].self, forKey: .coordinates)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case coordinates
    }
}

struct Properties: Decodable {
    var id: Int?
    var avaloir: Avaloir?
    var bandeRiveraine: BandeRiveraine?
    var doseFumier: [DoseFumier?]?
    var periodeApplicationFumier: [PeriodeApplicationFumier?]?
    var delaiIncorporationFumier: [DelaiIncorporationFumier?]?
    var travailSol: TravailSol?
    var couvertureAssociee: CouvertureAssociee?
    var drainageSouterrain: DrainageSouterrain?
    var drainageSurface: DrainageSurface?
    var conditionProfilCultural: ConditionProfilCultural?
    var tauxApplicationPhosphoreRang: TauxApplicationPhosphoreRang?
    var tauxApplicationPhosphoreVolee: TauxApplicationPhosphoreVolee?
    var pMehlich3: PMehlich3?
    var alMehlich3: AlMehlich3?
    var cultureAnneeEnCoursAnterieure: CultureAnneeEnCoursAnterieure?
    
    init(from decoder: Decoder) throws {
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "OBJECTID"
        case avaloir = "Avaloir"
        case bandeRiveraine = "Bande_riv"
        case doseFumier1 = "FUMP_DOSE"
        case doseFumier2 = "FUMP2_DOSE"
        case doseFumier3 = "FUMP3_DOSE"
        case periodeApplicationFumier1 = "FUM1_PER"
        case periodeApplicationFumier2 = "FUM2_PER"
        case periodeApplicationFumier3 = "FUM3_PER"
        case delaiIncorporationFumier1 = "FUM1_DELAI"
        case delaiIncorporationFumier2 = "FUM2_DELAI"
        case delaiIncorporationFumier3 = "FUM3_DELAI"
        case travailSol = "TRAV_SOL"
        case couvertureAssociee = "Couv_ass"
        case drainageSouterrain = "Drai_Sout"
        case drainageSurface = "Drai_surf"
        case conditionProfilCultural = "Cond_hydro" // a verifier
        case tauxApplicationPhosphoreRang = "?"
        case tauxApplicationPhosphoreVolee = "??"
        case pMehlich3 = "P_M3"
        case alMehlich3 = "AL_M3"
        case cultureAnneeEnCoursAnterieure = "util_terr"
    }
}
