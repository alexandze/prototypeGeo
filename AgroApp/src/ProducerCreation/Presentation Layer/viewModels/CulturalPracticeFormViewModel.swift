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
    var currentField: FieldType?
    var sections: [Section<CulturalPracticeElementProtocol>]?
    var cellId: String = UUID().uuidString
    var headerFooterSectionViewId: String = UUID().uuidString
    let culturalPracticeStateObs: Observable<CulturalPracticeFormState>
    let actionDispatcher: ActionDispatcher
    var tableView: UITableView?
    var culturalPracticeStateDisposable: Disposable?
    var culturalPraticeView: ListViewCulturalPractice?

    var disposableDispatcher: Disposable?
    var viewController: CulturalPraticeViewController?

    init(
        culturalPracticeStateObs: Observable<CulturalPracticeFormState>,
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

    private func presentContainerFormCulturalPracticeHostingController() {
        guard let appDependency = Util.getAppDependency() else { return }
        let containerFormCulturalPracticeHostingController = appDependency
            .makeContainerFormCulturalPracticeHostingController()

        viewController?.present(containerFormCulturalPracticeHostingController, animated: true)
    }

    private func createSelectedSelectElementOnListAction(
        culturalPracticeSelectElement: CulturalPracticeElementProtocol,
        fieldType: FieldType
    ) -> SelectFormCulturalPracticeAction.SelectElementSelectedOnList {
        SelectFormCulturalPracticeAction.SelectElementSelectedOnList(
            culturalPracticeElement: culturalPracticeSelectElement,
            fieldType: fieldType,
            subAction: SelectFormCulturalPracticeSubAction.newDataForm
        )
    }

    private func createSelectedInputElementOnListAction(
        inputElement: CulturalPracticeInputElement,
        fieldType: FieldType
    ) -> InputFormCulturalPracticeAction.InputElementSelectedOnListAction {
        InputFormCulturalPracticeAction.InputElementSelectedOnListAction(
            culturalPracticeInputElement: inputElement,
            fieldType: fieldType,
            subAction: .newFormData)
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

    func initCellFor(containerElement: CulturalPracticeContainerElement, cell: UITableViewCell) -> UITableViewCell {
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
extension CulturalPraticeFormViewModelImpl {
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
        switch culturalParacticeElementSelected {
        case _ as CulturalPracticeMultiSelectElement:
            dispatchSelectedSelectElementOnList(
                culturalPracticeElement: culturalParacticeElementSelected,
                fieldType: fieldType
            )
            self.presentSelectFormCulturalPracticeController()

        case let inputElement as CulturalPracticeInputElement:
            dispatchSelectedInputElementOnList(
                inputElement: inputElement,
                fieldType: fieldType
            )
            self.presentInputFormCulturalPracticeHostingController()

        case let containerElement as CulturalPracticeContainerElement:
            self.handleSelectedOnList(containerElement: containerElement, fieldType)
        default:
            break
        }
    }

    private func handleSelectedOnList(
        containerElement: CulturalPracticeContainerElement,
        _ fieldType: FieldType
    ) {
        dispatchSelectedContainerElementOnList(containerElement: containerElement, fieldType: fieldType)
        presentContainerFormCulturalPracticeHostingController()
    }

    public func tableView(didSelectRowAt indexPath: IndexPath) {
        self.dispathSelectElementOnList(indexPath: indexPath)
    }
}

// dispatcher methode
extension CulturalPraticeFormViewModelImpl {
    private func dispatchSelectedSelectElementOnList(
        culturalPracticeElement: CulturalPracticeElementProtocol,
        fieldType: FieldType
    ) {

        let action = createSelectedSelectElementOnListAction(
            culturalPracticeSelectElement: culturalPracticeElement,
            fieldType: fieldType
        )

        self.disposableDispatcher = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(action)
        }
    }

    private func dispatchSelectedInputElementOnList(
        inputElement: CulturalPracticeInputElement,
        fieldType: FieldType
    ) {
        let action = createSelectedInputElementOnListAction(
            inputElement: inputElement,
            fieldType: fieldType
        )

        self.disposableDispatcher = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(action)
        }
    }

    private func dispatchSelectedContainerElementOnList(
        containerElement: CulturalPracticeContainerElement,
        fieldType: FieldType
    ) {
        let action = ContainerFormCulturalPracticeAction
            .ContainerElementSelectedOnListAction(
                containerElement: containerElement,
                field: fieldType
        )

        self.disposableDispatcher = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(action)
        }
    }

    private func dispatchAddDoseFumier() {
        self.disposableDispatcher = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(
                CulturalPracticeFormAction.AddCulturalPracticeInputMultiSelectContainer()
            )
        }
    }

    private func dispathSelectElementOnList(indexPath: IndexPath) {
        let action = CulturalPracticeFormAction.SelectElementOnListAction(indexPath: indexPath)

        self.disposableDispatcher = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(action)
        }
    }
}

protocol CulturalPraticeFormViewModel {
    var tableView: UITableView? {get set}
    var cellId: String {get}
    var culturalPraticeView: ListViewCulturalPractice? {get set}
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
    func initCellFor(containerElement: CulturalPracticeContainerElement, cell: UITableViewCell) -> UITableViewCell
    func initCellFor(inputElement: CulturalPracticeInputElement, cell: UITableViewCell) -> UITableViewCell
    func initCellFor(addElement: CulturalPracticeAddElement, cell: UITableViewCell) -> UITableViewCell
    func tableView(didSelectRowAt indexPath: IndexPath)
}
