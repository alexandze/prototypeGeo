//
//  ProducerService.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class ProducerServiceImpl: ProducerService {
    let producerMakeElementUIDataListFactory: ProducerMakeElementUIDataListFactory
    let producerMakeByElementUIData: ProducerMakeByElementUIData
    
    init(
        producerMakeElementUIDataListFactory: ProducerMakeElementUIDataListFactory = ProducerMakeElementUIDataListFactoryImpl(),
        producerMakeByElementUIData: ProducerMakeByElementUIData = ProducerMakeByElementUIDataImpl()
    ) {
        self.producerMakeElementUIDataListFactory = producerMakeElementUIDataListFactory
        self.producerMakeByElementUIData = producerMakeByElementUIData
    }
    
    func makeElementUIDataListByProducer(_ producer: Producer) -> [ElementUIData] {
        producerMakeElementUIDataListFactory.makeElementUIDataListByProducer(producer)
    }
    
    func makeElementUIDataList() -> [ElementUIData] {
        producerMakeElementUIDataListFactory.makeElementUIDataList()
    }
    
    func makeProducer(_ producer: Producer, withElement elementUIData: ElementUIData) -> Producer {
        producerMakeByElementUIData.makeProducer(producer, withElement: elementUIData)
    }
    
    func makeProducerByElementUIData(_ elementUIData: ElementUIData) -> Producer {
        producerMakeByElementUIData.makeProducerByElementUIData(elementUIData)
    }
}

protocol ProducerService {
    func makeElementUIDataListByProducer(_ producer: Producer) -> [ElementUIData]
    func makeElementUIDataList() -> [ElementUIData]
    func makeProducer(_ producer: Producer, withElement elementUIData: ElementUIData) -> Producer
    func makeProducerByElementUIData(_ elementUIData: ElementUIData) -> Producer
}
