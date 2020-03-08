//
//  CulturalPractice.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-02-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct CulturalPractice {
    var avaloir: Avaloir
    var bandeRiveraine: BandeRiveraine
    var doseFumier: [DoseFumier] // jusqu'a trois dose
    var periodeApplicationFumier: PeriodeApplicationFumier // jusqu'a trois application
    var delaiIncorporationFumier: DelaiIncorporationFumier // jusqu'a trois application
    var travailSol: TravailSol
    var couvertureAssociee: CouvertureAssociee
    var couvertureDerobee: CouvertureDerobee
    var drainageSouterrain: DrainageSouterrain
    var drainageSurface: DrainageSurface
    var conditionProfilCultural: ConditionProfilCultural
    var tauxApplicationPhosphoreRang: KilogramPerHectare
    var tauxApplicationPhosphoreVolee: KilogramPerHectare
    var pMehlich3: KilogramPerHectare
    var alMehlich3: Percentage
    var cultureAnneeEnCours: String
    var cultureAnneeAnterieure: String
}

enum Avaloir {
    case absente
    case captagePartiel
    case captageSystematique

    static func getValues() -> [(Avaloir, String)] {
        [
            (Avaloir.absente, NSLocalizedString("Absente", comment: "Avaloir absente")),
            (
                Avaloir.captagePartiel,
                NSLocalizedString("Captage Partiel", comment: "Avaloir captage partiel")
            ),
            (
                Avaloir.captageSystematique,
                NSLocalizedString("Captage systématique", comment: "Avaloir Captage systématique")
            )
        ]
    }
}

enum BandeRiveraine {
    case pasApplique
    case inferieura1M
    case de1A3M
    case de4MEtPlus

    static func getValues() -> [(BandeRiveraine, String)] {
        [
            (
                BandeRiveraine.pasApplique,
                NSLocalizedString("Ne s'applique pas", comment: "Bande riveraine ne s'applique pas")
            ),
            (
                BandeRiveraine.inferieura1M,
                NSLocalizedString("Inférieur à 1m", comment: "Bande riveraine Inférieur à 1m")
            ),
            (
                BandeRiveraine.de1A3M,
                NSLocalizedString("1 à 3m", comment: "Bande riveraine 4m et plus")
            ),
            (
                BandeRiveraine.de4MEtPlus,
                NSLocalizedString("4m et plus", comment: "Bande riveraine 4m et plus")
            )
        ]
    }
}

enum DoseFumier {
    case dose(Int)

    static func getValues() -> [Int] {
         [0, 1, 2, 3]
    }
}

enum PeriodeApplicationFumier {
    case preSemi
    case postLevee
    case automneHatif
    case automneTardif

    static func getValue() -> [(PeriodeApplicationFumier, String)] {
        [
            (
                PeriodeApplicationFumier.preSemi,
                NSLocalizedString("Pré-semi", comment: "Periode d'application du fumier Pré-semi")
            ),
            (
                PeriodeApplicationFumier.postLevee,
                NSLocalizedString("Post-levée", comment: "Periode d'application du fumier Post-levée")
            ),
            (
                PeriodeApplicationFumier.preSemi,
                NSLocalizedString("Automne hâtif", comment: "Periode d'application du fumier Automne hâtif")
            ),
            (
                PeriodeApplicationFumier.preSemi,
                NSLocalizedString("Automne tardif", comment: "Periode d'application du fumier Automne tardif"))
        ]
    }
}

enum DelaiIncorporationFumier {
    case incorporeEn48H
    case incorporeEn48HA1Semaine
    case superieureA1Semaine
    case nonIncorpore

    static func getValue() -> [(DelaiIncorporationFumier, String)] {
        [
            (DelaiIncorporationFumier.incorporeEn48H, NSLocalizedString("Incorporé en 48h", comment: "Delai d'incorporation du fumier Incorporé en 48h")),
            (DelaiIncorporationFumier.incorporeEn48HA1Semaine, NSLocalizedString("Incorporé en 48h à 1 semaine", comment: "Delai d'incorporation du fumier Incorporé en 48h à 1 semaine")),
            (DelaiIncorporationFumier.superieureA1Semaine, NSLocalizedString("Supérieur à 1 semaine", comment: "Delai d'incorporation du fumier Supérieur à 1 semaine")),
            (DelaiIncorporationFumier.nonIncorpore, NSLocalizedString("Non incorporé", comment: "Delai d'incorporation du fumier Non incorporé"))
        ]
    }
}

enum TravailSol {
    case labourAutomneTravailSecondairePrintemps
    case chiselPulverisateurAutomneTravailSecondairePrintemps
    case dechaumageAuPrintempsTravailSecondairePrintemps
    case semiDirectOuBilons

    static func getValue() -> [(TravailSol, String)] {
        [
            (
                TravailSol.labourAutomneTravailSecondairePrintemps,
                NSLocalizedString("Labour à l'automne, travail secondaire au printemps",comment: "Travail du sol Labour à l'automne")),
            (
                TravailSol.chiselPulverisateurAutomneTravailSecondairePrintemps,
                NSLocalizedString(
                    "Chisel ou pulvérisateur à l'automne, travail secondaire au printemps",
                    comment: "Travail du sol Chisel ou pulvérisateur à l'automne, travail secondaire au printemps"
            )
            ),
            (
                TravailSol.dechaumageAuPrintempsTravailSecondairePrintemps,
             NSLocalizedString(
                "Déchaumage au printemps et travail secondaire au printemps",
                comment: "Travail du sol Déchaumage au printemps et travail secondaire au printemps")
            ),
            (
                TravailSol.semiDirectOuBilons,
                NSLocalizedString("Semi direct ou bilons", comment: "Travail du sol Semi direct ou bilons"))
        ]
    }
}

enum CouvertureAssociee {
    case oui
    case non

    static func getValue() -> [(CouvertureAssociee, String)] {
        [
            (CouvertureAssociee.oui, NSLocalizedString("Oui", comment: "Couverture associée Oui")),
            (CouvertureAssociee.non, NSLocalizedString("Non", comment: "Couverture associée Non"))
        ]
    }
}

enum CouvertureDerobee {
    case oui
    case non

    static func getValue() -> [(CouvertureDerobee, String)] {
        [
            (CouvertureDerobee.oui, NSLocalizedString("Oui", comment: "Couverture dérobée Oui")),
            (CouvertureDerobee.non, NSLocalizedString("Non", comment: "Couverture dérobée Non"))
        ]
    }
}

enum DrainageSouterrain {
    case systematique
    case partiel
    case absent

    static func getValue() -> [(DrainageSouterrain, String)] {
        [
            (DrainageSouterrain.systematique, NSLocalizedString("Systématique", comment: "Drainage souterrain Systématique")),
            (DrainageSouterrain.partiel, NSLocalizedString("Partiel", comment: "Drainage souterrain Partiel")),
            (DrainageSouterrain.absent, NSLocalizedString("Absent", comment: "Drainage souterrain absent"))
        ]
    }
}

enum DrainageSurface {
    case bon
    case moyen
    case mauvais

    static func getValue() -> [(DrainageSurface, String)] {
        [
            (DrainageSurface.bon, NSLocalizedString("Bon", comment: "Drainage de surface Bon")),
            (DrainageSurface.moyen, NSLocalizedString("Moyen", comment: "Drainage de surface Moyen")),
            (DrainageSurface.mauvais, NSLocalizedString("Mauvais", comment: "Drainage de surface Mauvais"))
        ]
    }
}

enum ConditionProfilCultural {
    case bonne
    case presenceZoneRisques
    case dominanceZoneRisque

    static func getValue() -> [(ConditionProfilCultural, String)] {
        [
            (ConditionProfilCultural.bonne, NSLocalizedString("Bonne", comment: "Condition du profil cultural Bonne")),
            (ConditionProfilCultural.presenceZoneRisques, NSLocalizedString("Présence de zone à risque", comment: "Condition du profil cultural Présence de zone à risque")),
            (ConditionProfilCultural.dominanceZoneRisque, NSLocalizedString("Dominance de zone à risque", comment: "Condition du profil cultural Dominance de zone à risque"))
        ]
    }
}

typealias KilogramPerHectare = Double
typealias Percentage = Int
