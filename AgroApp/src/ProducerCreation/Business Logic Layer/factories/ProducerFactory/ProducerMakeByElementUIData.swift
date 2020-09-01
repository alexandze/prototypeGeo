//
//  ProducerMakeByElementUIData.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-31.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class ProducerMakeByElementUIDataImpl: ProducerMakeByElementUIData {
    
    func makeProducerByElementUIData(_ elementUIData: ElementUIData) -> Producer {
        return makeProducer(Producer(), withElement: elementUIData)
    }
    
    func makeProducer(_ producer: Producer, withElement elementUIData: ElementUIData) -> Producer {
        let copyProducer = producer
        
        if let inputElement = elementUIData as? InputElement {
            return makeProducer(copyProducer, inputElement)
        }
        
        return copyProducer
    }
    
    private func makeProducer(_ producer: Producer, _ inputElement: InputElement) -> Producer {
        guard let typeValue = inputElement.typeValue else {
            return producer
        }
        
        var copyProducer = producer
        
        switch typeValue {
        case FirstNameInputValue.getTypeValue():
            copyProducer.firstName = FirstNameInputValue(value: inputElement.value)
        case LastNameInputValue.getTypeValue():
            copyProducer.lastName = LastNameInputValue(value: inputElement.value)
        case EmailInputValue.getTypeValue():
            copyProducer.email = EmailInputValue(value: inputElement.value)
        default:
            return copyProducer
        }
        
        return copyProducer
    }
}

protocol ProducerMakeByElementUIData {
    func makeProducer(_ producer: Producer, withElement elementUIData: ElementUIData) -> Producer
    func makeProducerByElementUIData(_ elementUIData: ElementUIData) -> Producer
}
