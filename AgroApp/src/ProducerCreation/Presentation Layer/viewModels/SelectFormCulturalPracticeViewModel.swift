//
//  CulturalPracticeFormViewModel.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class SelectFormCulturalPracticeViewModelImpl: SelectFormCulturalPracticeViewModel {
    let culturalPracticeFormObs: Observable<SelectFormCulturalPracticeState>
    let selectFormCulturalPracticeInterraction: SelectFormCulturalPracticeInterraction
    var disposableCulturalPracticeFormObs: Disposable?
    var disposableDispatcher: Disposable?
    var setSelectedRow: ((Int) -> Void)?
    var getSelectedRow: (() -> Int)?
    var reloadPickerView: (() -> Void)?
    var setTitleText: ((String) -> Void)?
    var setDetailText: ((String) -> Void)?
    var dismissViewController: (() -> Void)?
    var printAlert: (() -> Void)?
    var state: SelectFormCulturalPracticeState?
    
    init(
        culturalPracticeFormObs: Observable<SelectFormCulturalPracticeState>,
        selectFormCulturalPracticeInterraction: SelectFormCulturalPracticeInterraction
    ) {
        self.culturalPracticeFormObs = culturalPracticeFormObs
        self.selectFormCulturalPracticeInterraction = selectFormCulturalPracticeInterraction
    }
    
    public func subscribeToCulturalPracticeFormObs() {
        disposableCulturalPracticeFormObs = culturalPracticeFormObs
            .observeOn(Util.getSchedulerMain())
            .subscribe {[weak self] event in
                guard let self = self,
                    let state = event.element,
                    let actionResponse = state.actionResponse else { return }
                
                self.setState(state)
                
                switch actionResponse {
                case .selectElementSelectedOnListActionResponse(currentIndexRow: let currentIndexRow):
                    self.handleSelectElementSelectedOnListActionResponse(currentIndexRow)
                case .closeSelectFormWithSaveActionResponse:
                    self.handleCloseSelectFormWithSaveActionResponse()
                case .closeSelectFormWithoutSaveAction:
                    self.handleCloseSelectFormWithoutSaveAction()
                case .checkIfFormIsDirtyActionResponse(isDirty: let isDirty):
                    self.handleCheckIfFormIsDirtyActionResponse(isDirty)
                }
        }
    }
    
    func disposeToCulturalPracticeFormObs() {
        _ = Util.runInSchedulerBackground {
            self.disposableCulturalPracticeFormObs?.dispose()
        }
    }
    
    func getNumberOfRows() -> Int {
        state?.selectElement?.values.count ?? 0
    }
    
    func getValueByRow(_ row: Int) -> String? {
        guard let valueList = state?.selectElement?.values,
            Util.hasIndexInArray(valueList, index: row) else {
                return nil
        }
        
        return valueList[row].1
    }
    
    private func setState(_ state: SelectFormCulturalPracticeState) {
        self.state = state
    }
    
    private func setTextForm() {
        guard let selectElement = state?.selectElement,
            let field = state?.field else {
                return
        }
        
        setTitleText?(selectElement.title)
        setDetailText?("Choisir une valeur pour la parcelle \(field.id)")
    }
    
    deinit {
        print("*** deinit SelectFormCulturalPracticeViewModelImpl ****")
    }
}

// extention handler methode
extension SelectFormCulturalPracticeViewModelImpl {
    func handleCloseButton() {
        guard let indexSelected = getSelectedRow?() else {
            return
        }
        
        selectFormCulturalPracticeInterraction.checkIfFormIsDirtyAction(indexSelected)
    }
    
    func handleValidateButton() {
        guard let index = getSelectedRow?() else {
            return
        }
        
        selectFormCulturalPracticeInterraction.closeSelectFormWithSaveAction(indexSelected: index)
    }
    
    func handleYesButtonAlert() {
        guard let indexSelected = getSelectedRow?() else {
            return
        }
        
        self.selectFormCulturalPracticeInterraction.closeSelectFormWithSaveAction(indexSelected: indexSelected)
    }
    
    func handleNoButtonAlert() {
        selectFormCulturalPracticeInterraction.closeSelectFormWithoutSaveAction()
    }
    
    private func handleCheckIfFormIsDirtyActionResponse(_ isDirty: Bool) {
        if isDirty {
            printAlert?()
            return
        }
        
        self.selectFormCulturalPracticeInterraction.closeSelectFormWithoutSaveAction()
    }
    
    private func handleSelectElementSelectedOnListActionResponse(_ currentIndexRow: Int) {
        setTextForm()
        reloadPickerView?()
        setSelectedRow?(currentIndexRow)
    }
    
    private func handleCloseSelectFormWithSaveActionResponse() {
        guard let field = state?.field,
            let section = state?.section else {
                return
        }
        
        selectFormCulturalPracticeInterraction.updateCulturalPracticeElementAction(section, field)
        dismissViewController?()
    }
    
    private func handleCloseSelectFormWithoutSaveAction() {
        dismissViewController?()
    }
}

protocol SelectFormCulturalPracticeViewModel {
    var getSelectedRow: (() -> Int)? { get set}
    var setSelectedRow: ((Int) -> Void)? { get set}
    var reloadPickerView: (() -> Void)? { get set }
    var setTitleText: ((String) -> Void)? { get set }
    var setDetailText: ((String) -> Void)? { get set }
    var dismissViewController: (() -> Void)? { get set }
    var printAlert: (() -> Void)? { get set }
    func subscribeToCulturalPracticeFormObs()
    func disposeToCulturalPracticeFormObs()
    func handleCloseButton()
    func handleValidateButton()
    func handleYesButtonAlert()
    func handleNoButtonAlert()
    func getNumberOfRows() -> Int
    func getValueByRow(_ row: Int) -> String?
}
