//
//  CulturalPractice.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-02-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct CulturalPractice {
    var avaloir: Avaloir?
    var bandeRiveraine: BandeRiveraine?
    var doseFumier: [DoseFumier]?
    var periodeApplicationFumier: PeriodeApplicationFumier?
    var delaiIncorporationFumier: DelaiIncorporationFumier?
    var travailSol: TravailSol?
    var couvertureAssociee: CouvertureAssociee?
    var couvertureDerobee: CouvertureDerobee?
    var drainageSouterrain: DrainageSouterrain?
    var drainageSurface: DrainageSurface?
    var conditionProfilCultural: ConditionProfilCultural?
    var tauxApplicationPhosphoreRang: TauxApplicationPhosphoreRang?
    var tauxApplicationPhosphoreVolee: TauxApplicationPhosphoreVolee?
    var pMehlich3: PMehlich3?
    var alMehlich3: AlMehlich3?
    var cultureAnneeEnCoursAnterieure: CultureAnneeEnCoursAnterieure?
    
    static func getCulturalPracticeType(culturalPractice: CulturalPractice) -> [CulturalPracticeType] {
        [
            CulturalPracticeType.culturalPracticeMultiSelect(
                CulturalPracticeMultiSelect(
                    key: Avaloir.getKey(),
                    title: Avaloir.getTitle(),
                    tupleCulturalTypeValue: Avaloir.getValues(),
                    value: culturalPractice.avaloir != nil
                        ? CulturalPracticeMultiSelectType.avaloir(culturalPractice.avaloir!)
                        : nil
                )
            ),
            CulturalPracticeType.culturalPracticeMultiSelect(
                CulturalPracticeMultiSelect(
                    key: BandeRiveraine.getKey(),
                    title: BandeRiveraine.getTitle(),
                    tupleCulturalTypeValue: BandeRiveraine.getValues(),
                    value: culturalPractice.bandeRiveraine != nil
                        ? CulturalPracticeMultiSelectType
                            .bandeRiveraine(culturalPractice.bandeRiveraine!)
                        : nil
                )
            ),
            CulturalPracticeType.culturalPracticeMultiSelect(
                CulturalPracticeMultiSelect(
                    key: TravailSol.getKey(),
                    title: TravailSol.getTitle(),
                    tupleCulturalTypeValue: TravailSol.getValues(),
                    value: culturalPractice.travailSol != nil
                        ? CulturalPracticeMultiSelectType
                            .travailSol(culturalPractice.travailSol!)
                        : nil
                )
            ),
            CulturalPracticeType.culturalPracticeMultiSelect(
                CulturalPracticeMultiSelect(
                    key: CouvertureAssociee.getKey(),
                    title: CouvertureAssociee.getTitle(),
                    tupleCulturalTypeValue: CouvertureAssociee.getValues(),
                    value: culturalPractice.couvertureAssociee != nil
                        ? CulturalPracticeMultiSelectType
                            .couvertureAssociee(culturalPractice.couvertureAssociee!)
                        : nil
                )
            ),
            CulturalPracticeType.culturalPracticeMultiSelect(
                CulturalPracticeMultiSelect(
                    key: CouvertureDerobee.getKey(),
                    title: CouvertureDerobee.getTitle(),
                    tupleCulturalTypeValue: CouvertureDerobee.getValues(),
                    value: culturalPractice.couvertureDerobee != nil
                        ? CulturalPracticeMultiSelectType
                            .couvertureDerobee(culturalPractice.couvertureDerobee!)
                        : nil
                )
            ),
            
            CulturalPracticeType.culturalPracticeMultiSelect(
                CulturalPracticeMultiSelect(
                    key: DrainageSouterrain.getKey(),
                    title: DrainageSouterrain.getTitle(),
                    tupleCulturalTypeValue: DrainageSouterrain.getValues()
                )
            ),
            CulturalPracticeType.culturalPracticeMultiSelect(
                CulturalPracticeMultiSelect(
                    key: DrainageSurface.getKey(),
                    title: DrainageSurface.getTitle(),
                    tupleCulturalTypeValue: DrainageSurface.getValues()
                )
            ),
            CulturalPracticeType.culturalPracticeMultiSelect(
                CulturalPracticeMultiSelect(
                    key: ConditionProfilCultural.getKey(),
                    title: ConditionProfilCultural.getTitle(),
                    tupleCulturalTypeValue: ConditionProfilCultural.getValues()
                )
            ),
            CulturalPracticeType.culturalPracticeMultiSelect(
                CulturalPracticeMultiSelect(
                    key: ConditionProfilCultural.getKey(),
                    title: CultureAnneeEnCoursAnterieure.getTitle(),
                    tupleCulturalTypeValue: CultureAnneeEnCoursAnterieure.getValues()
                )
            ),
            CulturalPracticeType.culturalPracticeInput(
                CulturalPracticeInput(
                    key: TauxApplicationPhosphoreRang.getKey(),
                    titleInput: TauxApplicationPhosphoreRang.getTitle()
                )
            ),
            CulturalPracticeType.culturalPracticeInput(
                CulturalPracticeInput(
                    key: TauxApplicationPhosphoreVolee.getKey(),
                    titleInput: TauxApplicationPhosphoreVolee.getTitle()
                )
            ),
            CulturalPracticeType.culturalPracticeInput(
                CulturalPracticeInput(
                    key: PMehlich3.getKey(),
                    titleInput: PMehlich3.getTitle()
                )
            ),
            CulturalPracticeType.culturalPracticeInput(
                CulturalPracticeInput(
                    key: AlMehlich3.getKey(),
                    titleInput: AlMehlich3.getTitle()
                )
            ),
            CulturalPracticeType.culturalPracticeDynamic(
                CulturalPracticeDynamic(
                    key: KeyCulturalPracticeDynamic.doseFumier,
                    title: DoseFumier.getTitle()
                )
            )
        ]
    }
    
    static func getCulturalPracticeDynamic() -> [CulturalPracticeDynamic] {
        
    }
}

enum CulturalPracticeMultiSelectType {
    case avaloir(Avaloir)
    case bandeRiveraine(BandeRiveraine)
    case periodeApplicationFumier(PeriodeApplicationFumier)
    case delaiIncorporationFumier(DelaiIncorporationFumier)
    case travailSol(TravailSol)
    case couvertureAssociee(CouvertureAssociee)
    case couvertureDerobee(CouvertureDerobee)
    case drainageSouterrain(DrainageSouterrain)
    case drainageSurface(DrainageSurface)
    case conditionProfilCultural(ConditionProfilCultural)
    case cultureAnneeEnCoursAnterieure(CultureAnneeEnCoursAnterieure)
}

enum CulturalPracticeValueType {
    case doseFumier(DoseFumier)
}

enum KeyCulturalPractice {
    case avaloir
    case bandeRiveraine
    case travailSol
    case couvertureAssociee
    case couvertureDerobee
    case drainageSouterrain
    case drainageSurface
    case conditionProfilCultural
    case cultureAnneeEnCoursAnterieure
    case doseFumier(id: Int)
    case periodeApplicationFumier(id: Int)
    case delaiIncorporationFumier(id: Int)
    case tauxApplicationPhosphoreRang
    case tauxApplicationPhosphoreVolee
    case pMehlich3
    case alMehlich3
}

enum KeyCulturalPracticeDynamic {
    case doseFumier
}

enum Avaloir: Int {
    case absente = 1
    case captagePartiel
    case captageSystematique

    static func getValues() -> [(CulturalPracticeMultiSelectType, String)] {
        [
            (
                CulturalPracticeMultiSelectType.avaloir(Avaloir.absente),
                NSLocalizedString("Absente", comment: "Avaloir absente")
            ),
            (
                CulturalPracticeMultiSelectType.avaloir(Avaloir.captagePartiel),
                NSLocalizedString("Captage Partiel", comment: "Avaloir captage partiel")
            ),
            (
                CulturalPracticeMultiSelectType.avaloir(Avaloir.captageSystematique),
                NSLocalizedString("Captage systématique", comment: "Avaloir Captage systématique")
            )
        ]
    }
    
    static func getTitle() -> String {
        NSLocalizedString("Avaloir", comment: "Titre avaloir")
    }
    
    static func getKey() -> KeyCulturalPractice {
        KeyCulturalPractice.avaloir
    }
}

enum BandeRiveraine: Int {
    case pasApplique = 1
    case inferieura1M
    case de1A3M
    case de4MEtPlus

    static func getValues() -> [(CulturalPracticeMultiSelectType, String)] {
        [
            (
                CulturalPracticeMultiSelectType.bandeRiveraine(BandeRiveraine.pasApplique),
                NSLocalizedString("Ne s'applique pas", comment: "Bande riveraine ne s'applique pas")
            ),
            (
                CulturalPracticeMultiSelectType.bandeRiveraine(BandeRiveraine.inferieura1M),
                NSLocalizedString("Inférieur à 1m", comment: "Bande riveraine Inférieur à 1m")
            ),
            (
                CulturalPracticeMultiSelectType.bandeRiveraine(BandeRiveraine.de1A3M),
                NSLocalizedString("1 à 3m", comment: "Bande riveraine 4m et plus")
            ),
            (
                CulturalPracticeMultiSelectType.bandeRiveraine(BandeRiveraine.de4MEtPlus),
                NSLocalizedString("4m et plus", comment: "Bande riveraine 4m et plus")
            )
        ]
    }
    
    static func getTitle() -> String {
        NSLocalizedString("Bande riveraine", comment: "Titre bande riveraine")
    }
    
    static func getKey() -> KeyCulturalPractice {
        KeyCulturalPractice.bandeRiveraine
    }
}

enum DoseFumier {
    case dose(
        quantite: Int,
        periodeApplicationFumier: PeriodeApplicationFumier,
        delaiIncorporationFumier: DelaiIncorporationFumier
    )
    
    static func getTitle() -> String {
        NSLocalizedString(
            "Dose du fumier (jusqu'à trois doses)",
            comment: "TitreDose du fumier (jusqu'à trois doses)"
        )
    }
    
    static func getKey(id: Int) -> KeyCulturalPractice {
        KeyCulturalPractice.doseFumier(id: id)
    }
}

enum PeriodeApplicationFumier: Int {
    case preSemi = 1
    case postLevee
    case automneHatif
    case automneTardif

    static func getValues() -> [(CulturalPracticeMultiSelectType, String)] {
        [
            (
                CulturalPracticeMultiSelectType
                    .periodeApplicationFumier(PeriodeApplicationFumier.preSemi),
                NSLocalizedString(
                    "Pré-semi",
                    comment: "Periode d'application du fumier Pré-semi"
                )
            ),
            (
                CulturalPracticeMultiSelectType
                    .periodeApplicationFumier(PeriodeApplicationFumier.postLevee),
                NSLocalizedString(
                    "Post-levée",
                    comment: "Periode d'application du fumier Post-levée"
                )
            ),
            (
                CulturalPracticeMultiSelectType
                    .periodeApplicationFumier(PeriodeApplicationFumier.automneHatif),
                NSLocalizedString(
                    "Automne hâtif",
                    comment: "Periode d'application du fumier Automne hâtif"
                )
            ),
            (
                CulturalPracticeMultiSelectType
                    .periodeApplicationFumier(PeriodeApplicationFumier.automneTardif),
                NSLocalizedString(
                    "Automne tardif",
                    comment: "Periode d'application du fumier Automne tardif"
                )
            )
        ]
    }
    
    static func getTitle() -> String {
        NSLocalizedString(
            "Période d'application du fumier (jusqu'à trois application)",
            comment: "Titre Période d'application du fumier (jusqu'à trois application)"
        )
    }
    
    static func getKey(id: Int) -> KeyCulturalPractice {
        KeyCulturalPractice.periodeApplicationFumier(id: id)
    }
}

enum DelaiIncorporationFumier: Int {
    case incorporeEn48H = 1
    case incorporeEn48HA1Semaine
    case superieureA1Semaine
    case nonIncorpore

    static func getValues() -> [(CulturalPracticeMultiSelectType, String)] {
        [
            (
                CulturalPracticeMultiSelectType
                    .delaiIncorporationFumier(DelaiIncorporationFumier.incorporeEn48H),
                NSLocalizedString(
                    "Incorporé en 48h",
                    comment: "Delai d'incorporation du fumier Incorporé en 48h"
                )
            ),
            (
                CulturalPracticeMultiSelectType
                    .delaiIncorporationFumier(DelaiIncorporationFumier.incorporeEn48HA1Semaine),
                NSLocalizedString(
                    "Incorporé en 48h à 1 semaine",
                    comment: "Delai d'incorporation du fumier Incorporé en 48h à 1 semaine"
                )
            ),
            (
                CulturalPracticeMultiSelectType
                    .delaiIncorporationFumier(DelaiIncorporationFumier.superieureA1Semaine),
                NSLocalizedString(
                    "Supérieur à 1 semaine",
                    comment: "Delai d'incorporation du fumier Supérieur à 1 semaine"
                )
            ),
            (
                CulturalPracticeMultiSelectType
                    .delaiIncorporationFumier(DelaiIncorporationFumier.nonIncorpore),
                NSLocalizedString(
                    "Non incorporé",
                    comment: "Delai d'incorporation du fumier Non incorporé"
                )
            )
        ]
    }
    
    static func getTitle() -> String {
        NSLocalizedString(
            "Délai d'incorporation du fumier (jusqu'à trois application)",
            comment: "Title délai d'incorporation du fumier (jusqu'à trois application)"
        )
    }
    
    static func getKey(id: Int) -> KeyCulturalPractice {
        KeyCulturalPractice.delaiIncorporationFumier(id: id)
    }
}

enum TravailSol: Int {
    case labourAutomneTravailSecondairePrintemps = 1
    case chiselPulverisateurAutomneTravailSecondairePrintemps
    case dechaumageAuPrintempsTravailSecondairePrintemps
    case semiDirectOuBilons

    static func getValues() -> [(CulturalPracticeMultiSelectType, String)] {
        [
            (
                CulturalPracticeMultiSelectType
                    .travailSol(TravailSol.labourAutomneTravailSecondairePrintemps),
                NSLocalizedString(
                    "Labour à l'automne, travail secondaire au printemps",
                    comment: "Travail du sol Labour à l'automne"
                )
            ),
            (
                CulturalPracticeMultiSelectType
                    .travailSol(TravailSol.chiselPulverisateurAutomneTravailSecondairePrintemps),
                NSLocalizedString(
                    "Chisel ou pulvérisateur à l'automne, travail secondaire au printemps",
                    comment: "Travail du sol Chisel ou pulvérisateur à l'automne, travail secondaire au printemps"
                )
            ),
            (
                CulturalPracticeMultiSelectType
                    .travailSol(TravailSol.dechaumageAuPrintempsTravailSecondairePrintemps),
                NSLocalizedString(
                "Déchaumage au printemps et travail secondaire au printemps",
                comment: "Travail du sol Déchaumage au printemps et travail secondaire au printemps"
                )
            ),
            (
                CulturalPracticeMultiSelectType
                    .travailSol(TravailSol.semiDirectOuBilons),
                NSLocalizedString(
                    "Semi direct ou bilons",
                    comment: "Travail du sol Semi direct ou bilons"
                )
            )
        ]
    }
    
    static func getTitle() -> String {
        NSLocalizedString("Travail du sol", comment: "Title travail du sol")
    }
    
    static func getKey() -> KeyCulturalPractice {
        KeyCulturalPractice.travailSol
    }
}

enum CouvertureAssociee: Int {
    case vrai = 1
    case faux = 0

    static func getValues() -> [(CulturalPracticeMultiSelectType, String)] {
        [
            (
                CulturalPracticeMultiSelectType
                    .couvertureAssociee(CouvertureAssociee.vrai),
                NSLocalizedString("Vrai", comment: "Couverture associée vrai")
            ),
            (
                CulturalPracticeMultiSelectType
                    .couvertureAssociee(CouvertureAssociee.faux),
                NSLocalizedString("Faux", comment: "Couverture associée faux")
            )
        ]
    }
    
    static func getTitle() -> String {
        NSLocalizedString(
            "Couverture associée",
            comment: "Title couverture associée"
        )
    }
    
    static func getKey() -> KeyCulturalPractice {
        KeyCulturalPractice.couvertureAssociee
    }
}

enum CouvertureDerobee: Int {
    case vrai = 1
    case faux = 0

    static func getValues() -> [(CulturalPracticeMultiSelectType, String)] {
        [
            (
                CulturalPracticeMultiSelectType
                    .couvertureDerobee(CouvertureDerobee.vrai),
                NSLocalizedString("Vrai", comment: "Couverture dérobée vrai")
            ),
            (
                CulturalPracticeMultiSelectType
                    .couvertureDerobee(CouvertureDerobee.faux),
                NSLocalizedString("Faux", comment: "Couverture dérobée faux")
            )
        ]
    }
    
    static func getTitle() -> String {
        NSLocalizedString(
            "Couverture dérobée",
            comment: "Title Couverture dérobée"
        )
    }
    
    static func getKey() -> KeyCulturalPractice {
        KeyCulturalPractice.couvertureDerobee
    }
}

enum DrainageSouterrain: Int {
    case systematique = 1
    case partiel
    case absent

    static func getValues() -> [(CulturalPracticeMultiSelectType, String)] {
        [
            (
                CulturalPracticeMultiSelectType
                    .drainageSouterrain(DrainageSouterrain.systematique),
                NSLocalizedString("Systématique", comment: "Drainage souterrain Systématique")
            ),
            (
                CulturalPracticeMultiSelectType
                    .drainageSouterrain(DrainageSouterrain.partiel),
                NSLocalizedString("Partiel", comment: "Drainage souterrain Partiel")
            ),
            (
                CulturalPracticeMultiSelectType
                    .drainageSouterrain(DrainageSouterrain.absent),
                NSLocalizedString("Absent", comment: "Drainage souterrain absent")
            )
        ]
    }
    
    static func getTitle() -> String {
        NSLocalizedString(
            "Drainage souterrain",
            comment: "Title Drainage souterrain"
        )
    }
    
    static func getKey() -> KeyCulturalPractice {
        KeyCulturalPractice.drainageSouterrain
    }
    
}

enum DrainageSurface: Int {
    case bon = 1
    case moyen
    case mauvais

    static func getValues() -> [(CulturalPracticeMultiSelectType, String)] {
        [
            (
                CulturalPracticeMultiSelectType
                    .drainageSurface(DrainageSurface.bon),
                NSLocalizedString("Bon", comment: "Drainage de surface Bon")
            ),
            (
                CulturalPracticeMultiSelectType
                    .drainageSurface(DrainageSurface.moyen),
                NSLocalizedString("Moyen", comment: "Drainage de surface Moyen")
            ),
            (
                CulturalPracticeMultiSelectType
                    .drainageSurface(DrainageSurface.mauvais),
                NSLocalizedString("Mauvais", comment: "Drainage de surface Mauvais")
            )
        ]
    }
    
    static func getTitle() -> String {
        NSLocalizedString("Drainage de surface", comment: "Titre Drainage de surface")
    }
    
    static func getKey() -> KeyCulturalPractice {
        KeyCulturalPractice.drainageSurface
    }
}

enum ConditionProfilCultural {
    case bonne
    case presenceZoneRisques
    case dominanceZoneRisque

    static func getValues() -> [(CulturalPracticeMultiSelectType, String)] {
        [
            (
                CulturalPracticeMultiSelectType
                    .conditionProfilCultural(ConditionProfilCultural.bonne),
                NSLocalizedString(
                    "Bonne",
                    comment: "Condition du profil cultural Bonne"
                )
            ),
            (
                CulturalPracticeMultiSelectType
                    .conditionProfilCultural(ConditionProfilCultural.presenceZoneRisques),
                NSLocalizedString(
                    "Présence de zone à risque",
                    comment: "Condition du profil cultural Présence de zone à risque"
                )
            ),
            (
                CulturalPracticeMultiSelectType
                    .conditionProfilCultural(ConditionProfilCultural.dominanceZoneRisque),
                NSLocalizedString(
                    "Dominance de zone à risque",
                    comment: "Condition du profil cultural Dominance de zone à risque"
                )
            )
        ]
    }
    
    static func getTitle() -> String {
        NSLocalizedString(
            "Condition du profil cultural",
            comment: "Condition du profil cultural"
        )
    }
    
    static func getKey() -> KeyCulturalPractice {
        KeyCulturalPractice.conditionProfilCultural
    }
}

enum TauxApplicationPhosphoreRang {
    case taux(KilogramPerHectare)
    
    static func getTitle() -> String {
        NSLocalizedString(
            "Taux d'application de phosphore (engrais minéraux en rang)",
            comment: "Titre Taux d'application de phosphore (engrais minéraux en rang)"
        )
    }
    
    static func getKey() -> KeyCulturalPractice {
        KeyCulturalPractice.tauxApplicationPhosphoreRang
    }
}

enum TauxApplicationPhosphoreVolee {
    case taux(KilogramPerHectare)
    
    static func getTitle() -> String {
        NSLocalizedString(
            "Taux d'application de phosphore (engrais minéraux à la volée)",
            comment: "Titre Taux d'application de phosphore (engrais minéraux à la volée)"
        )
    }
    
    static func getKey() -> KeyCulturalPractice {
        KeyCulturalPractice.tauxApplicationPhosphoreVolee
    }
}

enum PMehlich3 {
    case taux(KilogramPerHectare)
    
    static func getTitle() -> String {
        NSLocalizedString(
            "P Mehlich-3",
            comment: "Titre P Mehlich-3"
        )
    }
    
    static func getKey() -> KeyCulturalPractice {
        KeyCulturalPractice.pMehlich3
    }
}

enum AlMehlich3 {
    case taux(Percentage)
    
    static func getTitle() -> String {
        NSLocalizedString(
            "AL Mehlich-3",
            comment: "AL Mehlich-3"
        )
    }
    
    static func getKey() -> KeyCulturalPractice {
        KeyCulturalPractice.alMehlich3
    }
}

enum CultureAnneeEnCoursAnterieure {
    case auc
    case avo
    case ble
    case cnl
    case foi
    case mai
    case mix
    case non
    case org
    case ptf
    case soy
    
    static func getValues() -> [(CulturalPracticeMultiSelectType, String)] {
        [
            (
                CulturalPracticeMultiSelectType
                    .cultureAnneeEnCoursAnterieure(CultureAnneeEnCoursAnterieure.auc),
                NSLocalizedString("Autres céréales", comment: "Autres céréales")
            ),
            (
                CulturalPracticeMultiSelectType
                    .cultureAnneeEnCoursAnterieure(CultureAnneeEnCoursAnterieure.avo),
                NSLocalizedString("Avoine", comment: "Avoine")
            ),
            (
                CulturalPracticeMultiSelectType
                    .cultureAnneeEnCoursAnterieure(CultureAnneeEnCoursAnterieure.ble),
                NSLocalizedString("Blé", comment: "Blé")
            ),
            (
                CulturalPracticeMultiSelectType
                    .cultureAnneeEnCoursAnterieure(CultureAnneeEnCoursAnterieure.cnl),
                NSLocalizedString("Canola", comment: "Canola")
            ),
            (
                CulturalPracticeMultiSelectType
                    .cultureAnneeEnCoursAnterieure(CultureAnneeEnCoursAnterieure.foi),
                NSLocalizedString("Foin", comment: "Foin")
            ),
            (
                CulturalPracticeMultiSelectType
                    .cultureAnneeEnCoursAnterieure(CultureAnneeEnCoursAnterieure.mai),
                NSLocalizedString("Maï", comment: "Maï")
            ),
            (
                CulturalPracticeMultiSelectType
                    .cultureAnneeEnCoursAnterieure(CultureAnneeEnCoursAnterieure.mix),
                NSLocalizedString("Mixte", comment: "Mixte")
            ),
            (
                CulturalPracticeMultiSelectType
                    .cultureAnneeEnCoursAnterieure(CultureAnneeEnCoursAnterieure.non),
                NSLocalizedString(
                    "Pas d'info, traité comme si c'était du foin",
                    comment: "Pas d'info, traité comme si c'était du foin"
                )
            ),
            (
                CulturalPracticeMultiSelectType
                    .cultureAnneeEnCoursAnterieure(CultureAnneeEnCoursAnterieure.org),
                NSLocalizedString("Orge", comment: "Orge")
            ),
            (
                CulturalPracticeMultiSelectType
                    .cultureAnneeEnCoursAnterieure(CultureAnneeEnCoursAnterieure.ptf),
                NSLocalizedString("Petits fruits", comment: "Petits fruits")
            ),
            (
                CulturalPracticeMultiSelectType
                    .cultureAnneeEnCoursAnterieure(CultureAnneeEnCoursAnterieure.soy),
                NSLocalizedString("Soya", comment: "Soya")
            ),
        ]
    }
    
    static func getTitle() -> String {
        NSLocalizedString(
            "Culture de l'année en cours et antérieure",
            comment: "Titre Culture de l'année en cours et antérieure"
        )
    }
    
    static func getKey() -> KeyCulturalPractice {
        KeyCulturalPractice.cultureAnneeEnCoursAnterieure
    }
}

typealias KilogramPerHectare = Double
typealias Percentage = Int

struct CulturalPracticeMultiSelect {
    let key: KeyCulturalPractice
    var title: String
    var tupleCulturalTypeValue: [(CulturalPracticeMultiSelectType, String)]
    var value: CulturalPracticeMultiSelectType?
}

struct CulturalPracticeDynamic {
    let key: KeyCulturalPracticeDynamic
    let title: String
}

struct CulturalPracticeInputMultiSelect {
    let title: String
    let titleInput: [CulturalPracticeInput]
    let culturalPracticeMultiSelect: [CulturalPracticeMultiSelect]
}

struct CulturalPracticeInput {
    let key: KeyCulturalPractice
    let titleInput: String
    var value: Any?
}

enum CulturalPracticeType {
    case culturalPracticeMultiSelect(CulturalPracticeMultiSelect)
    case culturalPracticeDynamic(CulturalPracticeDynamic)
    case culturalPracticeInput(CulturalPracticeInput)
}
