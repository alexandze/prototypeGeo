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
    var currentField: Field?
    var sections: [Section<CulturalPracticeElementProtocol>]?
    var cellId: String = UUID().uuidString
    var headerFooterSectionViewId: String = UUID().uuidString
    let culturalPracticeStateObs: Observable<CulturalPracticeFormState>
    let culturalPraticeFormInteraction: CulturalPraticeFormInteraction
    var tableView: UITableView?
    var culturalPracticeStateDisposable: Disposable?
    var culturalPraticeView: CulturalPracticeFormView?
    var title: String?
    var disposableDispatcher: Disposable?
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
                        let currentFieldType = culturalPracticeState.currentField,
                        let sections = culturalPracticeState.sections,
                        let tableState = culturalPracticeState.subAction,
                        let title = culturalPracticeState.title,
                        let self = self
                        else { return }

                    self.setStateProperties(currentFieldType, sections, title)

                    switch tableState {
                    case .reloadData:
                        self.handleReloadData()
                        self.culturalPraticeFormInteraction.dispatchSetCurrentViewControllerInNavigationAction()
                        self.culturalPraticeFormInteraction.dispatchSetTitleAction(title: self.title)
                    case .deletedRows(indexPath: let indexPaths):
                        //TODO effecer la cell en question
                        break
                    case .insertRows(indexPath: let indexPaths):
                        self.handleInsertRows(indexPaths: indexPaths, sections: sections)
                    case .updateRows(indexPath: let indexPaths):
                        self.handleUpdateRowAt(indexPath: indexPaths[0])
                    case .willSelectElementOnList(
                        culturalPracticeElement: let culturalPracticeElementSelected,
                        field: let field
                        ):
                        self.handleWillSelectElementOnList(
                            culturalParacticeElementSelected: culturalPracticeElementSelected,
                            field: field
                        )
                    case .canNotSelectElementOnList(culturalPracticeElement: _):
                        print("can not select")
                    case .removeDoseFumierResponse(indexPathsRemove: let indexPathsRemove, indexPathsAdd: let indexPathsAdd):
                        self.handleRemoveDoseFumier(indexPathsRemove: indexPathsRemove, indexPathsAdd: indexPathsAdd)
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

    private func setStateProperties(_ currentFieldType: Field, _ sections: [Section<CulturalPracticeElementProtocol>], _ title: String) {
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
            handleAddButton: {[weak self] in self?.culturalPraticeFormInteraction.dispatchAddDoseFumier() }
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

    deinit {
        print("***** denit CulturalPraticeFormViewModelImpl *******")
    }
}

// MARK: - handle methode

extension CulturalPraticeFormViewModelImpl {

    func handleRemoveDoseFumierOnTableView(editingStyle: UITableViewCell.EditingStyle, indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            culturalPraticeFormInteraction.dispatchRemoveDoseFumierAction(indexPath: indexPath)
        default:
            break
        }
    }

    func handleCanEditRow(indexPath: IndexPath) -> Bool {
        (getCulturePracticeElement(by: indexPath) as? CulturalPracticeContainerElement) != nil
    }

    func tableView(didSelectRowAt indexPath: IndexPath) {
        self.culturalPraticeFormInteraction.dispathWillSelectElementOnList(indexPath: indexPath)
    }

    private func handleRemoveDoseFumier(indexPathsRemove: [IndexPath], indexPathsAdd: [IndexPath]?) {
        self.tableView?.performBatchUpdates({
            self.tableView?.deleteRows(at: indexPathsRemove.sorted().reversed(), with: .left)

            indexPathsAdd.map {
                self.tableView?.insertRows(at: $0.sorted().reversed(), with: .left)
            }

        })
    }

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
        field: Field
    ) {
        switch culturalParacticeElementSelected {
        case let selectElement as CulturalPracticeMultiSelectElement:
            self.handleSelectedSelectElementOnList(selectElement: selectElement, field)
        case let inputElement as CulturalPracticeInputElement:
            self.handleSelectedInputElement(inputElement: inputElement, field)
        case let containerElement as CulturalPracticeContainerElement:
            self.handleSelectedContainerOnList(containerElement: containerElement, field)
        default:
            break
        }
    }

    private func handleSelectedContainerOnList(
        containerElement: CulturalPracticeContainerElement,
        _ field: Field
    ) {
        _ = culturalPraticeFormInteraction.dispatchSelectedContainerElementOnListObs(containerElement: containerElement, field: field)
            .subscribe { _ in
                self.presentContainerFormCulturalPracticeHostingController()
        }
    }

    private func handleSelectedInputElement(
        inputElement: CulturalPracticeInputElement,
        _ field: Field
    ) {
        _ = culturalPraticeFormInteraction.dispatchSelectedInputElementOnListObs(
            inputElement: inputElement,
            field: field
        ).subscribe { _ in
            self.presentInputFormCulturalPracticeHostingController()
        }
    }

    private func handleSelectedSelectElementOnList(
        selectElement: CulturalPracticeMultiSelectElement,
        _ field: Field
    ) {
        _ = culturalPraticeFormInteraction.dispatchSelectedSelectElementOnListObs(
            culturalPracticeElement: selectElement,
            field: field
        ).subscribe { _ in
            self.presentSelectFormCulturalPracticeController()
        }
    }
}

protocol CulturalPraticeFormViewModel {
    var tableView: UITableView? {get set}
    var cellId: String {get}
    var culturalPraticeView: CulturalPracticeFormView? {get set}
    var viewController: CulturalPracticeFormViewController? {get set}
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
    func handleRemoveDoseFumierOnTableView(editingStyle: UITableViewCell.EditingStyle, indexPath: IndexPath)
    func handleCanEditRow(indexPath: IndexPath) -> Bool
}
