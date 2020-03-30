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
    var currentField: FieldType?
    var sections: [Section<CulturalPracticeElementProtocol>]?
    var cellId: String = UUID().uuidString
    var headerFooterSectionViewId: String = UUID().uuidString
    let culturalPracticeStateObs: Observable<CulturalPracticeState>
    let actionDispatcher: ActionDispatcher
    var tableView: UITableView?
    var culturalPracticeStateDisposable: Disposable?
    let TAG_ADD_BUTTON = 50
    var disposableAddContainerElement: Disposable?
    var disposableDispathActionSelectedElement: Disposable?
    var viewController: UIViewController?

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
                        let tableState = culturalPracticeState.culturalPracticeSubState
                        else { return }

                    self.setStateProperties(currentFieldType, sections)

                    switch tableState {
                    case .reloadData:
                        self.processReloadData()
                    case .deletedRows(indexPath: let indexPaths):
                        //TODO effecer la cell en question
                        break
                    case .insertRows(indexPath: let indexPaths):
                        self.processInsertRows(indexPaths: indexPaths, sections: sections)
                    case .updateRows(indexPath: let indexPaths):
                        self.proccessUpdateRowAt(indexPath: indexPaths[0])
                    }
        }
    }

    func disposeToCulturalPracticeStateObs() {
        self.culturalPracticeStateDisposable?.dispose()
        self.disposableDispathActionSelectedElement?.dispose()
        self.disposableAddContainerElement?.dispose()
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

    func handle(didSelectRowAt indexPath: IndexPath) {
        guard (sections![indexPath.section].rowData[indexPath.row] as? CulturalPracticeAddElement)
            == nil else { return }

        let selectedElementAction = createSelectedElementOnListAction(indexPath: indexPath)
        dispatchActionSelectedElementOnList(selectedElementAction)
        presentedCulturalPracticeFormController()
    }

    func initCellFor(multiSelectElement: CulturalPracticeMultiSelectElement, cell: UITableViewCell) -> UITableViewCell {
        removeContainerElementViewTo(containerView: cell.contentView)
        config(labelTitle: cell.textLabel, culturalPracticeElementProtocol: multiSelectElement)
        config(detailLabel: cell.detailTextLabel, culturalPracticeValueProtocol: multiSelectElement.value)
        configAccessoryView(of: cell, culturalPracticeProtocol: multiSelectElement.value)
        return cell
    }

    func initCellFor(addElement: CulturalPracticeAddElement, cell: UITableViewCell) -> UITableViewCell {
        removeContainerElementViewTo(containerView: cell.contentView)
        cell.detailTextLabel?.font = UIFont(name: "Arial", size: 20)
        cell.textLabel?.font = UIFont(name: "Arial", size: 15)
        cell.textLabel?.text = NSLocalizedString("Cliquer sur le boutton", comment: "Cliquer sur le boutton")
        cell.detailTextLabel?.textColor = .white
        cell.detailTextLabel?.text = addElement.title

        if !(cell.accessoryView is UIButton) {
           cell.accessoryView = createAddButton()
        }

        return cell
    }

    func initCellFor(containerElement: CulturalPracticeInputMultiSelectContainer, cell: UITableViewCell) -> UITableViewCell {
        cell.textLabel?.text = nil
        cell.detailTextLabel?.text = nil
        cell.accessoryView = nil
        removeContainerElementViewTo(containerView: cell.contentView)
        let container = ContainerElementView(containerElement: containerElement)
        container.addViewTo(contentView: cell.contentView)
        return cell
    }

    func initCellFor(inputElement: CulturalPracticeInputElement, cell: UITableViewCell) -> UITableViewCell {
        removeContainerElementViewTo(containerView: cell.contentView)
        config(
            labelTitle: cell.textLabel,
            culturalPracticeElementProtocol: inputElement
        )

        config(detailLabel: cell.detailTextLabel, culturalPracticeValueProtocol: inputElement.value)
        configAccessoryView(of: cell, culturalPracticeProtocol: inputElement.value)
        return cell
    }

    private func presentedCulturalPracticeFormController() {
        let appDependency = viewController!.getAppDelegate()!.appDependencyContainer
        viewController?.present(appDependency.processInitCulturalPracticeFormViewController(), animated: true)
    }

    private func dispatchActionSelectedElementOnList(_ action: CulturalPracticeFormAction.SelectedElementOnList) {
        self.disposableDispathActionSelectedElement = Completable.create { completableEvent in
            self.actionDispatcher.dispatch(action)
            completableEvent(.completed)
            return Disposables.create()
        }.subscribeOn(Util.getSchedulerBackground())
        .subscribe()
    }

    private func createSelectedElementOnListAction(indexPath: IndexPath) -> CulturalPracticeFormAction.SelectedElementOnList {
        CulturalPracticeFormAction.SelectedElementOnList(
            culturalPracticeElement: sections![indexPath.section].rowData[indexPath.row],
            fieldType: self.currentField!,
            culturalPracticeFormSubAction: CulturalPracticeFormSubAction.newDataForm
        )
    }

    private func setStateProperties(_ currentFieldType: FieldType, _ sections: [Section<CulturalPracticeElementProtocol>]) {
        self.currentField = currentFieldType
        self.sections = sections
    }

    private func proccessUpdateRowAt(indexPath: IndexPath) {
        self.tableView?.reloadRows(at: [indexPath], with: .fade)
    }

    private func config(labelTitle: UILabel?, culturalPracticeElementProtocol: CulturalPracticeElementProtocol) {
        labelTitle?.font = UIFont(name: "Arial", size: 15)
        labelTitle?.textColor = .white
        labelTitle?.numberOfLines = 2
        labelTitle?.text = culturalPracticeElementProtocol.title
    }

    private func config(detailLabel: UILabel?, culturalPracticeValueProtocol: CulturalPracticeValueProtocol?) {
        detailLabel?.font = UIFont(name: "Arial", size: 20)
        detailLabel?.numberOfLines = 2

        if culturalPracticeValueProtocol != nil {
            detailLabel?.text = culturalPracticeValueProtocol!.getValue()
            detailLabel?.textColor = .green
            return
        }

        detailLabel?.text = NSLocalizedString("Veuillez choisir une valeur", comment: "Veuillez choisir une valuer")
        detailLabel?.textColor = .red
    }

    private func configAccessoryView(of cell: UITableViewCell, culturalPracticeProtocol: CulturalPracticeValueProtocol?) {
        if culturalPracticeProtocol != nil {
            let imageViewYes = UIImageView(image: getImageIconYes())
            cell.accessoryView = imageViewYes
            return imageViewYes.sizeToFit()
        }

        let imageViewNo = UIImageView(image: getImageIconNo())
        cell.accessoryView = imageViewNo
        imageViewNo.sizeToFit()
    }

    private func removeContainerElementViewTo(containerView: UIView) {
        containerView.viewWithTag(ContainerElementView.TAG)?.removeFromSuperview()
    }

    private func createAddButton() -> UIButton {
        let imageAdd = getImageIconAdd()
        let addButton = UIButton(type: .custom)
        addButton.setImage(imageAdd, for: .normal)
        addButton.tintColor = Util.getOppositeColorBlackOrWhite()
        addButton.sizeToFit()
        addButton.tag = TAG_ADD_BUTTON
        addButton.addTarget(self, action: #selector(addDoseFumier(sender:)), for: .touchUpInside)
        return addButton
    }

    @objc private func addDoseFumier(sender: UIButton) {
        self.disposableAddContainerElement = Completable.create { completable in
            self.findSectionDoseFumier().map { sectionIndex in
                let count = self.sections![sectionIndex].rowData.count

                if count < (CulturalPractice.MAX_DOSE_FUMIER + 1) {
                    self.actionDispatcher.dispatch(
                        CulturalPracticeAction.AddCulturalPracticeInputMultiSelectContainer(index: count)
                    )
                }
            }

            completable(.completed)
            return Disposables.create()
        }.subscribeOn(Util.getSchedulerBackground())
        .subscribe()
    }

    private func findSectionDoseFumier() -> Int? {
        return self.sections?.firstIndex(where: { (section: Section<CulturalPracticeElementProtocol>) -> Bool in
            guard !(section.rowData.isEmpty),
                 (section.rowData[0] as? CulturalPracticeAddElement) != nil else {
                    return false
            }

            return true
        })
    }

    private func getImageIconYes() -> UIImage? {
        UIImage(named: "yes48")
    }

    private func getImageIconNo() -> UIImage? {
        UIImage(named: "no48")
    }

    private func getImageIconAdd() -> UIImage? {
        UIImage(named: "add48")?.withRenderingMode(.alwaysTemplate)
    }

    private func processReloadData() {
        self.tableView?.reloadData()
    }

    private func processInsertRows(indexPaths: [IndexPath], sections: [Section<CulturalPracticeElementProtocol>]) {
        self.sections = sections
        self.tableView?.insertRows(at: indexPaths, with: .right)
    }

}

protocol CulturalPraticeViewModel {
    var tableView: UITableView? {get set}
    var cellId: String {get}
    var viewController: UIViewController? {get set}
    var headerFooterSectionViewId: String {get}
    func subscribeToCulturalPracticeStateObs()
    func disposeToCulturalPracticeStateObs()
    func getNumberOfSection() -> Int
    func getNumberRow(in section: Int) -> Int
    func registerCell()
    func getCulturePracticeElement(by indexPath: IndexPath) -> CulturalPracticeElementProtocol
    func registerHeaderFooterViewSection()
    func initCellFor(addElement: CulturalPracticeAddElement, cell: UITableViewCell) -> UITableViewCell
    func initCellFor(containerElement: CulturalPracticeInputMultiSelectContainer, cell: UITableViewCell) -> UITableViewCell
    func initCellFor(inputElement: CulturalPracticeInputElement, cell: UITableViewCell) -> UITableViewCell
    func initCellFor(multiSelectElement: CulturalPracticeMultiSelectElement, cell: UITableViewCell) -> UITableViewCell
    func handle(didSelectRowAt indexPath: IndexPath)
}
