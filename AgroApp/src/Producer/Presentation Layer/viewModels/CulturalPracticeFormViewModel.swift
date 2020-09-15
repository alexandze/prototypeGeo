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
    var presentInputFormController: (() -> Void)?
    var presentSelectFormController: (() -> Void)?
    var presentContainerElementController: (() -> Void)?
    var deletedAndAddSection: (([IndexPath], [IndexPath]) -> Void)?
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
                        isFinishCompletedLastDoseFumier: let isFinishCompletedLastDoseFumier,
                        isCurrrentSectionIsCulturalPractice: let isCurrrentSectionIsCulturalPractice):
                        self.handleAddDoseFumierActionResponse(
                            indexPaths, isMaxDoseFumier,
                            isFinishCompletedLastDoseFumier,
                            isCurrrentSectionIsCulturalPractice
                        )
                    case .updateElementResponse(indexPaths: let indexPaths):
                        self.handleUpdateElementResponse(indexPaths)
                    case .selectElementOnListResponse(section: let section):
                        self.handleSelectElementOnListResponse(section)
                    case .removeDoseFumierResponse(
                        indexPathsRemove: let indexPathsRemove,
                        indexPathsAdd: let indexPathsAdd,
                        isCurrrentSectionIsCulturalPractice: let isCurrrentSectionIsCulturalPractice):
                        self.handleRemoveDoseFumierResponse(indexPathsRemove, indexPathsAdd, isCurrrentSectionIsCulturalPractice)
                    case .showFieldDataSectionListActionResponse(
                        indexPathRemove: let indexPathRemoveList,
                        indexPathAdd: let indexPathAddList):
                        self.handleShowFieldDataSectionListActionResponse(indexPathRemoveList, indexPathAddList)
                    case .showCulturalPracticeDataSectionListActionResponse(
                        indexPathRemove: let indexPathRemoveList,
                        indexPathAdd: let indexPathAddList):
                        self.handleShowCulturalPracticeDataSectionListActionResponse(indexPathRemoveList, indexPathAddList)
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
    
    func dispatchHideValidateButtonOfContainer() {
        culturalPraticeFormInteraction.hideValidateButtonOfContainerAction()
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
    
    private func presentInputElementAction(_ section: Section<ElementUIData>, _ field: Field) {
        _ = culturalPraticeFormInteraction
            .selectedInputElementOnListActionObs(section: section, field: field)
            .subscribe {[weak self] _ in
                self?.presentInputFormController?()
        }
    }
    
    private func presentSelectElementAction(_ section: Section<ElementUIData>, _ field: Field) {
        _ = culturalPraticeFormInteraction
            .selectedSelectElementOnListActionObs(section: section, field: field)
            .subscribe { [weak self] _ in
                self?.presentSelectFormController?()
        }
    }
    
    private func presentContainerElementAction(_ section: Section<ElementUIData>, _ field: Field) {
        _ = culturalPraticeFormInteraction
            .selectedContainerElementObs(section: section, field: field)
            .subscribe { [weak self] _ in
                self?.presentContainerElementController?()
        }
    }
    
    private func dispatchUpdateFieldAction() {
        guard let field = state?.currentField else {
            return
        }
        
        culturalPraticeFormInteraction.updateFieldAction(field: field)
    }
    
    deinit {
        print("***** denit CulturalPraticeFormViewModelImpl *******")
    }
}

// MARK: - handle methode

extension CulturalPraticeFormViewModelImpl {
    func handleFieldButton() {
        culturalPraticeFormInteraction.showFieldDataSectionListAction()
    }
    
    func handleCulturalPracticeButton() {
        culturalPraticeFormInteraction.showCulturalPracticeDataSectionListAction()
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
        _ isFinishCompletedLastDoseFumier: Bool,
        _ isCurrrentSectionIsCulturalPractice: Bool
    ) {
        guard !isMaxDoseFumier && isFinishCompletedLastDoseFumier && !indexPaths.isEmpty, isCurrrentSectionIsCulturalPractice else {
            return
        }
        
        self.insertSections?(indexPaths)
    }
    
    private func handleUpdateElementResponse(_ indexPaths: [IndexPath]) {
        guard !indexPaths.isEmpty else { return }
        reloadSections?(indexPaths)
        dispatchUpdateFieldAction()
    }
    
    private func handleSelectElementOnListResponse(_ section: Section<ElementUIData>) {
        guard let typeSection = section.typeSection,
            let field = state?.currentField else { return }
        
        switch typeSection {
        case InputElement.TYPE_ELEMENT:
            self.presentInputElementAction(section, field)
        case SelectElement.TYPE_ELEMENT:
            self.presentSelectElementAction(section, field)
        case ElementUIListData.TYPE_ELEMENT:
            self.presentContainerElementAction(section, field)
        default:
            return
        }
    }
    
    private func handleRemoveDoseFumierResponse(
        _ indexPathsRemove: [IndexPath],
        _ indexPathsAdd: [IndexPath],
        _ isCurrrentSectionIsCulturalPractice: Bool
    ) {
        
        if isCurrrentSectionIsCulturalPractice {
            deletedAndAddSection?(indexPathsRemove, indexPathsAdd)
        }
        
        dispatchUpdateFieldAction()
    }
    
    private func handleShowFieldDataSectionListActionResponse(
        _ indexPathRemoveList: [IndexPath],
        _ indexPathAddList: [IndexPath]
    ) {
        deletedAndAddSection?(indexPathRemoveList, indexPathAddList)
    }
    
    private func handleShowCulturalPracticeDataSectionListActionResponse(
        _ indexPathRemoveList: [IndexPath],
        _ indexPathAddList: [IndexPath]
    ) {
        deletedAndAddSection?(indexPathRemoveList, indexPathAddList)
    }
}

protocol CulturalPraticeFormViewModel {
    var reloadTableView: (() -> Void)? { get set }
    var insertSections: (([IndexPath]) -> Void)? { get set }
    var reloadSections: (([IndexPath]) -> Void)? { get set }
    var deletedAndAddSection: (([IndexPath], [IndexPath]) -> Void)? { get set }
    var presentInputFormController: (() -> Void)? { get set}
    var presentSelectFormController: (() -> Void)? { get set }
    var presentContainerElementController: (() -> Void)? { get set }
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
    func dispatchHideValidateButtonOfContainer()
    
}
