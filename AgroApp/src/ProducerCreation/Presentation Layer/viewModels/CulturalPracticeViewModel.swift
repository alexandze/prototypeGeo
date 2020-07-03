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

class CulturalPraticeViewModelImpl: CulturalPraticeViewModel {
    var currentField: FieldType?
    var sections: [Section<CulturalPracticeElementProtocol>]?
    var cellId: String = UUID().uuidString
    var headerFooterSectionViewId: String = UUID().uuidString
    let culturalPracticeStateObs: Observable<CulturalPracticeState>
    let actionDispatcher: ActionDispatcher
    var tableView: UITableView?
    var culturalPracticeStateDisposable: Disposable?
    var culturalPraticeView: CulturalPraticeView?

    var disposableDispatcher: Disposable?
    var viewController: CulturalPraticeViewController?

    init(
        culturalPracticeStateObs: Observable<CulturalPracticeState>,
        actionDispatcher: ActionDispatcher
    ) {
        self.culturalPracticeStateObs = culturalPracticeStateObs
        self.actionDispatcher = actionDispatcher
    }

    func subscribeToCulturalPracticeStateObs() {
        self.culturalPracticeStateDisposable =
            culturalPracticeStateObs
                .observeOn(MainScheduler.instance)
                .subscribe { element in
                    guard let culturalPracticeState = element.element,
                        let currentFieldType = culturalPracticeState.currentField,
                        let sections = culturalPracticeState.sections,
                        let tableState = culturalPracticeState.subAction
                        else { return }

                    self.setStateProperties(currentFieldType, sections)

                    switch tableState {
                    case .reloadData:
                        self.handleReloadData()
                    case .deletedRows(indexPath: let indexPaths):
                        //TODO effecer la cell en question
                        break
                    case .insertRows(indexPath: let indexPaths):
                        self.handleInsertRows(indexPaths: indexPaths, sections: sections)
                    case .updateRows(indexPath: let indexPaths):
                        self.handleUpdateRowAt(indexPath: indexPaths[0])
                    case .selectElementOnList(
                        culturalPracticeElement: let culturalPracticeElementSelected,
                        fieldType: let fieldType
                        ):
                        self.handleSelectElementOnList(
                            culturalParacticeElementSelected: culturalPracticeElementSelected,
                            fieldType: fieldType
                        )
                    case .canNotSelectElementOnList(culturalPracticeElement: _):
                        print("can not select")
                    }
        }
    }

    func disposeToCulturalPracticeStateObs() {
        self.culturalPracticeStateDisposable?.dispose()
        self.disposableDispatcher?.dispose()
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

    func getCulturePracticeElement(by indexPath: IndexPath) -> CulturalPracticeElementProtocol {
        sections![indexPath.section].rowData[indexPath.row]
    }

    private func presentSelectFormCulturalPracticeController() {
        let appDependency = viewController!.getAppDelegate()!.appDependencyContainer
        viewController?.present(appDependency.processInitCulturalPracticeFormViewController(), animated: true)
    }

    private func presentInputFormCulturalPracticeHostingController() {
        guard let appDependency = Util.getAppDependency() else { return }
        let inputFormCulturalPracticeHostingController = appDependency.processInitInputFormCulturalPracticeHostingController()
        viewController?.present(inputFormCulturalPracticeHostingController, animated: true)
    }

    private func createSelectedElementOnListAction(
        culturalPracticeSelectElement: CulturalPracticeElementProtocol,
        fieldType: FieldType
    ) -> CulturalPracticeFormAction.ElementSelectedOnList {
        CulturalPracticeFormAction.ElementSelectedOnList(
            culturalPracticeElement: culturalPracticeSelectElement,
            fieldType: fieldType,
            culturalPracticeFormSubAction: CulturalPracticeFormSubAction.newDataForm
        )
    }

    private func setStateProperties(_ currentFieldType: FieldType, _ sections: [Section<CulturalPracticeElementProtocol>]) {
        self.currentField = currentFieldType
        self.sections = sections
    }

    public func initCellFor(
        multiSelectElement: CulturalPracticeMultiSelectElement,
        cell: UITableViewCell
    ) -> UITableViewCell {
        self.culturalPraticeView!.initCellFor(multiSelectElement: multiSelectElement, cell: cell)
    }

    func initCellFor(addElement: CulturalPracticeAddElement, cell: UITableViewCell) -> UITableViewCell {
        culturalPraticeView!.initCellFor(
            addElement: addElement,
            cell: cell,
            handleAddButton: dispatchAddDoseFumier
        )
    }

    func initCellFor(containerElement: CulturalPracticeInputMultiSelectContainer, cell: UITableViewCell) -> UITableViewCell {
        culturalPraticeView!.initCellFor(
            containerElement: containerElement,
            cell: cell
        )
    }

    func initCellFor(inputElement: CulturalPracticeInputElement, cell: UITableViewCell) -> UITableViewCell {
        culturalPraticeView!.initCellFor(inputElement: inputElement, cell: cell)
    }
}
// handle methode
extension CulturalPraticeViewModelImpl {
    private func handleReloadData() {
        self.tableView?.reloadData()
    }

    private func handleInsertRows(
        indexPaths: [IndexPath],
        sections: [Section<CulturalPracticeElementProtocol>]
    ) {
        self.sections = sections
        self.tableView?.insertRows(at: indexPaths, with: .right)
    }

    private func handleUpdateRowAt(indexPath: IndexPath) {
        self.tableView?.reloadRows(at: [indexPath], with: .fade)
    }

    private func handleSelectElementOnList(
        culturalParacticeElementSelected: CulturalPracticeElementProtocol,
        fieldType: FieldType
    ) {
        dispatchSelectedElementOnList(
            culturalPracticeElement: culturalParacticeElementSelected,
            fieldType: fieldType
        )

        switch culturalParacticeElementSelected {
        case _ as CulturalPracticeMultiSelectElement:
            self.presentSelectFormCulturalPracticeController()
        case _ as CulturalPracticeInputElement:
            self.presentInputFormCulturalPracticeHostingController()
            break
        case _ as CulturalPracticeInputMultiSelectContainer:
            //TODO affcher le formualaire pour les containers
            break
        default:
            break
        }
    }

    public func tableView(didSelectRowAt indexPath: IndexPath) {
        self.dispathSelectElementOnList(indexPath: indexPath)
    }
}

// dispatcher methode
extension CulturalPraticeViewModelImpl {
    private func dispatchSelectedElementOnList(
        culturalPracticeElement: CulturalPracticeElementProtocol,
        fieldType: FieldType
    ) {
       let action = createSelectedElementOnListAction(
        culturalPracticeSelectElement: culturalPracticeElement,
        fieldType: fieldType
        )

        self.disposableDispatcher = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(action)
        }
    }

    private func dispatchAddDoseFumier() {
        self.disposableDispatcher = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(
                CulturalPracticeListAction.AddCulturalPracticeInputMultiSelectContainer()
            )
        }
    }

    private func dispathSelectElementOnList(indexPath: IndexPath) {
        let action = CulturalPracticeListAction.SelectElementOnListAction(indexPath: indexPath)

        self.disposableDispatcher = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(action)
        }
    }
}

protocol CulturalPraticeViewModel {
    var tableView: UITableView? {get set}
    var cellId: String {get}
    var culturalPraticeView: CulturalPraticeView? {get set}
    var viewController: CulturalPraticeViewController? {get set}
    var headerFooterSectionViewId: String {get}
    func subscribeToCulturalPracticeStateObs()
    func disposeToCulturalPracticeStateObs()
    func getNumberOfSection() -> Int
    func getNumberRow(in section: Int) -> Int
    func registerCell()
    func getCulturePracticeElement(by indexPath: IndexPath) -> CulturalPracticeElementProtocol
    func registerHeaderFooterViewSection()
    func initCellFor(multiSelectElement: CulturalPracticeMultiSelectElement, cell: UITableViewCell) -> UITableViewCell
    func initCellFor(containerElement: CulturalPracticeInputMultiSelectContainer, cell: UITableViewCell) -> UITableViewCell
    func initCellFor(inputElement: CulturalPracticeInputElement, cell: UITableViewCell) -> UITableViewCell
    func initCellFor(addElement: CulturalPracticeAddElement, cell: UITableViewCell) -> UITableViewCell
    func tableView(didSelectRowAt indexPath: IndexPath)
}
