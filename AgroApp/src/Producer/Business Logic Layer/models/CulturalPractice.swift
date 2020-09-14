//
//  CulturalPractice.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-02-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

// ********** Not change name of Cultural practice porperties. The name of properties is use for reflection **************
// ********** If you change name, change a getTypeValue() func of SelectValue, InputValue *************
struct CulturalPractice {
    var id: Int?
    var avaloir: SelectValue?
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

    init(id: Int? = nil) {
        self.id = id
    }
    
    func isValid() -> Bool {
        id != nil &&
        avaloir != nil &&
        bandeRiveraine != nil &&
        travailSol != nil &&
        couvertureAssociee != nil &&
        couvertureDerobee != nil &&
        drainageSouterrain != nil &&
        drainageSurface != nil &&
        conditionProfilCultural != nil &&
        tauxApplicationPhosphoreRang != nil &&
        tauxApplicationPhosphoreVolee != nil &&
        pMehlich3 != nil &&
        alMehlich3 != nil &&
        cultureAnneeEnCoursAnterieure != nil &&
        isDoseFumierValid()
    }
    
    private func isDoseFumierValid() -> Bool {
        let doseFumierCount = doseFumier?.count
        let periodeApplicationFumierCount = periodeApplicationFumier?.count
        let delaiIncorporationFumierCount = delaiIncorporationFumier?.count
        
        return doseFumierCount == periodeApplicationFumierCount &&
        doseFumierCount == delaiIncorporationFumierCount &&
        periodeApplicationFumierCount == delaiIncorporationFumierCount
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
                container: container,
                countDoseFumier: doseFumier?.count ?? 0
            )
            
            
            delaiIncorporationFumier = decodeDelaiIncorporationFumiers(
                container: container,
                countDoseFumier: doseFumier?.count ?? 0
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
                inputValueType: TauxApplicationPhosphoreRang.self,
                typeReturnValue: TauxApplicationPhosphoreRang.self
            )
            
            tauxApplicationPhosphoreVolee = decodeInputValue(
                container: container,
                codingKeys: .tauxApplicationPhosphoreRang,
                inputValueType: TauxApplicationPhosphoreVolee.self,
                typeReturnValue: TauxApplicationPhosphoreVolee.self
            )
            
            alMehlich3 = decodeInputValue(
                container: container,
                codingKeys: .alMehlich3,
                inputValueType: AlMehlich3.self,
                typeReturnValue: AlMehlich3.self
            )
            
            pMehlich3 = decodeInputValue(
                container: container,
                codingKeys: .pMehlich3,
                inputValueType: PMehlich3.self,
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
        inputValueType: InputValue.Type,
        typeReturnValue: R.Type
    ) -> R? {
        let valueDecoded = decodeValue(container: container, codingKeys: codingKeys, typeDecode: Double.self)
        
        if let valueDecoded = valueDecoded, let inputValue =   inputValueType.make(value: String(valueDecoded)) as? R {
            return inputValue
        }
        
        return nil
    }
    
    private func decodeDelaiIncorporationFumiers(
        container: KeyedDecodingContainer<CulturalPractice.CodingKeys>,
        countDoseFumier: Int
    ) -> [DelaiIncorporationFumier]? {
        let delaiIncorporationFumiersFromJson = decodeValues(
            container: container,
            codingKeys: getCondingKeyArrayByCountDoseFumier(
                countDoseFumier,
                [.delaiIncorporationFumier1, .delaiIncorporationFumier2, .delaiIncorporationFumier3]
            ),
            typeDecode: DelaiIncorporationFumier.self
        )
        
        return delaiIncorporationFumiersFromJson
    }
    
    private func decodePeriodeApplicationFumiers(
        container: KeyedDecodingContainer<CulturalPractice.CodingKeys>,
        countDoseFumier: Int
    ) -> [PeriodeApplicationFumier]? {
        
        let periodeApplicationFumierFromJson = decodeValues(
            container: container,
            codingKeys: getCondingKeyArrayByCountDoseFumier(
                countDoseFumier,
                [CodingKeys.periodeApplicationFumier1, .periodeApplicationFumier2, .periodeApplicationFumier3]
            ),
            typeDecode: PeriodeApplicationFumier.self
        )
        
        return periodeApplicationFumierFromJson
    }
    
    private func getCondingKeyArrayByCountDoseFumier(_ countDoseFumier: Int, _ condingKeysDefault: [CodingKeys]) -> [CodingKeys] {
        var condingKeys = [CodingKeys]()
        
        (0..<countDoseFumier).forEach { index in
            if Util.hasIndexInArray(condingKeysDefault, index: index) {
                condingKeys.append(condingKeysDefault[index])
            }
        }
        
        return condingKeys
    }
    
    private func decodeValues<T: Codable>(
        container: KeyedDecodingContainer<CulturalPractice.CodingKeys>,
        codingKeys: [CodingKeys],
        typeDecode: T.Type
    ) -> [T] {
        let valueDecodeList = codingKeys.map {
            self.decodeValue(
                container: container,
                codingKeys: $0,
                typeDecode: T.self
            )
        }
        
        let firstNilIndex = valueDecodeList.firstIndex { $0 == nil }
        
        return (0..<(firstNilIndex ?? valueDecodeList.count)).map { index in
            valueDecodeList[index]!
        }
    }
    
    private func decodeValue<T: Codable>(
        container: KeyedDecodingContainer<CulturalPractice.CodingKeys>,
        codingKeys: CodingKeys,
        typeDecode: T.Type
    ) -> T? {
        try? container.decode(typeDecode.self, forKey: codingKeys)
    }
    
    private func decodeDoseFumier(container: KeyedDecodingContainer<CulturalPractice.CodingKeys>) -> [DoseFumier]? {
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
    
    private func getAllDoseFumierUpToNilDose(doseFumierValues: [Int?]) -> [DoseFumier]? {
        return doseFumierValues
            .filter { $0 != nil }
            .map { $0! }
            .map { doseFumierValue in
               DoseFumier(value: doseFumierValue)
        }
    }
    
}
