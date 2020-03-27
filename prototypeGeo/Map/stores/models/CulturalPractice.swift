//
//  CulturalPractice.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-02-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

internal struct CulturalPractice {
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

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> [CulturalPracticeElement] {
        let culturalPracticeSingleElement = getCulturalPracticeSingleElement(from: culturalPractice)
        let culturalPracticeContainerElement = getCulturalPracticeDynamic(from: culturalPractice)

        if culturalPracticeContainerElement != nil {
            return culturalPracticeSingleElement + culturalPracticeContainerElement!
        }

        return culturalPracticeSingleElement
    }

    static func getCulturalPracticeSingleElement(
        from culturalPractice: CulturalPractice?
    ) -> [CulturalPracticeElement] {
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
                key: .addDoseFunier
            )
        ]
    }

    static func createCulturalPracticeInputMultiSelectContainer(index: Int) -> CulturalPracticeElement {
        CulturalPracticeElement.culturalPracticeInputMultiSelectContainer(
            CulturalPracticeInputMultiSelectContainer(
                key: .inputMultiSelectContainer,
                title: "Dose fumier \(index)",
                culturalInputElement: [
                    DoseFumier.getCulturalPracticeElement(id: index, culturalPractice: nil)
                ],
                culturalPracticeMultiSelectElement: [
                    PeriodeApplicationFumier.getCulturalPracticeElement(id: index, culturalPractice: nil),
                    DelaiIncorporationFumier.getCulturalPracticeElement(id: index, culturalPractice: nil)
                ]
            )
        )
    }

    private static func getCulturalPracticeDynamic(from culturalPractice: CulturalPractice?) -> [CulturalPracticeElement]? {
        guard let culturalPractice = culturalPractice else {
            return nil
        }

        var culturalPracticeElements: [CulturalPracticeElement] = []

        (0...(MAX_DOSE_FUMIER - 1)).forEach { index in
            if hasValueDoseFumier(culturalPractice: culturalPractice, index: index) {
                let culturalPracticeInputMultiSelectContainer =
                        CulturalPracticeElement.culturalPracticeInputMultiSelectContainer(
                    CulturalPracticeInputMultiSelectContainer(
                        key: .container,
                        title: "Dose fumier \(index + 1)",
                        culturalInputElement: [
                            DoseFumier.getCulturalPracticeElement(id: index, culturalPractice: culturalPractice)
                        ],
                        culturalPracticeMultiSelectElement: [
                            PeriodeApplicationFumier.getCulturalPracticeElement(id: index, culturalPractice: culturalPractice),
                            DelaiIncorporationFumier.getCulturalPracticeElement(id: index, culturalPractice: culturalPractice)
                        ]
                    )
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

    static func createCulturalPracticeAddElement(
        title: String,
        key: KeyCulturalPracticeData
    ) -> CulturalPracticeElement {
        CulturalPracticeElement.culturalPracticeAddElement(
            CulturalPracticeAddElement(
                key: key,
                title: title
            )
        )
    }
}

enum CulturalPracticeValue {
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
    case doseFumier(DoseFumier)
    case tauxApplicationPhosphoreRang(TauxApplicationPhosphoreRang)
    case tauxApplicationPhosphoreVolee(TauxApplicationPhosphoreVolee)
    case pMehlich3(PMehlich3)
    case alMehlich3(AlMehlich3)

    func getValue() -> String {
        switch self {
        case .avaloir(let avaloir):
            return avaloir.getValue()
        case .bandeRiveraine(let bandeRiveraine):
            return bandeRiveraine.getValue()
        case .periodeApplicationFumier(let periodeApplicationFumier):
            return periodeApplicationFumier.getValue()
        case .delaiIncorporationFumier(let delaiIncorporationFumier):
            return delaiIncorporationFumier.getValue()
        case .travailSol(let travailSol):
            return travailSol.getValue()
        case .couvertureAssociee(let couvertureAssociee):
            return couvertureAssociee.getValue()
        case .couvertureDerobee(let couvertureDerobee):
            return couvertureDerobee.getValue()
        case .drainageSouterrain(let drainageSouterrain):
            return drainageSouterrain.getValue()
        case .drainageSurface(let drainageSurface):
            return drainageSurface.getValue()
        case .conditionProfilCultural(let conditionProfilCultural):
            return conditionProfilCultural.getValue()
        case .cultureAnneeEnCoursAnterieure(let cultureAnneeEnCoursAnterieure):
            return cultureAnneeEnCoursAnterieure.getValue()
        case .doseFumier(let doseFumier):
            return doseFumier.getValue()
        case .tauxApplicationPhosphoreRang(let tauxApplicationPhosphoreRang):
            return tauxApplicationPhosphoreRang.getValue()
        case .tauxApplicationPhosphoreVolee(let tauxApplicationPhosphoreVolee):
            return tauxApplicationPhosphoreVolee.getValue()
        case .pMehlich3(let pMehlich3):
            return pMehlich3.getValue()
        case .alMehlich3(let alMehlich3):
            return alMehlich3.getValue()
        }
    }
}

enum Avaloir: Int {
    case absente = 1
    case captagePartiel
    case captageSystematique

    static func getValues() -> [(CulturalPracticeValue, String)] {
        [
            (
                CulturalPracticeValue.avaloir(Avaloir.absente),
                NSLocalizedString("Absente", comment: "Avaloir absente")
            ),
            (
                CulturalPracticeValue.avaloir(Avaloir.captagePartiel),
                NSLocalizedString("Captage Partiel", comment: "Avaloir captage partiel")
            ),
            (
                CulturalPracticeValue.avaloir(Avaloir.captageSystematique),
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

    static func getKey() -> KeyCulturalPracticeData {
        KeyCulturalPracticeData.avaloir
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElement {
        CulturalPracticeElement.culturalPracticeMultiSelectElement(
            CulturalPracticeMultiSelectElement(
                key: Avaloir.getKey(),
                title: Avaloir.getTitle(),
                tupleCulturalTypeValue: Avaloir.getValues(),
                value: culturalPractice?.avaloir != nil
                    ? CulturalPracticeValue.avaloir(culturalPractice!.avaloir!)
                    : nil
            )
        )
    }
}

enum BandeRiveraine: Int {
    case pasApplique = 1
    case inferieura1M
    case de1A3M
    case de4MEtPlus

    static func getValues() -> [(CulturalPracticeValue, String)] {
        [
            (
                CulturalPracticeValue.bandeRiveraine(BandeRiveraine.pasApplique),
                NSLocalizedString("Ne s'applique pas", comment: "Bande riveraine ne s'applique pas")
            ),
            (
                CulturalPracticeValue.bandeRiveraine(BandeRiveraine.inferieura1M),
                NSLocalizedString("Inférieur à 1m", comment: "Bande riveraine Inférieur à 1m")
            ),
            (
                CulturalPracticeValue.bandeRiveraine(BandeRiveraine.de1A3M),
                NSLocalizedString("1 à 3m", comment: "Bande riveraine 4m et plus")
            ),
            (
                CulturalPracticeValue.bandeRiveraine(BandeRiveraine.de4MEtPlus),
                NSLocalizedString("4m et plus", comment: "Bande riveraine 4m et plus")
            )
        ]
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

    static func getTitle() -> String {
        NSLocalizedString("Bande riveraine", comment: "Titre bande riveraine")
    }

    static func getKey() -> KeyCulturalPracticeData {
        KeyCulturalPracticeData.bandeRiveraine
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElement {
        CulturalPracticeElement.culturalPracticeMultiSelectElement(
            CulturalPracticeMultiSelectElement(
                key: BandeRiveraine.getKey(),
                title: BandeRiveraine.getTitle(),
                tupleCulturalTypeValue: BandeRiveraine.getValues(),
                value: culturalPractice?.bandeRiveraine != nil
                    ? CulturalPracticeValue
                        .bandeRiveraine(culturalPractice!.bandeRiveraine!)
                    : nil
            )
        )
    }
}

enum DoseFumier {
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

    static func getKey(id: Int) -> KeyCulturalPracticeData {
        KeyCulturalPracticeData.doseFumier(id: id)
    }

    static func getCulturalPracticeElement(id: Int, culturalPractice: CulturalPractice?) -> CulturalPracticeElement {
        let count = culturalPractice?.doseFumier?.count ?? -1

        let doseFumier = count > id
            ? CulturalPracticeValue.doseFumier(culturalPractice!.doseFumier![id])
            : nil

        return CulturalPracticeElement.culturalPracticeInputElement(
            CulturalPracticeInputElement(
                key: getKey(id: id),
                titleInput: getTitle(),
                value: doseFumier
            )
        )
    }
}

enum PeriodeApplicationFumier: Int {
    case preSemi = 1
    case postLevee
    case automneHatif
    case automneTardif

    static func getValues() -> [(CulturalPracticeValue, String)] {
        [
            (
                CulturalPracticeValue
                    .periodeApplicationFumier(PeriodeApplicationFumier.preSemi),
                NSLocalizedString(
                    "Pré-semi",
                    comment: "Periode d'application du fumier Pré-semi"
                )
            ),
            (
                CulturalPracticeValue
                    .periodeApplicationFumier(PeriodeApplicationFumier.postLevee),
                NSLocalizedString(
                    "Post-levée",
                    comment: "Periode d'application du fumier Post-levée"
                )
            ),
            (
                CulturalPracticeValue
                    .periodeApplicationFumier(PeriodeApplicationFumier.automneHatif),
                NSLocalizedString(
                    "Automne hâtif",
                    comment: "Periode d'application du fumier Automne hâtif"
                )
            ),
            (
                CulturalPracticeValue
                    .periodeApplicationFumier(PeriodeApplicationFumier.automneTardif),
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

    static func getKey(id: Int) -> KeyCulturalPracticeData {
        KeyCulturalPracticeData.periodeApplicationFumier(id: id)
    }

    static func getCulturalPracticeElement(id: Int, culturalPractice: CulturalPractice?) -> CulturalPracticeElement {
        let count = culturalPractice?.periodeApplicationFumier?.count ?? -1
        let periodeApplicationFumier = count > id
            ? CulturalPracticeValue
                .periodeApplicationFumier(culturalPractice!.periodeApplicationFumier![id])
            : nil

        return CulturalPracticeElement.culturalPracticeMultiSelectElement(
            CulturalPracticeMultiSelectElement(
                key: getKey(id: id),
                title: getTitle(),
                tupleCulturalTypeValue: getValues(),
                value: periodeApplicationFumier
            )
        )
    }
}

enum DelaiIncorporationFumier: Int {
    case incorporeEn48H = 1
    case incorporeEn48HA1Semaine
    case superieureA1Semaine
    case nonIncorpore

    static func getValues() -> [(CulturalPracticeValue, String)] {
        [
            (
                CulturalPracticeValue
                    .delaiIncorporationFumier(DelaiIncorporationFumier.incorporeEn48H),
                NSLocalizedString(
                    "Incorporé en 48h",
                    comment: "Delai d'incorporation du fumier Incorporé en 48h"
                )
            ),
            (
                CulturalPracticeValue
                    .delaiIncorporationFumier(DelaiIncorporationFumier.incorporeEn48HA1Semaine),
                NSLocalizedString(
                    "Incorporé en 48h à 1 semaine",
                    comment: "Delai d'incorporation du fumier Incorporé en 48h à 1 semaine"
                )
            ),
            (
                CulturalPracticeValue
                    .delaiIncorporationFumier(DelaiIncorporationFumier.superieureA1Semaine),
                NSLocalizedString(
                    "Supérieur à 1 semaine",
                    comment: "Delai d'incorporation du fumier Supérieur à 1 semaine"
                )
            ),
            (
                CulturalPracticeValue
                    .delaiIncorporationFumier(DelaiIncorporationFumier.nonIncorpore),
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

    static func getKey(id: Int) -> KeyCulturalPracticeData {
        KeyCulturalPracticeData.delaiIncorporationFumier(id: id)
    }

    static func getCulturalPracticeElement(id: Int, culturalPractice: CulturalPractice?) -> CulturalPracticeElement {
        let count = culturalPractice?.delaiIncorporationFumier?.count ?? -1
        let delaiIncorporationFumier = count > id
            ? CulturalPracticeValue
                .delaiIncorporationFumier(culturalPractice!.delaiIncorporationFumier![id])
            : nil

        return CulturalPracticeElement.culturalPracticeMultiSelectElement(
            CulturalPracticeMultiSelectElement(
                key: getKey(id: id),
                title: getTitle(),
                tupleCulturalTypeValue: getValues(),
                value: delaiIncorporationFumier
            )
        )
    }
}

enum TravailSol: Int {
    case labourAutomneTravailSecondairePrintemps = 1
    case chiselPulverisateurAutomneTravailSecondairePrintemps
    case dechaumageAuPrintempsTravailSecondairePrintemps
    case semiDirectOuBilons

    static func getValues() -> [(CulturalPracticeValue, String)] {
        [
            (
                CulturalPracticeValue
                    .travailSol(TravailSol.labourAutomneTravailSecondairePrintemps),
                NSLocalizedString(
                    "Labour à l'automne, travail secondaire au printemps",
                    comment: "Travail du sol Labour à l'automne"
                )
            ),
            (
                CulturalPracticeValue
                    .travailSol(TravailSol.chiselPulverisateurAutomneTravailSecondairePrintemps),
                NSLocalizedString(
                    "Chisel ou pulvérisateur à l'automne, travail secondaire au printemps",
                    comment: "Travail du sol Chisel ou pulvérisateur à l'automne, travail secondaire au printemps"
                )
            ),
            (
                CulturalPracticeValue
                    .travailSol(TravailSol.dechaumageAuPrintempsTravailSecondairePrintemps),
                NSLocalizedString(
                    "Déchaumage au printemps et travail secondaire au printemps",
                    comment: "Travail du sol Déchaumage au printemps et travail secondaire au printemps"
                )
            ),
            (
                CulturalPracticeValue
                    .travailSol(TravailSol.semiDirectOuBilons),
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

    static func getKey() -> KeyCulturalPracticeData {
        KeyCulturalPracticeData.travailSol
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElement {
        let travailSol = culturalPractice?.travailSol != nil
            ? CulturalPracticeValue.travailSol(culturalPractice!.travailSol!)
            : nil

        return CulturalPracticeElement.culturalPracticeMultiSelectElement(
            CulturalPracticeMultiSelectElement(
                key: TravailSol.getKey(),
                title: TravailSol.getTitle(),
                tupleCulturalTypeValue: TravailSol.getValues(),
                value: travailSol
            )
        )
    }
}

enum CouvertureAssociee: Int {
    case vrai = 1
    case faux = 0

    static func getValues() -> [(CulturalPracticeValue, String)] {
        [
            (
                CulturalPracticeValue
                    .couvertureAssociee(CouvertureAssociee.vrai),
                NSLocalizedString("Vrai", comment: "Couverture associée vrai")
            ),
            (
                CulturalPracticeValue
                    .couvertureAssociee(CouvertureAssociee.faux),
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

    static func getKey() -> KeyCulturalPracticeData {
        KeyCulturalPracticeData.couvertureAssociee
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElement {
        let couvertureAssociee = culturalPractice?.couvertureAssociee != nil
            ? CulturalPracticeValue.couvertureAssociee(culturalPractice!.couvertureAssociee!)
            : nil

        return CulturalPracticeElement.culturalPracticeMultiSelectElement(
            CulturalPracticeMultiSelectElement(
                key: getKey(),
                title: getTitle(),
                tupleCulturalTypeValue: getValues(),
                value: couvertureAssociee
            )
        )
    }
}

enum CouvertureDerobee: Int {
    case vrai = 1
    case faux = 0

    static func getValues() -> [(CulturalPracticeValue, String)] {
        [
            (
                CulturalPracticeValue
                    .couvertureDerobee(CouvertureDerobee.vrai),
                NSLocalizedString("Vrai", comment: "Couverture dérobée vrai")
            ),
            (
                CulturalPracticeValue
                    .couvertureDerobee(CouvertureDerobee.faux),
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

    static func getKey() -> KeyCulturalPracticeData {
        KeyCulturalPracticeData.couvertureDerobee
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElement {
        let couvertureDerobee = culturalPractice?.couvertureDerobee != nil
            ? CulturalPracticeValue.couvertureDerobee(culturalPractice!.couvertureDerobee!)
            : nil

        return CulturalPracticeElement.culturalPracticeMultiSelectElement(
            CulturalPracticeMultiSelectElement(
                key: getKey(),
                title: getTitle(),
                tupleCulturalTypeValue: getValues(),
                value: couvertureDerobee
            )
        )
    }
}

enum DrainageSouterrain: Int {
    case systematique = 1
    case partiel
    case absent

    static func getValues() -> [(CulturalPracticeValue, String)] {
        [
            (
                CulturalPracticeValue
                    .drainageSouterrain(DrainageSouterrain.systematique),
                NSLocalizedString("Systématique", comment: "Drainage souterrain Systématique")
            ),
            (
                CulturalPracticeValue
                    .drainageSouterrain(DrainageSouterrain.partiel),
                NSLocalizedString("Partiel", comment: "Drainage souterrain Partiel")
            ),
            (
                CulturalPracticeValue
                    .drainageSouterrain(DrainageSouterrain.absent),
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

    static func getKey() -> KeyCulturalPracticeData {
        KeyCulturalPracticeData.drainageSouterrain
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElement {
        let drainageSouterrain = culturalPractice?.drainageSouterrain != nil
            ? CulturalPracticeValue.drainageSouterrain(culturalPractice!.drainageSouterrain!)
            : nil

        return CulturalPracticeElement.culturalPracticeMultiSelectElement(
            CulturalPracticeMultiSelectElement(
                key: getKey(),
                title: getTitle(),
                tupleCulturalTypeValue: getValues(),
                value: drainageSouterrain
            )
        )
    }
}

enum DrainageSurface: Int {
    case bon = 1
    case moyen
    case mauvais

    static func getValues() -> [(CulturalPracticeValue, String)] {
        [
            (
                CulturalPracticeValue
                    .drainageSurface(DrainageSurface.bon),
                NSLocalizedString("Bon", comment: "Drainage de surface Bon")
            ),
            (
                CulturalPracticeValue
                    .drainageSurface(DrainageSurface.moyen),
                NSLocalizedString("Moyen", comment: "Drainage de surface Moyen")
            ),
            (
                CulturalPracticeValue
                    .drainageSurface(DrainageSurface.mauvais),
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

    static func getKey() -> KeyCulturalPracticeData {
        KeyCulturalPracticeData.drainageSurface
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElement {
        let drainageSurface = culturalPractice?.drainageSouterrain != nil
            ? CulturalPracticeValue.drainageSouterrain(culturalPractice!.drainageSouterrain!)
        : nil

        return CulturalPracticeElement.culturalPracticeMultiSelectElement(
            CulturalPracticeMultiSelectElement(
                key: getKey(),
                title: getTitle(),
                tupleCulturalTypeValue: getValues(),
                value: drainageSurface
            )
        )
    }
}

enum ConditionProfilCultural {
    case bonne
    case presenceZoneRisques
    case dominanceZoneRisque

    static func getValues() -> [(CulturalPracticeValue, String)] {
        [
            (
                CulturalPracticeValue
                    .conditionProfilCultural(ConditionProfilCultural.bonne),
                NSLocalizedString(
                    "Bonne",
                    comment: "Condition du profil cultural Bonne"
                )
            ),
            (
                CulturalPracticeValue
                    .conditionProfilCultural(ConditionProfilCultural.presenceZoneRisques),
                NSLocalizedString(
                    "Présence de zone à risque",
                    comment: "Condition du profil cultural Présence de zone à risque"
                )
            ),
            (
                CulturalPracticeValue
                    .conditionProfilCultural(ConditionProfilCultural.dominanceZoneRisque),
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

    static func getKey() -> KeyCulturalPracticeData {
        KeyCulturalPracticeData.conditionProfilCultural
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElement {
        let conditionProfilCultural = culturalPractice?.conditionProfilCultural != nil
            ? CulturalPracticeValue.conditionProfilCultural(culturalPractice!.conditionProfilCultural!)
            : nil

        return CulturalPracticeElement.culturalPracticeMultiSelectElement(
            CulturalPracticeMultiSelectElement(
                key: getKey(),
                title: getTitle(),
                tupleCulturalTypeValue: getValues(),
                value: conditionProfilCultural
            )
        )
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

    func getValue() -> String {
        switch self {
        case .taux(let kilogramPerHectare):
            return String(kilogramPerHectare)
        }
    }

    static func getKey() -> KeyCulturalPracticeData {
        KeyCulturalPracticeData.tauxApplicationPhosphoreRang
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElement {
        let tauxApplicationPhosphoreRang = culturalPractice?.tauxApplicationPhosphoreRang != nil
            ? CulturalPracticeValue.tauxApplicationPhosphoreRang(culturalPractice!.tauxApplicationPhosphoreRang!)
        : nil

        return CulturalPracticeElement.culturalPracticeInputElement(
            CulturalPracticeInputElement(
                key: getKey(),
                titleInput: getTitle(),
                value: tauxApplicationPhosphoreRang
            )
        )
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

    func getValue() -> String {
        switch self {
        case .taux(let kilogramPerHectare):
            return String(kilogramPerHectare)
        }
    }

    static func getKey() -> KeyCulturalPracticeData {
        KeyCulturalPracticeData.tauxApplicationPhosphoreVolee
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElement {
        let tauxApplicationPhosphoreVolee = culturalPractice?.tauxApplicationPhosphoreVolee != nil
            ? CulturalPracticeValue.tauxApplicationPhosphoreVolee(culturalPractice!.tauxApplicationPhosphoreVolee!)
        : nil

        return CulturalPracticeElement.culturalPracticeInputElement(
            CulturalPracticeInputElement(
                key: getKey(),
                titleInput: getTitle(),
                value: tauxApplicationPhosphoreVolee
            )
        )
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

    func getValue() -> String {
        switch self {
        case .taux(let kilogramPerHectare):
            return String(kilogramPerHectare)
        }
    }

    static func getKey() -> KeyCulturalPracticeData {
        KeyCulturalPracticeData.pMehlich3
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElement {
        let pMehlich3 = culturalPractice?.pMehlich3 != nil
            ? CulturalPracticeValue.pMehlich3(culturalPractice!.pMehlich3!)
            : nil

        return CulturalPracticeElement.culturalPracticeInputElement(
            CulturalPracticeInputElement(
                key: getKey(),
                titleInput: getTitle(),
                value: pMehlich3
            )
        )
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

    func getValue() -> String {
        switch self {
        case .taux(let percentage):
            return String(percentage)
        }
    }

    static func getKey() -> KeyCulturalPracticeData {
        KeyCulturalPracticeData.alMehlich3
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElement {
        let alMehlich3 = culturalPractice?.alMehlich3 != nil
            ? CulturalPracticeValue.alMehlich3(culturalPractice!.alMehlich3!)
            : nil

        return CulturalPracticeElement.culturalPracticeInputElement(
            CulturalPracticeInputElement(
                key: getKey(),
                titleInput: getTitle(),
                value: alMehlich3
            )
        )
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

    static func getValues() -> [(CulturalPracticeValue, String)] {
        [
            (
                CulturalPracticeValue
                    .cultureAnneeEnCoursAnterieure(CultureAnneeEnCoursAnterieure.auc),
                NSLocalizedString("Autres céréales", comment: "Autres céréales")
            ),
            (
                CulturalPracticeValue
                    .cultureAnneeEnCoursAnterieure(CultureAnneeEnCoursAnterieure.avo),
                NSLocalizedString("Avoine", comment: "Avoine")
            ),
            (
                CulturalPracticeValue
                    .cultureAnneeEnCoursAnterieure(CultureAnneeEnCoursAnterieure.ble),
                NSLocalizedString("Blé", comment: "Blé")
            ),
            (
                CulturalPracticeValue
                    .cultureAnneeEnCoursAnterieure(CultureAnneeEnCoursAnterieure.cnl),
                NSLocalizedString("Canola", comment: "Canola")
            ),
            (
                CulturalPracticeValue
                    .cultureAnneeEnCoursAnterieure(CultureAnneeEnCoursAnterieure.foi),
                NSLocalizedString("Foin", comment: "Foin")
            ),
            (
                CulturalPracticeValue
                    .cultureAnneeEnCoursAnterieure(CultureAnneeEnCoursAnterieure.mai),
                NSLocalizedString("Maï", comment: "Maï")
            ),
            (
                CulturalPracticeValue
                    .cultureAnneeEnCoursAnterieure(CultureAnneeEnCoursAnterieure.mix),
                NSLocalizedString("Mixte", comment: "Mixte")
            ),
            (
                CulturalPracticeValue
                    .cultureAnneeEnCoursAnterieure(CultureAnneeEnCoursAnterieure.non),
                NSLocalizedString(
                    "Pas d'info, traité comme si c'était du foin",
                    comment: "Pas d'info, traité comme si c'était du foin"
                )
            ),
            (
                CulturalPracticeValue
                    .cultureAnneeEnCoursAnterieure(CultureAnneeEnCoursAnterieure.org),
                NSLocalizedString("Orge", comment: "Orge")
            ),
            (
                CulturalPracticeValue
                    .cultureAnneeEnCoursAnterieure(CultureAnneeEnCoursAnterieure.ptf),
                NSLocalizedString("Petits fruits", comment: "Petits fruits")
            ),
            (
                CulturalPracticeValue
                    .cultureAnneeEnCoursAnterieure(CultureAnneeEnCoursAnterieure.soy),
                NSLocalizedString("Soya", comment: "Soya")
            )
        ]
    }

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

    static func getKey() -> KeyCulturalPracticeData {
        KeyCulturalPracticeData.cultureAnneeEnCoursAnterieure
    }

    static func getCulturalPracticeElement(culturalPractice: CulturalPractice?) -> CulturalPracticeElement {
        let cultureAnneeEnCoursAnterieure = culturalPractice?.cultureAnneeEnCoursAnterieure != nil
            ? CulturalPracticeValue.cultureAnneeEnCoursAnterieure(culturalPractice!.cultureAnneeEnCoursAnterieure!)
        : nil

        return CulturalPracticeElement.culturalPracticeInputElement(
            CulturalPracticeInputElement(
                key: getKey(),
                titleInput: getTitle(),
                value: cultureAnneeEnCoursAnterieure
            )
        )
    }
}

typealias KilogramPerHectare = Double
typealias Percentage = Int

struct CulturalPracticeAddElement {
    let key: KeyCulturalPracticeData
    let title: String
}

struct CulturalPracticeInputMultiSelectContainer {
    let key: KeyCulturalPracticeData
    let title: String
    let culturalInputElement: [CulturalPracticeElement]
    let culturalPracticeMultiSelectElement: [CulturalPracticeElement]
}

struct CulturalPracticeMultiSelectElement {
    let key: KeyCulturalPracticeData
    var title: String
    var tupleCulturalTypeValue: [(CulturalPracticeValue, String)]
    var value: CulturalPracticeValue?
}

struct CulturalPracticeInputElement {
    let key: KeyCulturalPracticeData
    let titleInput: String
    var value: CulturalPracticeValue?
}

enum CulturalPracticeElement {
    case culturalPracticeMultiSelectElement(CulturalPracticeMultiSelectElement)
    case culturalPracticeAddElement(CulturalPracticeAddElement)
    case culturalPracticeInputElement(CulturalPracticeInputElement)
    case culturalPracticeInputMultiSelectContainer(CulturalPracticeInputMultiSelectContainer)
}

enum KeyCulturalPracticeData {
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
    case addDoseFunier
    case inputMultiSelectContainer
    case container
} // swiftlint:disable:this force_cast
