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
    var title: String?
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
                        let tableState = culturalPracticeState.subAction,
                        let title = culturalPracticeState.title
                        else { return }

                    self.setStateProperties(currentFieldType, sections, title)

                    switch tableState {
                    case .reloadData:
                        self.handleReloadData()
                        self.dispatchSetCurrentViewControllerInNavigationAction()
                        self.dispatchSetTitleAction()
                    case .deletedRows(indexPath: let indexPaths):
                        //TODO effecer la cell en question
                        break
                    case .insertRows(indexPath: let indexPaths):
                        self.handleInsertRows(indexPaths: indexPaths, sections: sections)
                    case .updateRows(indexPath: let indexPaths):
                        self.handleUpdateRowAt(indexPath: indexPaths[0])
                    case .willSelectElementOnList(
                        culturalPracticeElement: let culturalPracticeElementSelected,
                        fieldType: let fieldType
                        ):
                        self.handleWillSelectElementOnList(
                            culturalParacticeElementSelected: culturalPracticeElementSelected,
                            fieldType: fieldType
                        )
                    case .canNotSelectElementOnList(culturalPracticeElement: _):
                        print("can not select")
                    }
        }
    }

    func disposeToCulturalPracticeStateObs() {
        _ = Util.runInSchedulerBackground {
            self.culturalPracticeStateDisposable?.dispose()
        }
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

    private func setStateProperties(_ currentFieldType: FieldType, _ sections: [Section<CulturalPracticeElementProtocol>], _ title: String) {
        self.currentField = currentFieldType
        self.sections = sections
        self.title = title
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

    private func handleWillSelectElementOnList(
        culturalParacticeElementSelected: CulturalPracticeElementProtocol,
        fieldType: FieldType
    ) {
        switch culturalParacticeElementSelected {
        case let selectElement as CulturalPracticeMultiSelectElement:
            self.handleSelectedSelectElementOnList(selectElement: selectElement, fieldType)
        case let inputElement as CulturalPracticeInputElement:
            self.handleSelectedInputElement(inputElement: inputElement, fieldType)
        case let containerElement as CulturalPracticeContainerElement:
            self.handleSelectedContainerOnList(containerElement: containerElement, fieldType)
        default:
            break
        }
    }

    private func handleSelectedContainerOnList(
        containerElement: CulturalPracticeContainerElement,
        _ fieldType: FieldType
    ) {
        _ = dispatchSelectedContainerElementOnListObs(containerElement: containerElement, fieldType: fieldType)
            .subscribe { _ in
                self.presentContainerFormCulturalPracticeHostingController()
        }
    }

    private func handleSelectedInputElement(
        inputElement: CulturalPracticeInputElement,
        _ fieldType: FieldType
    ) {
        _ = dispatchSelectedInputElementOnListObs(
            inputElement: inputElement,
            fieldType: fieldType
        ).subscribe { _ in
            self.presentInputFormCulturalPracticeHostingController()
        }
    }

    private func handleSelectedSelectElementOnList(
        selectElement: CulturalPracticeMultiSelectElement,
        _ fieldType: FieldType
    ) {
        _ = dispatchSelectedSelectElementOnListObs(
            culturalPracticeElement: selectElement,
            fieldType: fieldType
        ).subscribe { _ in
            self.presentSelectFormCulturalPracticeController()
        }
    }

    public func tableView(didSelectRowAt indexPath: IndexPath) {
        self.dispathWillSelectElementOnList(indexPath: indexPath)
    }
}

// dispatcher methode
extension CulturalPraticeFormViewModelImpl {

    func dispatchSetCurrentViewControllerInNavigationAction() {
        let action = ContainerTitleNavigationAction
            .SetCurrentViewControllerInNavigationAction(currentViewControllerInNavigation: .fieldList)
        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(action)
        }
    }

    /// action for set title of TitleNavigationViewController
    func dispatchSetTitleAction() {
        let action = ContainerTitleNavigationAction.SetTitleAction(title: title ?? "")

        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(action)
        }

    }

    private func dispatchSelectedSelectElementOnListObs(
        culturalPracticeElement: CulturalPracticeElementProtocol,
        fieldType: FieldType
    ) -> Completable {
        Util.createRunCompletable {
            let action = self.createSelectedSelectElementOnListAction(
                culturalPracticeSelectElement: culturalPracticeElement,
                fieldType: fieldType
            )

            self.actionDispatcher.dispatch(action)
        }
    }

    private func dispatchSelectedInputElementOnListObs(
        inputElement: CulturalPracticeInputElement,
        fieldType: FieldType
    ) -> Completable {
        Util.createRunCompletable {
            let action = self.createSelectedInputElementOnListAction(
                inputElement: inputElement,
                fieldType: fieldType
            )

            self.actionDispatcher.dispatch(action)
        }
    }

    private func dispatchSelectedContainerElementOnListObs(
        containerElement: CulturalPracticeContainerElement,
        fieldType: FieldType
    ) -> Completable {
        Util.createRunCompletable {
            let action = ContainerFormCulturalPracticeAction
                .ContainerElementSelectedOnListAction(
                    containerElement: containerElement,
                    field: fieldType
            )

            self.actionDispatcher.dispatch(action)
        }
    }

    private func dispatchAddDoseFumier() {
        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(
                CulturalPracticeFormAction.AddCulturalPracticeInputMultiSelectContainer()
            )
        }
    }

    private func dispathWillSelectElementOnList(indexPath: IndexPath) {
        let action = CulturalPracticeFormAction.WillSelectElementOnListAction(indexPath: indexPath)

        _ = Util.runInSchedulerBackground {
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
