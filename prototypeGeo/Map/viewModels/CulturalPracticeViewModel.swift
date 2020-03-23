//
//  FieldCuturalPracticeViewModel.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift

class CulturalPraticeViewModelImpl: CulturalPraticeViewModel {
    var culturalPracticeElements: [CulturalPracticeElement]?
    var currentField: FieldType?
    var sections: [Section<CulturalPracticeElement>]?
    var cellId: String = UUID().uuidString
    var headerFooterSectionViewId: String = UUID().uuidString
    let culturalPracticeStateObs: Observable<CulturalPracticeState>
    let actionDispatcher: ActionDispatcher
    var tableView: UITableView?
    var culturalPracticeStateDisposable: Disposable?

    init(
        culturalPracticeStateObs: Observable<CulturalPracticeState>,
        actionDispatcher: ActionDispatcher
    ) {
        self.culturalPracticeStateObs = culturalPracticeStateObs
        self.actionDispatcher = actionDispatcher
    }
    
    func subscribeToCulturalPracticeStateObs() {
        self.culturalPracticeStateDisposable =
            culturalPracticeStateObs.subscribe { element in
                guard let culturalPracticeState = element.element,
                    let culturalPracticeElements = culturalPracticeState.culturalPraticeElement,
                    let currentFieldType = culturalPracticeState.currentField,
                    let sections = culturalPracticeState.sections
                    else { return }
                
                self.culturalPracticeElements = culturalPracticeElements
                self.currentField = currentFieldType
                self.sections = sections
                self.tableView?.reloadData()
        }
    }
    
    func disposeToCulturalPracticeStateObs() {
        self.culturalPracticeStateDisposable?.dispose()
    }
    
    func getNumberOfSection() -> Int {
        sections?.count ?? 0
    }
    
    func getNumberRow(in section: Int) -> Int {
        sections?[section].rowData.count ?? 0
    }
    
    func registerCell() {
        self.tableView?.register(SubtitleTableViewCell.self, forCellReuseIdentifier: self.cellId)
    }
    
    func registerHeaderFooterViewSection() {
        self.tableView?.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: headerFooterSectionViewId)
    }
    
    func getCulturePracticeElement(by indexPath: IndexPath) -> CulturalPracticeElement {
        sections![indexPath.section].rowData[indexPath.row]
    }

}

protocol CulturalPraticeViewModel {
    var tableView: UITableView? {get set}
    var cellId: String {get}
    var headerFooterSectionViewId: String {get}
    func subscribeToCulturalPracticeStateObs()
    func disposeToCulturalPracticeStateObs()
    func getNumberOfSection() -> Int
    func getNumberRow(in section: Int) -> Int
    func registerCell()
    func getCulturePracticeElement(by indexPath: IndexPath) -> CulturalPracticeElement
    func registerHeaderFooterViewSection()
}
