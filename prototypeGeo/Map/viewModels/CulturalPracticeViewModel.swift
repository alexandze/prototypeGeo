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
    var sections: [Section<CulturalPracticeElement>]?
    var cellId: String = UUID().uuidString
    var headerFooterSectionViewId: String = UUID().uuidString
    let culturalPracticeStateObs: Observable<CulturalPracticeState>
    let actionDispatcher: ActionDispatcher
    var tableView: UITableView?
    var culturalPracticeStateDisposable: Disposable?
    let TAG_ADD_BUTTON = 50
    var disposableAddContainerElement: Disposable?

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
                    let tableState = culturalPracticeState.tableState
                    else { return }

                switch tableState {
                case .reloadData:
                    self.processReloadData(currentFieldType: currentFieldType, sections: sections)
                case .deletedRows(indexPath: let indexPaths):
                    break
                case .insertRows(indexPath: let indexPaths):
                    self.processInsertRows(indexPaths: indexPaths, sections: sections)
                }
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

    func initCellFor(addElement: CulturalPracticeAddElement, for cell: UITableViewCell) -> UITableViewCell {
        cell.textLabel?.text = NSLocalizedString("Cliquer sur le boutton", comment: "Cliquer sur le boutton")
        cell.detailTextLabel?.textColor = .white
        cell.detailTextLabel?.text = addElement.title

        if !(cell.accessoryView is UIButton) {
           cell.accessoryView = createAddButton()
        }

        return cell
    }

    func initCellFor(containerElement: CulturalPracticeInputMultiSelectContainer, for cell: UITableViewCell ) -> UITableViewCell {
        let container = ContainerElementView(containerElement: containerElement, contentView: cell.contentView)

        return cell
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
                        MapFieldAction.AddCulturalPracticeInputMultiSelectContainer(index: count)
                    )
                }
            }

            completable(.completed)
            return Disposables.create()
            }.subscribeOn(ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global()))
        .subscribe()
    }

    private func findSectionDoseFumier() -> Int? {
        return self.sections?.firstIndex(where: { (section: Section<CulturalPracticeElement>) -> Bool in
            guard !(section.rowData.isEmpty),
                case .culturalPracticeAddElement(_) = section.rowData[0] else {
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

    private func processReloadData(currentFieldType: FieldType, sections: [Section<CulturalPracticeElement>]) {
        self.currentField = currentFieldType
        self.sections = sections
        self.tableView?.reloadData()
    }

    private func processInsertRows(indexPaths: [IndexPath], sections: [Section<CulturalPracticeElement>]) {
        self.sections = sections
        self.tableView?.insertRows(at: indexPaths, with: .right)
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
    func initCellFor(addElement: CulturalPracticeAddElement, for cell: UITableViewCell) -> UITableViewCell
    func initCellFor(containerElement: CulturalPracticeInputMultiSelectContainer, for cell: UITableViewCell ) -> UITableViewCell
}
