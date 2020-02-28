//
//  UtilAreaPolygon.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-02-07.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class UtilCalcul {
    // calcul l'aire du rectangle
    private func calcZoneHa2(polygon: [[Double]]) -> Double {
        // TODO chercher la formule
        return 0.0
    }
    
    /**
     calcul des quantite
     - Parameter zoneHa2: Column
     */
    private func calcQte(zoneHa2: Double, sed: Double) -> Double {
        zoneHa2 * sed;
    }
    
    /**
     calcul modif ghDrain
     - Parameter drainSout: Column Drai_Sout
     - Returns: new column Modif_GHDRAIN
     */
    private static func calcModifGhdrain(drainSout: DomDrainSout) -> Int {
        switch drainSout {
        case .systematique:
            return -2
        case .partiel:
            return -1
        case .absent, .none:
            return 0
        }
    }
    
    /**
     Calcul new value of  column  Gr_hydroDRAIN
     - Parameter drainSout: Column Drai_sout
     - Parameter grHydroS: Column GR_HYDROs
     - Parameter modifGhdrain: Column Modif_GHDRAIN, result of function calcModifGhdrain
     - Returns: new column Gr_hydroDRAIN
     */
    private static func calcGrHydroDrain(drainSout: DomDrainSout, grHydroS: Int, modifGhdrain: Int ) -> Int {
        switch drainSout {
        case .systematique, .partiel, .absent:
            return grHydroS + modifGhdrain
        case .none:
            return grHydroS
        }
    }
    
    /**
     Calcul new column Modif_GrHySURF
     - Parameter domDrainSurf: Column Drai_surf
     - Returns: new value of column Modif_GrHySURF
     */
    private static func calcModifGrHySurf(domDrainSurf: DomDrainSurf) -> Int {
        switch domDrainSurf {
        case .bon:
            return -1
        case .moyen, .none:
            return 0
        case .deficient:
            return 1
        }
    }
    /**
    Calcul new column Modif_GrHyPROFIL
    - Parameter domCondHydro: Column Cond_hydro
    - Returns: new value of column Modif_GrHyPROFIL
    */
    private static func calcModifGrHyProfil(domCondHydro: DomCondHydro) -> Int {
        switch domCondHydro {
        case .bonne, .none:
            return 0
        case .presenceZoneRisque:
            return 1
        case .dominanceZoneRisque:
            return 2
        }
    }
    
    /**
     Calcul new  column Gr_hydroF
     - Parameter grHydroS:Column GR_HYDROs
     - Parameter modifGrHySurf: value of  column Modif_GrHySURF from function calcModifGrHySurf
     - Parameter modifGrHyProfil: value of column Modif_GrHyPROFIL from function calcModifGrHyProfil
     - Returns: new value of  column Gr_hydroF
     */
    private static func calcGrHydroF(grHydroS: Int, modifGrHySurf: Int, modifGrHyProfil: Int) -> Int {
        grHydroS + modifGrHySurf + modifGrHyProfil
    }
    
    /**
     Calcul new column Gr_hydroF2
     - Parameter grHydroF: Column Gr_hydroF create with function calcGrHydroF
     - Returns: new value of column Gr_hydroF2
     */
    private static func calcGrHydroF2(grHydroF: Int) -> Int {
        grHydroF > 9 ? 9 : grHydroF
    }
    
    /**
     Calcul value of new column Qsurf
     - Parameter domUtilTerr: value from column  Util_terr
     - Parameter grHydroDrain: value from column Gr_hydroDRAIN calcul by function calcGrHydroDrain
     - Returns: new value of column Qsurf
     */
    private static func calcQsurf(domUtilTerr: DomUtilTerr, grHydroDrain: Int) -> Double {
        switch domUtilTerr {
        case .MAI, .MAR:
            return 4.8571 * pow(Double(grHydroDrain), 2) - 12.171 * Double(grHydroDrain) + 66.7
        case .FOI, .NON:
            return 3.4175 * pow(Double(grHydroDrain), 2) - 7.9543 * Double(grHydroDrain) + 60
        case .SOY, .CNL:
            return 4.9858 * pow(Double(grHydroDrain), 2) - 13.82 * Double(grHydroDrain) + 66.88
        case .AVO, .ORG, .BLE, .AUC, .MIX, .PTF:
            return 4.6351 * pow(Double(grHydroDrain), 2) - 11.73 * Double(grHydroDrain) + 62.95
        default:
            return 3.4175 * pow(Double(grHydroDrain), 2) - 7.9543 * Double(grHydroDrain) + 30.76
        }
    }
    
    private static func calcQsurf2preMaiMar(domUtilTerr: DomUtilTerr, grHydroDrain: Int, domCondHydro: DomCondHydro, domDrainSurf: DomDrainSurf, qSurf: Double) -> Double? {
        
        if (domUtilTerr == .MAI || domUtilTerr == .MAR) && domCondHydro == .bonne && domDrainSurf == .bon && grHydroDrain == 1 {
            return 0 + 0 + qSurf
        }
        
        if (domUtilTerr == .MAI || domUtilTerr == .MAR) && domCondHydro == .bonne && domDrainSurf == .bon && grHydroDrain > 1 {
            return 0 - 56.2 + qSurf
        }
        
        if  (domUtilTerr == .MAI || domUtilTerr == .MAR) && domCondHydro == .bonne && domDrainSurf == .moyen {
            return 0 + 0 + qSurf
        }
        
        if (domUtilTerr == .MAI || domUtilTerr == .MAR) && domCondHydro == .bonne && domDrainSurf == .deficient {
            return 0 + 56.2 + qSurf
        }
        
        if (domUtilTerr == .MAI || domUtilTerr == .MAR) && domCondHydro == .presenceZoneRisque && domDrainSurf == .bon && grHydroDrain == 1 {
            return 28.1 + 0 + qSurf
        }
        
        if (domUtilTerr == .MAI || domUtilTerr == .MAR) && domCondHydro == .presenceZoneRisque && domDrainSurf == .bon && grHydroDrain > 1 {
            return 28.1 - 56.2 + qSurf
        }
        
        if (domUtilTerr == .MAI || domUtilTerr == .MAR) && domCondHydro == .presenceZoneRisque && domDrainSurf == .moyen {
            return 28.1 + 0 + qSurf
        }
        
        if (domUtilTerr == .MAI || domUtilTerr == .MAR) && domCondHydro == .presenceZoneRisque && domDrainSurf == .deficient {
            return 28.1 + 56.2 + qSurf
        }
        
        if (domUtilTerr == .MAI || domUtilTerr == .MAR) && domCondHydro == .dominanceZoneRisque && domDrainSurf == .bon && grHydroDrain == 1 {
            return 56.2 + 0 + qSurf
        }
        
        if (domUtilTerr == .MAI || domUtilTerr == .MAR) && domCondHydro == .dominanceZoneRisque && domDrainSurf == .bon && grHydroDrain > 1 {
            return 56.2 - 56.2 + qSurf
        }
        
        if (domUtilTerr == .MAI || domUtilTerr == .MAR) && domCondHydro == .dominanceZoneRisque && domDrainSurf == .moyen {
            return 56.2 + 0 + qSurf
        }
        
        if (domUtilTerr == .MAI || domUtilTerr == .MAR) && domCondHydro == .dominanceZoneRisque && domDrainSurf == .deficient {
            return 56.2 + 56.2 + qSurf
        }
        
        return nil
    }
}

enum DomCondHydro: Int {
    case none
    case bonne
    case presenceZoneRisque
    case dominanceZoneRisque
    
    init(rawValue: Int) {
        switch rawValue {
        case 1:
            self = .bonne
        case 2:
            self = .presenceZoneRisque
        case 3:
            self = .dominanceZoneRisque
        default:
            self = .none
        }
    }
    
    func getValue() -> String {
        switch self {
        case .bonne:
            return "Bonne"
        case .presenceZoneRisque:
            return "Présence de zone à risque"
        case .dominanceZoneRisque:
            return "Dominance de zone à risque"
        case .none:
            return "Unknown value"
        }
    }
    
    static func getValues() -> [(value: String, rawValue: Int)] {
        [
            (DomCondHydro.bonne.getValue(), DomCondHydro.bonne.rawValue),
            (DomCondHydro.presenceZoneRisque.getValue(), DomCondHydro.presenceZoneRisque.rawValue),
            (DomCondHydro.dominanceZoneRisque.getValue(), DomCondHydro.dominanceZoneRisque.rawValue)
        ]
    }
}


enum DomUtilTerr: String {
    case AUC = "Autre culture"
    case AVO = "Avoine"
    case BLE = "Blé, triticale, épeautre"
    case Brsh = "Broussailles"
    case CNL = "Canola"
    case EAU = "Plan d'eau"
    case F = "Forêt"
    case FOI = "Foin"
    case ILE = "Île"
    case MAI = "Maïs"
    case MAR = "Maraîcher"
    case MIX = "Culture multiple"
    case NON = "Culture inconnue"
    case NPv = "Route non-pavée"
    case ORG = "Orge"
    case PTF = "Petits fruits"
    case Pve = "Route pavée"
    case ResL = "Zone urbaine - Densité faible"
    case ResM = "Zone urbaine - Densité élevée"
    case SOY = "Soya"
    case Wet = "Milieu humide"
    
}


// dom_drain_sout
enum DomDrainSout: Int {
    case none = 0
    case systematique
    case partiel
    case absent
    
    init(rawValue: Int) {
        switch rawValue {
        case 1:
            self = .systematique
        case 2:
            self = .partiel
        case 3:
            self = .absent
        default:
            self = .none
        }
    }
    
    func getValue() -> String {
        switch self {
        case .systematique :
            return "Systématique"
        case .partiel:
            return "Partiel"
        case .absent:
            return "Absent"
        case .none:
            return "Unknown value"
        }
    }
    
    static func getValues() -> [(value: String, rawValue: Int)] {
        [
            (DomDrainSout.systematique.getValue(), DomDrainSout.systematique.rawValue ),
            (DomDrainSout.partiel.getValue(), DomDrainSout.partiel.rawValue),
            (DomDrainSout.absent.getValue(), DomDrainSout.absent.rawValue)
        ]
    }
}

enum DomDrainSurf: Int {
    case none
    case bon
    case moyen
    case deficient
    
    init(rawValue: Int) {
        switch rawValue {
        case 1:
            self = .bon
        case 2:
            self = .moyen
        case 3:
            self = .deficient
        default:
            self = .none
        }
    }
    
    func getValue() -> String {
        switch self {
        case .bon:
            return "Bon"
        case .moyen:
            return "Moyen"
        case .deficient:
            return "Déficient"
        case .none:
            return "Unknown value"
        }
    }
    
    static func getValues() -> [(value: String, rawValue: Int)] {
        [
            (DomDrainSurf.bon.getValue(), DomDrainSurf.bon.rawValue),
            (DomDrainSurf.moyen.getValue(), DomDrainSurf.moyen.rawValue),
            (DomDrainSurf.deficient.getValue(), DomDrainSurf.deficient.rawValue)
        ]
    }
    
    
}
