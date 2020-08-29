//
//  FieldCuturalPracticeViewModel.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class CulturalPraticeFormViewModelImpl: CulturalPraticeFormViewModel {
    var reloadTableView: (() -> Void)?
    var insertSections: (([IndexPath]) -> Void)?
    var reloadSections: (([IndexPath]) -> Void)?
    var cellId: String = UUID().uuidString
    var headerFooterSectionViewId: String = UUID().uuidString
    let culturalPracticeStateObs: Observable<CulturalPracticeFormState>
    let culturalPraticeFormInteraction: CulturalPraticeFormInteraction
    var culturalPracticeStateDisposable: Disposable?
    var disposableDispatcher: Disposable?
    var state: CulturalPracticeFormState?
    weak var viewController: CulturalPracticeFormViewController?
    
    init(
        culturalPracticeStateObs: Observable<CulturalPracticeFormState>,
        culturalPraticeFormInteraction: CulturalPraticeFormInteraction
    ) {
        self.culturalPracticeStateObs = culturalPracticeStateObs
        self.culturalPraticeFormInteraction = culturalPraticeFormInteraction
    }
    
    func subscribeToCulturalPracticeStateObs() {
        self.culturalPracticeStateDisposable =
            culturalPracticeStateObs
                .observeOn(MainScheduler.instance)
                .subscribe {[weak self] element in
                    guard let culturalPracticeState = element.element,
                        let responseAction = culturalPracticeState.responseAction,
                        let self = self
                        else { return }
                    
                    self.setState(state: culturalPracticeState)
                    
                    switch responseAction {
                    case .selectFieldOnListActionResponse:
                        self.handleSelectFieldOnListActionResponse()
                    case .addDoseFumierActionResponse(
                        indexPaths: let indexPaths,
                        isMaxDoseFumier: let isMaxDoseFumier,
                        isFinishCompletedLastDoseFumier: let isFinishCompletedLastDoseFumier):
                        self.handleAddDoseFumierActionResponse(indexPaths, isMaxDoseFumier, isFinishCompletedLastDoseFumier)
                    case .updateElementResponse(indexPaths: let indexPaths):
                        self.handleUpdateElementResponse(indexPaths)
                    case .selectElementOnListResponse(section: let section):
                        
                    case .removeDoseFumierResponse(indexPathsRemove: let indexPathsRemove, indexPathsAdd: let indexPathsAdd):
                        
                    case .notResponse:
                        break
                    }
        }
    }
    
    func disposeToCulturalPracticeStateObs() {
        // TODO creater une fonction dans util
        _ = Util.runInSchedulerBackground {
            self.culturalPracticeStateDisposable?.dispose()
        }
    }
    
    func getNumberOfSection() -> Int {
        self.state?.sections?.count ?? 0
    }
    
    func getTypeSectionByIndexPath(_ indexPath: IndexPath) -> String {
        self.state?.sections?[indexPath.section].typeSection ?? ""
    }
    
    func getElementUIDataByIndexPath(_ indexPath: IndexPath) -> ElementUIData? {
        guard let sections = state?.sections,
            Util.hasIndexInArray(sections, index: indexPath.section),
            Util.hasIndexInArray(sections[indexPath.section].rowData, index: indexPath.row),
            let typeSection = sections[indexPath.section].typeSection else {
            return nil
        }
        
        switch typeSection {
        case InputElement.TYPE_ELEMENT:
            return sections[indexPath.section].rowData[indexPath.row]
        case SelectElement.TYPE_ELEMENT:
            return sections[indexPath.section].rowData[indexPath.row]
        case ElementUIListData.TYPE_ELEMENT:
            return ElementUIListData(
                title: sections[indexPath.section].sectionName,
                elements: sections[indexPath.section].rowData,
                index: sections[indexPath.section].index ?? 0
            )
        case RowWithButton.TYPE_ELEMENT:
            return sections[indexPath.section].rowData[indexPath.row]
        default:
            return nil
        }
    }
    
    func handleCanEditRowByIndexPath(_ indexPath: IndexPath) -> Bool {
        guard let element = getElementUIDataByIndexPath(indexPath) else { return false }
        return element is ElementUIListData
    }
    
    private func setState(state: CulturalPracticeFormState) {
        self.state = state
    }
    
    deinit {
        print("***** denit CulturalPraticeFormViewModelImpl *******")
    }
}

// MARK: - handle methode

extension CulturalPraticeFormViewModelImpl {
    func handleFieldButton() {
        // TODO action pour afficher la liste des information sur la parcelle
    }
    
    func handleCulturalPracticeButton() {
        // TODO action pour afficher la liste des informations sur les pratiques culutrelles
    }
    
    func handleSelectRow(_ indexPath: IndexPath) {
        guard let typeSection = state?.sections?[indexPath.section].typeSection,
            typeSection != RowWithButton.TYPE_ELEMENT else { return }
        
        culturalPraticeFormInteraction.selectElementOnListAction(indexPath: indexPath)
    }
    
    func handleAddDoseFumierButton() {
        culturalPraticeFormInteraction.addDoseFumierAction()
    }
    
    func handleRemoveDoseFumierButtonByIndexPath(_ indexPath: IndexPath, editingStyle: UITableViewCell.EditingStyle) {
        if case UITableViewCell.EditingStyle.delete = editingStyle {
            return culturalPraticeFormInteraction.removeDoseFumierAction(indexPath: indexPath)
        }
    }
    
    private func handleSelectFieldOnListActionResponse() {
        reloadTableView?()
        culturalPraticeFormInteraction.setCurrentViewControllerInNavigationAction()
        culturalPraticeFormInteraction.setTitleAction(title: state?.title ?? "")
    }
    
    private func handleAddDoseFumierActionResponse(
        _ indexPaths: [IndexPath],
        _ isMaxDoseFumier: Bool,
        _ isFinishCompletedLastDoseFumier: Bool
    ) {
        guard !isMaxDoseFumier && isFinishCompletedLastDoseFumier && !indexPaths.isEmpty else {
            return
        }
        
        self.insertSections?(indexPaths)
    }
    
    private func handleUpdateElementResponse(_ indexPaths: [IndexPath]) {
        guard !indexPaths.isEmpty else { return }
        
        reloadSections?(indexPaths)
    }
}

protocol CulturalPraticeFormViewModel {
    var reloadTableView: (() -> Void)? { get set }
    var insertSections: (([IndexPath]) -> Void)? { get set }
    var reloadSections: (([IndexPath]) -> Void)? { get set }
    func getNumberOfSection() -> Int
    func subscribeToCulturalPracticeStateObs()
    func handleFieldButton()
    func handleCulturalPracticeButton()
    func disposeToCulturalPracticeStateObs()
    func getTypeSectionByIndexPath(_ indexPath: IndexPath) -> String
    func handleSelectRow(_ indexPath: IndexPath)
    func getElementUIDataByIndexPath(_ indexPath: IndexPath) -> ElementUIData?
    func handleAddDoseFumierButton()
    func handleRemoveDoseFumierButtonByIndexPath(_ indexPath: IndexPath, editingStyle: UITableViewCell.EditingStyle)
    func handleCanEditRowByIndexPath(_ indexPath: IndexPath) -> Bool
}
