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
    var periodeApplicationFumier: [PeriodeApplicationFumier]?
    var delaiIncorporationFumier: [DelaiIncorporationFumier]?

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

    static let MAX_DOSE_FUMIER = 3

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> [CulturalPracticeElementProtocol] {
        let culturalPracticeSingleElement = getCulturalPracticeSingleElement(from: culturalPractice)
        let culturalPracticeContainerElement = getCulturalPracticeDynamic(from: culturalPractice)

        if culturalPracticeContainerElement != nil {
            return culturalPracticeSingleElement + culturalPracticeContainerElement!
        }

        return culturalPracticeSingleElement
    }

    private static func getCulturalPracticeSingleElement(
        from culturalPractice: CulturalPractice?
    ) -> [CulturalPracticeElementProtocol] {
        [
            Avaloir.getCulturalPracticeElement(culturalPractice: culturalPractice),
            BandeRiveraine.getCulturalPracticeElement(culturalPractice: culturalPractice),
            TravailSol.getCulturalPracticeElement(culturalPractice: culturalPractice),
            CouvertureAssociee.getCulturalPracticeElement(culturalPractice: culturalPractice),
            CouvertureDerobee.getCulturalPracticeElement(culturalPractice: culturalPractice),
            DrainageSouterrain.getCulturalPracticeElement(culturalPractice: culturalPractice),
            DrainageSurface.getCulturalPracticeElement(culturalPractice: culturalPractice),
            ConditionProfilCultural.getCulturalPracticeElement(culturalPractice: culturalPractice),
            CultureAnneeEnCoursAnterieure.getCulturalPracticeElement(culturalPractice: culturalPractice),
            TauxApplicationPhosphoreRang.getCulturalPracticeElement(culturalPractice: culturalPractice),
            TauxApplicationPhosphoreVolee.getCulturalPracticeElement(culturalPractice: culturalPractice),
            PMehlich3.getCulturalPracticeElement(culturalPractice: culturalPractice),
            AlMehlich3.getCulturalPracticeElement(culturalPractice: culturalPractice),
            createCulturalPracticeAddElement(
                title: NSLocalizedString(
                    "Ajouter une dose du fumier",
                    comment: "Title Ajouter une dose du fumier"
                ),
                key: UUID().uuidString
            )
        ]
    }

    static func createCulturalPracticeInputMultiSelectContainer(index: Int) -> CulturalPracticeElementProtocol {
        CulturalPracticeInputMultiSelectContainer(
            key: UUID().uuidString,
            title: "Dose fumier \(index + 1)",
            culturalInputElement: [
                DoseFumier.getCulturalPracticeElement(id: index, culturalPractice: nil)
            ],
            culturalPracticeMultiSelectElement: [
                PeriodeApplicationFumier.getCulturalPracticeElement(id: index, culturalPractice: nil),
                DelaiIncorporationFumier.getCulturalPracticeElement(id: index, culturalPractice: nil)
            ]
        )
    }

    private static func getCulturalPracticeDynamic(from culturalPractice: CulturalPractice?) -> [CulturalPracticeElementProtocol]? {
        guard let culturalPractice = culturalPractice else {
            return nil
        }

        var culturalPracticeElements: [CulturalPracticeElementProtocol] = []

        (0...(MAX_DOSE_FUMIER - 1)).forEach { index in
            if hasValueDoseFumier(culturalPractice: culturalPractice, index: index) {
                let culturalPracticeInputMultiSelectContainer =
                    CulturalPracticeInputMultiSelectContainer(
                        key: UUID().uuidString,
                        title: "Dose fumier \(index + 1)",
                        culturalInputElement: [
                            DoseFumier.getCulturalPracticeElement(id: index, culturalPractice: culturalPractice)
                        ],
                        culturalPracticeMultiSelectElement: [
                            PeriodeApplicationFumier.getCulturalPracticeElement(id: index, culturalPractice: culturalPractice),
                            DelaiIncorporationFumier.getCulturalPracticeElement(id: index, culturalPractice: culturalPractice)
                        ]
                )

                culturalPracticeElements.append(culturalPracticeInputMultiSelectContainer)
            }
        }

        return !(culturalPracticeElements.isEmpty) ? culturalPracticeElements : nil
    }

    private static func hasValueDoseFumier(culturalPractice: CulturalPractice, index: Int) -> Bool {
        let countDoseFumier = culturalPractice.doseFumier?.count ?? -1
        let countPeriodeApplicationFumier = culturalPractice.periodeApplicationFumier?.count ?? -1
        let countDelaiIncorporationFumier = culturalPractice.delaiIncorporationFumier?.count ?? -1

        return countDoseFumier > index ||
            countDelaiIncorporationFumier > index ||
            countPeriodeApplicationFumier > index
    }

    private static func createCulturalPracticeAddElement(
        title: String,
        key: String
    ) -> CulturalPracticeElementProtocol {
        CulturalPracticeAddElement(
            key: key,
            title: title
        )
    }
}

enum Avaloir: Int, CulturalPracticeValueProtocol {
    case absente = 1
    case captagePartiel
    case captageSystematique

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        [
            (
                Avaloir.absente,
                NSLocalizedString("Absente", comment: "Avaloir absente")
            ),
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

    func getValue() -> String {
        switch self {
        case .absente:
            return NSLocalizedString("Absente", comment: "Avaloir absente")
        case .captagePartiel:
            return NSLocalizedString("Captage Partiel", comment: "Avaloir captage partiel")
        case .captageSystematique:
            return NSLocalizedString("Captage systématique", comment: "Avaloir Captage systématique")
        }
    }

    static func getTitle() -> String {
        NSLocalizedString("Avaloir", comment: "Titre avaloir")
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        CulturalPracticeMultiSelectElement(
            key: UUID().uuidString,
            title: Avaloir.getTitle(),
            tupleCulturalTypeValue: Avaloir.getValues()!,
            value: culturalPractice?.avaloir
        )
    }

    func getUnitType() -> UnitType? {
        nil
    }

    static func create(value: String) -> CulturalPracticeValueProtocol? {
        nil
    }

    static func getRegularExpression() -> String? {
        nil
    }
}

enum BandeRiveraine: Int, CulturalPracticeValueProtocol {
    case pasApplique = 1
    case inferieura1M
    case de1A3M
    case de4MEtPlus

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
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

    static func getTitle() -> String {
        NSLocalizedString("Bande riveraine", comment: "Titre bande riveraine")
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        CulturalPracticeMultiSelectElement(
            key: UUID().uuidString,
            title: BandeRiveraine.getTitle(),
            tupleCulturalTypeValue: BandeRiveraine.getValues()!,
            value: culturalPractice?.bandeRiveraine
        )
    }

    func getValue() -> String {
        switch self {
        case .pasApplique:
            return NSLocalizedString("Ne s'applique pas", comment: "Bande riveraine ne s'applique pas")
        case .inferieura1M:
            return NSLocalizedString("Inférieur à 1m", comment: "Bande riveraine Inférieur à 1m")
        case .de1A3M:
            return NSLocalizedString("1 à 3m", comment: "Bande riveraine 4m et plus")
        case .de4MEtPlus:
            return NSLocalizedString("4m et plus", comment: "Bande riveraine 4m et plus")
        }
    }

    func getUnitType() -> UnitType? {
        nil
    }

    static func create(value: String) -> CulturalPracticeValueProtocol? {
        nil
    }

    static func getRegularExpression() -> String? {
        nil
    }
}

enum DoseFumier: CulturalPracticeValueProtocol {

    case dose(quantite: Int)

    static func getTitle() -> String {
        NSLocalizedString(
            "Dose du fumier (quantité)",
            comment: "Dose du fumier (quantité)"
        )
    }

    func getValue() -> String {
        switch self {
        case .dose(quantite: let quantite):
            return String(quantite)
        }
    }

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        return nil
    }

    static func getCulturalPracticeElement(id: Int, culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        let count = culturalPractice?.doseFumier?.count ?? -1

        let doseFumier = count > id
            ? culturalPractice!.doseFumier![id]
            : nil

        return CulturalPracticeInputElement(
            key: UUID().uuidString,
            title: getTitle(),
            valueEmpty: DoseFumier.dose(quantite: 0),
            value: doseFumier,
            index: id
        )
    }

    func getUnitType() -> UnitType? {
        .quantity
    }

    static func create(value: String) -> CulturalPracticeValueProtocol? {
        guard let quantityValue = Int(value) else { return nil }
        return DoseFumier.dose(quantite: quantityValue)
    }

    static func getRegularExpression() -> String? {
        "^\\d*$"
    }
}

enum PeriodeApplicationFumier: Int, CulturalPracticeValueProtocol {
    case preSemi = 1
    case postLevee
    case automneHatif
    case automneTardif

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        [
            (
                PeriodeApplicationFumier.preSemi,
                NSLocalizedString(
                    "Pré-semi",
                    comment: "Periode d'application du fumier Pré-semi"
                )
            ),
            (
                PeriodeApplicationFumier.postLevee,
                NSLocalizedString(
                    "Post-levée",
                    comment: "Periode d'application du fumier Post-levée"
                )
            ),
            (
                PeriodeApplicationFumier.automneHatif,
                NSLocalizedString(
                    "Automne hâtif",
                    comment: "Periode d'application du fumier Automne hâtif"
                )
            ),
            (
                PeriodeApplicationFumier.automneTardif,
                NSLocalizedString(
                    "Automne tardif",
                    comment: "Periode d'application du fumier Automne tardif"
                )
            )
        ]
    }

    func getValue() -> String {
        switch self {
        case .preSemi:
            return NSLocalizedString(
                "Pré-semi",
                comment: "Periode d'application du fumier Pré-semi"
            )
        case .postLevee:
            return NSLocalizedString(
                "Post-levée",
                comment: "Periode d'application du fumier Post-levée"
            )
        case .automneHatif:
            return NSLocalizedString(
                "Automne hâtif",
                comment: "Periode d'application du fumier Automne hâtif"
            )
        case .automneTardif:
            return NSLocalizedString(
                "Automne tardif",
                comment: "Periode d'application du fumier Automne tardif"
            )
        }
    }

    static func getTitle() -> String {
        NSLocalizedString(
            "Période d'application du fumier (jusqu'à trois application)",
            comment: "Titre Période d'application du fumier (jusqu'à trois application)"
        )
    }

    static func getCulturalPracticeElement(id: Int, culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        let count = culturalPractice?.periodeApplicationFumier?.count ?? -1
        let periodeApplicationFumier = count > id
            ? culturalPractice!.periodeApplicationFumier![id]
            : nil

        return CulturalPracticeMultiSelectElement(
            key: UUID().uuidString,
            title: getTitle(),
            tupleCulturalTypeValue: getValues()!,
            value: periodeApplicationFumier,
            index: id
        )
    }

    func getUnitType() -> UnitType? {
        nil
    }

    static func create(value: String) -> CulturalPracticeValueProtocol? {
        nil
    }

    static func getRegularExpression() -> String? {
        nil
    }
}

enum DelaiIncorporationFumier: Int, CulturalPracticeValueProtocol {

    case incorporeEn48H = 1
    case incorporeEn48HA1Semaine
    case superieureA1Semaine
    case nonIncorpore

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        [
            (
                DelaiIncorporationFumier.incorporeEn48H,
                NSLocalizedString(
                    "Incorporé en 48h",
                    comment: "Delai d'incorporation du fumier Incorporé en 48h"
                )
            ),
            (
                DelaiIncorporationFumier.incorporeEn48HA1Semaine,
                NSLocalizedString(
                    "Incorporé en 48h à 1 semaine",
                    comment: "Delai d'incorporation du fumier Incorporé en 48h à 1 semaine"
                )
            ),
            (
                DelaiIncorporationFumier.superieureA1Semaine,
                NSLocalizedString(
                    "Supérieur à 1 semaine",
                    comment: "Delai d'incorporation du fumier Supérieur à 1 semaine"
                )
            ),
            (
                DelaiIncorporationFumier.nonIncorpore,
                NSLocalizedString(
                    "Non incorporé",
                    comment: "Delai d'incorporation du fumier Non incorporé"
                )
            )
        ]
    }

    func getValue() -> String {
        switch self {
        case .incorporeEn48H:
            return NSLocalizedString(
                "Incorporé en 48h",
                comment: "Delai d'incorporation du fumier Incorporé en 48h"
            )
        case .incorporeEn48HA1Semaine:
            return NSLocalizedString(
                "Incorporé en 48h à 1 semaine",
                comment: "Delai d'incorporation du fumier Incorporé en 48h à 1 semaine"
            )
        case .superieureA1Semaine:
            return NSLocalizedString(
                "Supérieur à 1 semaine",
                comment: "Delai d'incorporation du fumier Supérieur à 1 semaine"
            )
        case .nonIncorpore:
            return NSLocalizedString(
                "Non incorporé",
                comment: "Delai d'incorporation du fumier Non incorporé"
            )
        }
    }

    static func getTitle() -> String {
        NSLocalizedString(
            "Délai d'incorporation du fumier (jusqu'à trois application)",
            comment: "Title délai d'incorporation du fumier (jusqu'à trois application)"
        )
    }

    static func getCulturalPracticeElement(id: Int, culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        let count = culturalPractice?.delaiIncorporationFumier?.count ?? -1
        let delaiIncorporationFumier = count > id
            ? culturalPractice!.delaiIncorporationFumier![id]
            : nil

        return CulturalPracticeMultiSelectElement(
            key: UUID().uuidString,
            title: getTitle(),
            tupleCulturalTypeValue: getValues()!,
            value: delaiIncorporationFumier,
            index: id
        )
    }

    func getUnitType() -> UnitType? {
        nil
    }

    static func create(value: String) -> CulturalPracticeValueProtocol? {
        nil
    }

    static func getRegularExpression() -> String? {
        nil
    }
}

enum TravailSol: Int, CulturalPracticeValueProtocol {
    case labourAutomneTravailSecondairePrintemps = 1
    case chiselPulverisateurAutomneTravailSecondairePrintemps
    case dechaumageAuPrintempsTravailSecondairePrintemps
    case semiDirectOuBilons

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        [
            (
                TravailSol.labourAutomneTravailSecondairePrintemps,
                NSLocalizedString(
                    "Labour à l'automne, travail secondaire au printemps",
                    comment: "Travail du sol Labour à l'automne"
                )
            ),
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
                    comment: "Travail du sol Déchaumage au printemps et travail secondaire au printemps"
                )
            ),
            (
                TravailSol.semiDirectOuBilons,
                NSLocalizedString(
                    "Semi direct ou bilons",
                    comment: "Travail du sol Semi direct ou bilons"
                )
            )
        ]
    }

    func getValue() -> String {
        switch self {
        case .labourAutomneTravailSecondairePrintemps:
            return NSLocalizedString(
                "Labour à l'automne, travail secondaire au printemps",
                comment: "Travail du sol Labour à l'automne"
            )
        case .chiselPulverisateurAutomneTravailSecondairePrintemps:
            return NSLocalizedString(
                "Chisel ou pulvérisateur à l'automne, travail secondaire au printemps",
                comment: "Travail du sol Chisel ou pulvérisateur à l'automne, travail secondaire au printemps"
            )
        case .dechaumageAuPrintempsTravailSecondairePrintemps:
            return NSLocalizedString(
                "Déchaumage au printemps et travail secondaire au printemps",
                comment: "Travail du sol Déchaumage au printemps et travail secondaire au printemps"
            )
        case .semiDirectOuBilons:
            return NSLocalizedString(
                "Semi direct ou bilons",
                comment: "Travail du sol Semi direct ou bilons"
            )
        }
    }

    static func getTitle() -> String {
        NSLocalizedString("Travail du sol", comment: "Title travail du sol")
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        let travailSol = culturalPractice?.travailSol != nil
            ? culturalPractice!.travailSol!
            : nil

        return CulturalPracticeMultiSelectElement(
            key: UUID().uuidString,
            title: TravailSol.getTitle(),
            tupleCulturalTypeValue: getValues()!,
            value: travailSol
        )

    }

    func getUnitType() -> UnitType? {
        nil
    }

    static func create(value: String) -> CulturalPracticeValueProtocol? {
        nil
    }

    static func getRegularExpression() -> String? {
        nil
    }
}

enum CouvertureAssociee: Int, CulturalPracticeValueProtocol {
    case vrai = 1
    case faux = 0

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        [
            (
                CouvertureAssociee.vrai,
                NSLocalizedString("Vrai", comment: "Couverture associée vrai")
            ),
            (
                CouvertureAssociee.faux,
                NSLocalizedString("Faux", comment: "Couverture associée faux")
            )
        ]
    }

    func getValue() -> String {
        switch self {
        case .vrai:
            return NSLocalizedString("Vrai", comment: "Couverture associée vrai")
        case .faux:
            return NSLocalizedString("Faux", comment: "Couverture associée faux")
        }
    }

    static func getTitle() -> String {
        NSLocalizedString(
            "Couverture associée",
            comment: "Title couverture associée"
        )
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        let couvertureAssociee = culturalPractice?.couvertureAssociee != nil
            ? culturalPractice!.couvertureAssociee!
            : nil

        return
            CulturalPracticeMultiSelectElement(
                key: UUID().uuidString,
                title: getTitle(),
                tupleCulturalTypeValue: getValues()!,
                value: couvertureAssociee
        )
    }

    func getUnitType() -> UnitType? {
        nil
    }

    static func create(value: String) -> CulturalPracticeValueProtocol? {
        nil
    }

    static func getRegularExpression() -> String? {
        nil
    }
}

enum CouvertureDerobee: Int, CulturalPracticeValueProtocol {
    case vrai = 1
    case faux = 0

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        [
            (
                CouvertureDerobee.vrai,
                NSLocalizedString("Vrai", comment: "Couverture dérobée vrai")
            ),
            (
                CouvertureDerobee.faux,
                NSLocalizedString("Faux", comment: "Couverture dérobée faux")
            )
        ]
    }

    func getValue() -> String {
        switch self {
        case .vrai:
            return NSLocalizedString("Vrai", comment: "Couverture dérobée vrai")
        case .faux:
            return NSLocalizedString("Faux", comment: "Couverture dérobée faux")
        }
    }

    static func getTitle() -> String {
        NSLocalizedString(
            "Couverture dérobée",
            comment: "Title Couverture dérobée"
        )
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        CulturalPracticeMultiSelectElement(
            key: UUID().uuidString,
            title: getTitle(),
            tupleCulturalTypeValue: getValues()!,
            value: culturalPractice?.couvertureDerobee
        )
    }

    func getUnitType() -> UnitType? {
        nil
    }

    static func create(value: String) -> CulturalPracticeValueProtocol? {
        nil
    }

    static func getRegularExpression() -> String? {
        nil
    }
}

enum DrainageSouterrain: Int, CulturalPracticeValueProtocol {
    case systematique = 1
    case partiel
    case absent

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        [
            (
                DrainageSouterrain.systematique,
                NSLocalizedString("Systématique", comment: "Drainage souterrain Systématique")
            ),
            (
                DrainageSouterrain.partiel,
                NSLocalizedString("Partiel", comment: "Drainage souterrain Partiel")
            ),
            (
                DrainageSouterrain.absent,
                NSLocalizedString("Absent", comment: "Drainage souterrain absent")
            )
        ]
    }

    func getValue() -> String {
        switch self {
        case .systematique:
            return NSLocalizedString("Systématique", comment: "Drainage souterrain Systématique")
        case .partiel:
            return NSLocalizedString("Partiel", comment: "Drainage souterrain Partiel")
        case .absent:
            return NSLocalizedString("Absent", comment: "Drainage souterrain absent")
        }
    }

    static func getTitle() -> String {
        NSLocalizedString(
            "Drainage souterrain",
            comment: "Title Drainage souterrain"
        )
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        CulturalPracticeMultiSelectElement(
            key: UUID().uuidString,
            title: getTitle(),
            tupleCulturalTypeValue: getValues()!,
            value: culturalPractice?.drainageSouterrain
        )
    }

    func getUnitType() -> UnitType? {
        nil
    }

    static func create(value: String) -> CulturalPracticeValueProtocol? {
        nil
    }

    static func getRegularExpression() -> String? {
        nil
    }
}

enum DrainageSurface: Int, CulturalPracticeValueProtocol {
    case bon = 1
    case moyen
    case mauvais

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        [
            (
                DrainageSurface.bon,
                NSLocalizedString("Bon", comment: "Drainage de surface Bon")
            ),
            (
                DrainageSurface.moyen,
                NSLocalizedString("Moyen", comment: "Drainage de surface Moyen")
            ),
            (
                DrainageSurface.mauvais,
                NSLocalizedString("Mauvais", comment: "Drainage de surface Mauvais")
            )
        ]
    }

    func getValue() -> String {
        switch self {
        case .bon:
            return NSLocalizedString("Bon", comment: "Drainage de surface Bon")
        case .moyen:
            return NSLocalizedString("Moyen", comment: "Drainage de surface Moyen")
        case .mauvais:
            return NSLocalizedString("Mauvais", comment: "Drainage de surface Mauvais")
        }
    }

    static func getTitle() -> String {
        NSLocalizedString("Drainage de surface", comment: "Titre Drainage de surface")
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        CulturalPracticeMultiSelectElement(
            key: UUID().uuidString,
            title: getTitle(),
            tupleCulturalTypeValue: getValues()!,
            value: culturalPractice?.drainageSouterrain
        )
    }

    func getUnitType() -> UnitType? {
        nil
    }

    static func create(value: String) -> CulturalPracticeValueProtocol? {
        nil
    }

    static func getRegularExpression() -> String? {
        nil
    }
}

enum ConditionProfilCultural: CulturalPracticeValueProtocol {
    case bonne
    case presenceZoneRisques
    case dominanceZoneRisque

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        [
            (
                ConditionProfilCultural.bonne,
                NSLocalizedString(
                    "Bonne",
                    comment: "Condition du profil cultural Bonne"
                )
            ),
            (
                ConditionProfilCultural.presenceZoneRisques,
                NSLocalizedString(
                    "Présence de zone à risque",
                    comment: "Condition du profil cultural Présence de zone à risque"
                )
            ),
            (
                ConditionProfilCultural.dominanceZoneRisque,
                NSLocalizedString(
                    "Dominance de zone à risque",
                    comment: "Condition du profil cultural Dominance de zone à risque"
                )
            )
        ]
    }

    func getValue() -> String {
        switch self {
        case .bonne:
            return NSLocalizedString(
                "Bonne",
                comment: "Condition du profil cultural Bonne"
            )
        case .presenceZoneRisques:
            return NSLocalizedString(
                "Présence de zone à risque",
                comment: "Condition du profil cultural Présence de zone à risque"
            )
        case .dominanceZoneRisque:
            return NSLocalizedString(
                "Dominance de zone à risque",
                comment: "Condition du profil cultural Dominance de zone à risque"
            )
        }
    }

    static func getTitle() -> String {
        NSLocalizedString(
            "Condition du profil cultural",
            comment: "Condition du profil cultural"
        )
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        CulturalPracticeMultiSelectElement(
            key: UUID().uuidString,
            title: getTitle(),
            tupleCulturalTypeValue: getValues()!,
            value: culturalPractice?.conditionProfilCultural
        )
    }

    func getUnitType() -> UnitType? {
        nil
    }

    static func create(value: String) -> CulturalPracticeValueProtocol? {
        nil
    }

    static func getRegularExpression() -> String? {
        nil
    }
}

enum TauxApplicationPhosphoreRang: CulturalPracticeValueProtocol {
    case taux(KilogramPerHectare)

    static func getTitle() -> String {
        NSLocalizedString(
            "Taux d'application de phosphore (engrais minéraux en rang)",
            comment: "Titre Taux d'application de phosphore (engrais minéraux en rang)"
        )
    }

    func getValue() -> String {
        switch self {
        case .taux(let kilogramPerHectare):
            return String(kilogramPerHectare)
        }
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        CulturalPracticeInputElement(
            key: UUID().uuidString,
            title: getTitle(),
            valueEmpty: TauxApplicationPhosphoreRang.taux(0),
            value: culturalPractice?.tauxApplicationPhosphoreRang
        )
    }

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        nil
    }

    func getUnitType() -> UnitType? {
        .kgHa
    }

    static func create(value: String) -> CulturalPracticeValueProtocol? {
        guard let tauxValue = Double(value) else { return nil }
        return TauxApplicationPhosphoreRang.taux(tauxValue)
    }

    static func getRegularExpression() -> String? {
        "^\\d*\\.?\\d*$"
    }
}

enum TauxApplicationPhosphoreVolee: CulturalPracticeValueProtocol {

    case taux(KilogramPerHectare)

    static func getTitle() -> String {
        NSLocalizedString(
            "Taux d'application de phosphore (engrais minéraux à la volée)",
            comment: "Titre Taux d'application de phosphore (engrais minéraux à la volée)"
        )
    }

    func getValue() -> String {
        switch self {
        case .taux(let kilogramPerHectare):
            return String(kilogramPerHectare)
        }
    }

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        nil
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        CulturalPracticeInputElement(
            key: UUID().uuidString,
            title: getTitle(),
            valueEmpty: TauxApplicationPhosphoreVolee.taux(0),
            value: culturalPractice?.tauxApplicationPhosphoreVolee
        )
    }

    func getUnitType() -> UnitType? {
        .kgHa
    }

    static func create(value: String) -> CulturalPracticeValueProtocol? {
        guard let tauxValue = Double(value) else { return nil }
        return TauxApplicationPhosphoreVolee.taux(tauxValue)
    }

    static func getRegularExpression() -> String? {
        "^\\d*\\.?\\d*$"
    }
}

enum PMehlich3: CulturalPracticeValueProtocol {
    case taux(KilogramPerHectare)

    static func getTitle() -> String {
        NSLocalizedString(
            "P Mehlich-3",
            comment: "Titre P Mehlich-3"
        )
    }

    func getValue() -> String {
        switch self {
        case .taux(let kilogramPerHectare):
            return String(kilogramPerHectare)
        }
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        CulturalPracticeInputElement(
            key: UUID().uuidString,
            title: getTitle(),
            valueEmpty: PMehlich3.taux(0),
            value: culturalPractice?.pMehlich3
        )
    }

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        nil
    }

    func getUnitType() -> UnitType? {
        .kgHa
    }

    static func create(value: String) -> CulturalPracticeValueProtocol? {
        guard let tauxValue = Double(value) else { return nil }
        return PMehlich3.taux(tauxValue)
    }

    static func getRegularExpression() -> String? {
        "^\\d*\\.?\\d*$"
    }
}

enum AlMehlich3: CulturalPracticeValueProtocol {

    case taux(Percentage)

    static func getTitle() -> String {
        NSLocalizedString(
            "AL Mehlich-3",
            comment: "AL Mehlich-3"
        )
    }

    func getValue() -> String {
        switch self {
        case .taux(let percentage):
            return String(percentage)
        }
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        CulturalPracticeInputElement(
            key: UUID().uuidString,
            title: getTitle(),
            valueEmpty: AlMehlich3.taux(0),
            value: culturalPractice?.alMehlich3
        )
    }

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        nil
    }

    func getUnitType() -> UnitType? {
        .percentage
    }

    static func create(value: String) -> CulturalPracticeValueProtocol? {
        guard let tauxValue = Double(value) else { return nil }
        return AlMehlich3.taux(tauxValue)
    }

    static func getRegularExpression() -> String? {
        "^\\d*\\.?\\d*$"
    }
}

enum CultureAnneeEnCoursAnterieure: CulturalPracticeValueProtocol {
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

    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        [
            (
                CultureAnneeEnCoursAnterieure.auc,
                NSLocalizedString("Autres céréales", comment: "Autres céréales")
            ),
            (
                CultureAnneeEnCoursAnterieure.avo,
                NSLocalizedString("Avoine", comment: "Avoine")
            ),
            (
                CultureAnneeEnCoursAnterieure.ble,
                NSLocalizedString("Blé", comment: "Blé")
            ),
            (
                CultureAnneeEnCoursAnterieure.cnl,
                NSLocalizedString("Canola", comment: "Canola")
            ),
            (
                CultureAnneeEnCoursAnterieure.foi,
                NSLocalizedString("Foin", comment: "Foin")
            ),
            (
                CultureAnneeEnCoursAnterieure.mai,
                NSLocalizedString("Maï", comment: "Maï")
            ),
            (
                CultureAnneeEnCoursAnterieure.mix,
                NSLocalizedString("Mixte", comment: "Mixte")
            ),
            (
                CultureAnneeEnCoursAnterieure.non,
                NSLocalizedString(
                    "Pas d'info, traité comme si c'était du foin",
                    comment: "Pas d'info, traité comme si c'était du foin"
                )
            ),
            (
                CultureAnneeEnCoursAnterieure.org,
                NSLocalizedString("Orge", comment: "Orge")
            ),
            (
                CultureAnneeEnCoursAnterieure.ptf,
                NSLocalizedString("Petits fruits", comment: "Petits fruits")
            ),
            (
                CultureAnneeEnCoursAnterieure.soy,
                NSLocalizedString("Soya", comment: "Soya")
            )
        ]
    }

    // swiftlint:disable all
    func getValue() -> String {
        switch self {
        case .auc:
            return NSLocalizedString("Autres céréales", comment: "Autres céréales")
        case .avo:
            return NSLocalizedString("Avoine", comment: "Avoine")
        case .ble:
            return NSLocalizedString("Blé", comment: "Blé")
        case .cnl:
            return NSLocalizedString("Canola", comment: "Canola")
        case .foi:
            return NSLocalizedString("Foin", comment: "Foin")
        case .mai:
            return NSLocalizedString("Maï", comment: "Maï")
        case .mix:
            return NSLocalizedString("Mixte", comment: "Mixte")
        case .non:
            return NSLocalizedString(
                "Pas d'info, traité comme si c'était du foin",
                comment: "Pas d'info, traité comme si c'était du foin"
            )
        case .org:
            return NSLocalizedString("Orge", comment: "Orge")
        case .ptf:
            return NSLocalizedString("Petits fruits", comment: "Petits fruits")
        case .soy:
            return NSLocalizedString("Soya", comment: "Soya")
        }
    }
    
    static func getTitle() -> String {
        NSLocalizedString(
            "Culture de l'année en cours et antérieure",
            comment: "Titre Culture de l'année en cours et antérieure"
        )
    }
    
    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElementProtocol {
        CulturalPracticeMultiSelectElement(
            key: UUID().uuidString,
            title: getTitle(),
            tupleCulturalTypeValue: getValues()!,
            value: culturalPractice?.cultureAnneeEnCoursAnterieure
        )
    }
    
    func getUnitType() -> UnitType? {
        nil
    }
    
    static func create(value: String) -> CulturalPracticeValueProtocol? {
        nil
    }
    
    static func getRegularExpression() -> String? {
        nil
    }
}

enum UnitType {
    case kgHa
    case percentage
    case quantity
    
    func convertToString() -> String {
        switch self {
        case .kgHa:
            return "kg/ha"
        case .percentage:
            return "%"
        case .quantity:
            return "quantité"
        }
    }
}

typealias KilogramPerHectare = Double
typealias Percentage = Double

struct CulturalPracticeAddElement: CulturalPracticeElementProtocol {
    let key: String
    let title: String
    var value: CulturalPracticeValueProtocol?
}

struct CulturalPracticeInputMultiSelectContainer: CulturalPracticeElementProtocol {
    let key: String
    let title: String
    let culturalInputElement: [CulturalPracticeElementProtocol]
    let culturalPracticeMultiSelectElement: [CulturalPracticeElementProtocol]
    var value: CulturalPracticeValueProtocol?
}

struct CulturalPracticeMultiSelectElement: CulturalPracticeElementProtocol {
    let key: String
    var title: String
    var tupleCulturalTypeValue: [(CulturalPracticeValueProtocol, String)]
    var value: CulturalPracticeValueProtocol?
    var index: Int?
}

struct CulturalPracticeInputElement: CulturalPracticeElementProtocol {
    let key: String
    let title: String
    var valueEmpty: CulturalPracticeValueProtocol
    var value: CulturalPracticeValueProtocol?
    var index: Int?
    
}

protocol CulturalPracticeValueProtocol {
    static func getTitle() -> String
    func getValue() -> String
    static func getValues() -> [(CulturalPracticeValueProtocol, String)]?
    func getUnitType() -> UnitType?
    static func create(value: String) -> CulturalPracticeValueProtocol?
    static func getRegularExpression() -> String?
}

protocol CulturalPracticeElementProtocol {
    var title: String {get}
    var key: String {get}
    var value: CulturalPracticeValueProtocol? {get}
}
