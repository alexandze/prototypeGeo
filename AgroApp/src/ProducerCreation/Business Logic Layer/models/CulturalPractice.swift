//
//  CulturalPractice.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-02-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct CulturalPractice {
    var id: Int?
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
    var idPleinTerre: IdPleineTerre?

    static let MAX_DOSE_FUMIER = 3

    init(id: Int? = nil) {
        self.id = id
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

    func removeDoseFumierIndex(indexRemove: Int?) -> CulturalPractice? {
        guard let indexRemove = indexRemove else { return nil }
        var copyCulturalPractice = self

        if hasIndexInArray(elements: copyCulturalPractice.doseFumier, index: indexRemove) {
            copyCulturalPractice.doseFumier?.remove(at: indexRemove)
        }

        if hasIndexInArray(elements: copyCulturalPractice.delaiIncorporationFumier, index: indexRemove) {
            copyCulturalPractice.delaiIncorporationFumier?.remove(at: indexRemove)
        }

        if hasIndexInArray(elements: copyCulturalPractice.periodeApplicationFumier, index: indexRemove) {
            copyCulturalPractice.periodeApplicationFumier?.remove(at: indexRemove)
        }

        let doseFumiers = resetDoseFumier(dose: copyCulturalPractice.doseFumier)
        let delaiFumiers =  resetDoseFumier(dose: copyCulturalPractice.delaiIncorporationFumier)
        let periodeFumiers = resetDoseFumier(dose: copyCulturalPractice.periodeApplicationFumier)

        copyCulturalPractice.doseFumier = doseFumiers
        copyCulturalPractice.delaiIncorporationFumier = delaiFumiers
        copyCulturalPractice.periodeApplicationFumier = periodeFumiers

        return copyCulturalPractice
    }

    func resetDoseFumier<T>(dose: [T?]?) -> [T?] {
        var doseReset = [T?]()

        (0..<CulturalPractice.MAX_DOSE_FUMIER).forEach { index in
            if !hasIndexInArray(elements: dose, index: index) {
                return doseReset.append(nil)
            }

            doseReset.append(dose?[index])
        }

        return doseReset
    }

    private func getValueInArray<T>(elements: [T?]?, index: Int) -> T? {
        guard let count = elements?.count, count > index else { return nil }
        return elements?[index]
    }

    private func hasIndexInArray<T>(elements: [T?]?, index: Int?) -> Bool {
        return elements?.count != nil && index != nil && elements!.count > index!
    }

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
            index: index,
            culturalInputElement: [
                DoseFumier.getCulturalPracticeElement(id: index, culturalPractice: nil)
            ],
            culturalPracticeMultiSelectElement: [
                PeriodeApplicationFumier.getCulturalPracticeElement(id: index, culturalPractice: nil),
                DelaiIncorporationFumier.getCulturalPracticeElement(id: index, culturalPractice: nil)
            ]
        )
    }

    static func getCulturalPracticeDynamic(from culturalPractice: CulturalPractice?) -> [CulturalPracticeElementProtocol]? {
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
                        index: index,
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

extension CulturalPractice: Codable {
    func encode(to encoder: Encoder) throws {

    }

    // swiftlint:disable all
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = try? container.decode(
                Int.self,
                forKey: .id
            )
            
            avaloir = try? container.decode(
                Avaloir.self,
                forKey: .avaloir
            )
            
            bandeRiveraine = try? container.decode(
                BandeRiveraine.self,
                forKey: .bandeRiveraine
            )
            
            doseFumier = decodeDoseFumier(container: container)
            
            periodeApplicationFumier = decodePeriodeApplicationFumiers(
                container: container
            )
            
            periodeApplicationFumier = cleanArrayByDoseFumier(
                doseFumiers: doseFumier,
                culturalPracticeValueProtocols: periodeApplicationFumier
            )
            
            delaiIncorporationFumier = decodeDelaiIncorporationFumiers(
                container: container
            )
            
            delaiIncorporationFumier = cleanArrayByDoseFumier(
                doseFumiers: doseFumier,
                culturalPracticeValueProtocols: delaiIncorporationFumier
            )
            
            travailSol = try? container.decode(
                TravailSol.self,
                forKey: .travailSol
            )
            
            couvertureDerobee = try? container.decode(
                CouvertureDerobee.self,
                forKey: .couvertureDerobee
            )
            
            couvertureAssociee = try? container.decode(
                CouvertureAssociee.self,
                forKey: .couvertureAssociee
            )
            
            drainageSouterrain = try? container.decode(
                DrainageSouterrain.self,
                forKey: .drainageSouterrain
            )
            
            drainageSurface = try? container.decode(
                DrainageSurface.self,
                forKey: .drainageSurface
            )
            
            conditionProfilCultural = try? container.decode(
                ConditionProfilCultural.self,
                forKey: .conditionProfilCultural
            )
            
            tauxApplicationPhosphoreRang = decodeInputValue(
                container: container,
                codingKeys: .tauxApplicationPhosphoreRang,
                culturalPracticeValueProtocolType: TauxApplicationPhosphoreRang.self,
                typeReturnValue: TauxApplicationPhosphoreRang.self
            )
            
            tauxApplicationPhosphoreVolee = decodeInputValue(
                container: container,
                codingKeys: .tauxApplicationPhosphoreRang,
                culturalPracticeValueProtocolType: TauxApplicationPhosphoreVolee.self,
                typeReturnValue: TauxApplicationPhosphoreVolee.self
            )
            
            alMehlich3 = decodeInputValue(
                container: container,
                codingKeys: .alMehlich3,
                culturalPracticeValueProtocolType: AlMehlich3.self,
                typeReturnValue: AlMehlich3.self
            )
            
            pMehlich3 = decodeInputValue(
                container: container,
                codingKeys: .pMehlich3,
                culturalPracticeValueProtocolType: PMehlich3.self,
                typeReturnValue: PMehlich3.self
            )
            
            cultureAnneeEnCoursAnterieure = try? container.decode(
                CultureAnneeEnCoursAnterieure.self,
                forKey: .cultureAnneeEnCoursAnterieure
            )
            
        } catch {
            print(error.localizedDescription)
        }
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
        case couvertureDerobee = "Couv_derob"
        case drainageSouterrain = "Drai_Sout"
        case drainageSurface = "Drai_surf"
        case conditionProfilCultural = "Cond_hydro"
        case tauxApplicationPhosphoreRang = "MINP_B"
        case tauxApplicationPhosphoreVolee = "MINP_V"
        case pMehlich3 = "P_M3"
        case alMehlich3 = "AL_M3"
        case cultureAnneeEnCoursAnterieure = "util_terr"
    }
    
    private func decodeInputValue<R>(
        container: KeyedDecodingContainer<CulturalPractice.CodingKeys>,
        codingKeys: CodingKeys,
        culturalPracticeValueProtocolType: CulturalPracticeValueProtocol.Type,
        typeReturnValue: R.Type
    ) -> R? {
        let valueDecoded = decodeValue(container: container, codingKeys: codingKeys, typeDecode: Double.self)
        
        if let valueDecoded = valueDecoded {
            return culturalPracticeValueProtocolType.create(value: String(valueDecoded)) as? R
        }
        
        return nil
    }
    
    private func decodeDelaiIncorporationFumiers(
        container: KeyedDecodingContainer<CulturalPractice.CodingKeys>
    ) -> [DelaiIncorporationFumier?]? {
        let delaiIncorporationFumiersFromJson = decodeValues(
            container: container,
            codingKeys: [.delaiIncorporationFumier1, .delaiIncorporationFumier2, .delaiIncorporationFumier3],
            typeDecode: DelaiIncorporationFumier.self
        )
        
        return getCodableValuesWithCheck(codableValuesFromJson: delaiIncorporationFumiersFromJson)
    }
    
    private func decodePeriodeApplicationFumiers(
        container: KeyedDecodingContainer<CulturalPractice.CodingKeys>
    ) -> [PeriodeApplicationFumier?]? {
        let periodeApplicationFumierFromJson = decodeValues(
            container: container,
            codingKeys: [.periodeApplicationFumier1, .periodeApplicationFumier2, .periodeApplicationFumier3],
            typeDecode: PeriodeApplicationFumier.self
        )
        
        return getCodableValuesWithCheck(codableValuesFromJson: periodeApplicationFumierFromJson)
    }
    
    private func cleanArrayByDoseFumier<T: CulturalPracticeValueProtocol>(
        doseFumiers: [DoseFumier?]?,
        culturalPracticeValueProtocols: [T?]?
    ) -> [T?]? {
        guard let doseFumiers = doseFumiers,
            var culturalPracticeValueProtocols = culturalPracticeValueProtocols,
            doseFumiers.count == culturalPracticeValueProtocols.count
            else { return nil }
        
        (0..<doseFumiers.count).forEach { index in
            guard doseFumiers[index] == nil else { return }
            culturalPracticeValueProtocols[index] = nil
        }
        
        return culturalPracticeValueProtocols
    }
    
    private func getCodableValuesWithCheck<T: Codable>(
        codableValuesFromJson: [T?]
    ) -> [T?]? {
        var codableValues = getArrayOfDoseWithNilValue(T.self)
        let firstIndexOfNil = getIndexFirstNilValue(array: codableValuesFromJson)
        let endLoop = firstIndexOfNil != nil ? (firstIndexOfNil! + 1) : codableValuesFromJson.count
        
        if codableValuesFromJson.count <= codableValues.count {
            (0..<endLoop).forEach { index in
                codableValues[index] = codableValuesFromJson[index]
            }
        }
        
        return codableValues
    }
    
    private func decodeValues<T: Codable>(
        container: KeyedDecodingContainer<CulturalPractice.CodingKeys>,
        codingKeys: [CodingKeys],
        typeDecode: T.Type
    ) -> [T?] {
        codingKeys.map {
            self.decodeValue(
                container: container,
                codingKeys: $0,
                typeDecode: T.self
            )
        }
    }
    
    private func decodeValue<T: Codable>(
        container: KeyedDecodingContainer<CulturalPractice.CodingKeys>,
        codingKeys: CodingKeys,
        typeDecode: T.Type
    ) -> T? {
        try? container.decode(typeDecode.self, forKey: codingKeys)
    }
    
    private func decodeDoseFumier(container: KeyedDecodingContainer<CulturalPractice.CodingKeys>) -> [DoseFumier?]? {
        let doseFumier1 = getDoseFumierValue(container: container, codingKeys: .doseFumier1)
        let doseFumier2 = getDoseFumierValue(container: container, codingKeys: .doseFumier2)
        let doseFumier3 = getDoseFumierValue(container: container, codingKeys: .doseFumier3)
        return getAllDoseFumierUpToNilDose(doseFumierValues: [doseFumier1, doseFumier2, doseFumier3])
    }
    
    private func getDoseFumierValue(container: KeyedDecodingContainer<CulturalPractice.CodingKeys>, codingKeys: CodingKeys) -> Int? {
        guard let doseFumierValue = try? container.decode(Int.self, forKey: codingKeys),
            doseFumierValue > 0 else { return nil }
        
        return doseFumierValue
    }
    
    private func getAllDoseFumierUpToNilDose(doseFumierValues: [Int?]) -> [DoseFumier?]? {
        var doseFumiers = getArrayOfDoseWithNilValue(DoseFumier.self)
        let indexFirstNilValue = getIndexFirstNilValue(array: doseFumierValues)
        let endLoop = indexFirstNilValue ?? doseFumierValues.count
        
        if doseFumierValues.count <= doseFumiers.count {
            (0..<endLoop).forEach { index in
                doseFumiers[index] = createDoseFumier(dose: doseFumierValues[index]!)
            }
        }
        
        return doseFumiers
    }
    
    private func getArrayOfDoseWithNilValue<T>(_ type: T.Type) -> [T?] {
        var doses = [T?]()
        
        (0..<CulturalPractice.MAX_DOSE_FUMIER).forEach { _ in
            doses.append(nil)
        }
        
        return doses
    }
    
    private func createDoseFumier(dose: Int) -> DoseFumier {
        DoseFumier.dose(quantite: dose)
    }
    
    /// get index first nil value in array.  If array not have nil, the function return nil.
    /// - Parameter array: The array
    /// - Returns: The first index  nil value index or nil if array not content nil value
    private func getIndexFirstNilValue<T>(array: [T?]) -> Int? {
        return array.firstIndex { $0 == nil }
    }
}
