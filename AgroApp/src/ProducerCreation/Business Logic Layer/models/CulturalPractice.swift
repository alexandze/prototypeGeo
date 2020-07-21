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
    var doseFumier: [DoseFumier?]?
    var periodeApplicationFumier: [PeriodeApplicationFumier?]?
    var delaiIncorporationFumier: [DelaiIncorporationFumier?]?

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

    init() {
        initArrayValue()
    }

    mutating func initArrayValue() {
        doseFumier = []
        periodeApplicationFumier = []
        delaiIncorporationFumier = []

        (0..<CulturalPractice.MAX_DOSE_FUMIER).forEach { _ in
            doseFumier?.append(nil)
            periodeApplicationFumier?.append(nil)
            delaiIncorporationFumier?.append(nil)
        }
    }

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
        CulturalPracticeContainerElement(
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
            if hasValueArray(culturalPractice: culturalPractice, index: index) {
                let culturalPracticeInputMultiSelectContainer =
                    CulturalPracticeContainerElement(
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

    private static func hasValueArray(culturalPractice: CulturalPractice, index: Int) -> Bool {
        let hasDoseFumier = checkArrayValue(
            culturalPractice: culturalPractice,
            index: index,
            key: \.doseFumier
        )

        let hasPeriodeApplicationFumier = checkArrayValue(
            culturalPractice: culturalPractice,
            index: index,
            key: \.periodeApplicationFumier
        )

        let hasDelaiIncorporationFumier = checkArrayValue(
            culturalPractice: culturalPractice,
            index: index,
            key: \.delaiIncorporationFumier
        )

        return hasDoseFumier || hasPeriodeApplicationFumier || hasDelaiIncorporationFumier
    }

    private static func checkArrayValue<T>(
        culturalPractice: CulturalPractice,
        index: Int,
        key: KeyPath<CulturalPractice, [T?]?>
    ) -> Bool {
        let count = culturalPractice[keyPath: key]!.count
        let arrayValue = culturalPractice[keyPath: key]!
        return index < count && arrayValue[index] != nil
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

    func changeValueOfCulturalPractice(_ culturalPractice: CulturalPractice, index: Int?) -> CulturalPractice {
        var newCulturalPractice = culturalPractice
        newCulturalPractice.couvertureDerobee = self
        return newCulturalPractice
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

    func changeValueOfCulturalPractice(_ culturalPractice: CulturalPractice, index: Int?) -> CulturalPractice {
        var newCulturalPractice = culturalPractice
        newCulturalPractice.tauxApplicationPhosphoreRang = self
        return newCulturalPractice
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

    func changeValueOfCulturalPractice(_ culturalPractice: CulturalPractice, index: Int?) -> CulturalPractice {
        var newCulturalPractice = culturalPractice
        newCulturalPractice.tauxApplicationPhosphoreVolee = self
        return newCulturalPractice
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

    func changeValueOfCulturalPractice(_ culturalPractice: CulturalPractice, index: Int?) -> CulturalPractice {
        var newCulturalPractice = culturalPractice
        newCulturalPractice.pMehlich3 = self
        return newCulturalPractice
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

    func changeValueOfCulturalPractice(_ culturalPractice: CulturalPractice, index: Int?) -> CulturalPractice {
        var newCulturalPractice = culturalPractice
        newCulturalPractice.alMehlich3 = self
        return newCulturalPractice
    }
}

enum CultureAnneeEnCoursAnterieure: String, CulturalPracticeValueProtocol {
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
    
    func changeValueOfCulturalPractice(_ culturalPractice: CulturalPractice, index: Int?) -> CulturalPractice {
        var newCulturalPractice = culturalPractice
        newCulturalPractice.cultureAnneeEnCoursAnterieure = self
        return newCulturalPractice
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
    
    func getIndex() -> Int? {
        nil
    }
}

struct CulturalPracticeContainerElement: CulturalPracticeElementProtocol {
    let key: String
    let title: String
    var culturalInputElement: [CulturalPracticeElementProtocol]
    var culturalPracticeMultiSelectElement: [CulturalPracticeElementProtocol]
    var value: CulturalPracticeValueProtocol?
    
    func getIndex() -> Int? {
        nil
    }
}

struct CulturalPracticeMultiSelectElement: CulturalPracticeElementProtocol {
    let key: String
    var title: String
    var tupleCulturalTypeValue: [(CulturalPracticeValueProtocol, String)]
    var value: CulturalPracticeValueProtocol?
    var index: Int?
    
    func getIndex() -> Int? {
        index
    }
}

struct CulturalPracticeInputElement: CulturalPracticeElementProtocol {
    let key: String
    let title: String
    var valueEmpty: CulturalPracticeValueProtocol
    var value: CulturalPracticeValueProtocol?
    var index: Int?
    
    func getIndex() -> Int? {
        index
    }
}

protocol CulturalPracticeValueProtocol {
    static func getTitle() -> String
    func getValue() -> String
    static func getValues() -> [(CulturalPracticeValueProtocol, String)]?
    func getUnitType() -> UnitType?
    static func create(value: String) -> CulturalPracticeValueProtocol?
    static func getRegularExpression() -> String?
    func changeValueOfCulturalPractice(_ culturalPractice: CulturalPractice, index: Int?) -> CulturalPractice
}

extension CulturalPracticeElementProtocol {
    func getValueBy(indexSelected: Int, from values: [(CulturalPracticeValueProtocol, String)]) -> CulturalPracticeValueProtocol? {
        guard values.indices.contains(indexSelected) else { return nil }
        return values[indexSelected].0
    }
    
    func getValueBy(
        inputValue: String,
        from emptyValue: CulturalPracticeValueProtocol
    ) -> CulturalPracticeValueProtocol? {
        return type(of: emptyValue).create(value: inputValue)
    }
}

protocol CulturalPracticeElementProtocol {
    var title: String {get}
    var key: String {get}
    var value: CulturalPracticeValueProtocol? {get}
    func getIndex() -> Int?
}
