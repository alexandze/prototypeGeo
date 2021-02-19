//
//  ProducerMakeElementUIDataListFactory.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-31.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class ProducerMakeElementUIDataListFactoryImpl: ProducerMakeElementUIDataListFactory {
    let elementUIDataFactory: ElementUIDataFactory
    
    init(elementUIDataFactory: ElementUIDataFactory = ElementUIDataFactoryImpl()) {
        self.elementUIDataFactory = elementUIDataFactory
    }
    
    func makeElementUIDataListByProducer(_ producer: Producer) -> [ElementUIData] {
        Util.getMirrorChildrenOfTValue(producer)
            .map(mapMirrorChildLabelToInputElement(producer))
            .filter(Util.filterTValueNotNil(ElementUIData.self))
            .map(Util.mapUnwrapTValue(ElementUIData.self))
    }
    
    func makeElementUIDataList() -> [ElementUIData] {
        let producer = Producer()
        return makeElementUIDataListByProducer(producer)
    }
    
    private func mapMirrorChildLabelToInputElement(_ producer: Producer) -> (Mirror.Child) -> ElementUIData? {
    { (child: Mirror.Child) -> ElementUIData? in
        guard let label = child.label else { return nil }
        
        switch label {
        case FirstNameInputValue.getTypeValue():
            return self.elementUIDataFactory.makeElementUIData(FirstNameInputValue.self, producer.firstName)
        case LastNameInputValue.getTypeValue():
            return self.elementUIDataFactory.makeElementUIData(LastNameInputValue.self, producer.lastName)
        case EmailInputValue.getTypeValue():
            return self.makeEmailInputElement(producer)
        default:
            return nil
        }
        }
    }
    
    private func makeEmailInputElement(_ producer: Producer) -> ElementUIData? {
        var elementUIData = self.elementUIDataFactory.makeElementUIData(EmailInputValue.self, producer.email) as? InputElement
        elementUIData?.isRequired = false
        return elementUIData
    }
}

protocol ProducerMakeElementUIDataListFactory {
    func makeElementUIDataListByProducer(_ producer: Producer) -> [ElementUIData]
    func makeElementUIDataList() -> [ElementUIData]
}
