//
//  CulturalPracticeFormViewController.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-19.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

public class CulturalPracticeFormViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var culturalPraticeViewModel: CulturalPraticeFormViewModel
    let culturalPraticeFormView: CulturalPracticeFormView
    let tableView: UITableView
    var cellId: String = UUID().uuidString
    var headerFooterSectionViewId: String = UUID().uuidString

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(
        culturalPraticeViewModel: CulturalPraticeFormViewModel
    ) {
        self.culturalPraticeViewModel = culturalPraticeViewModel
        self.culturalPraticeFormView = CulturalPracticeFormView()
        self.tableView = self.culturalPraticeFormView.tableView
        super.init(nibName: nil, bundle: nil)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    public override func loadView() {
        self.view = self.culturalPraticeFormView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        registerHeaderFooterViewSection()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        culturalPraticeFormView.initFieldButton { [weak self] in self?.culturalPraticeViewModel.handleFieldButton() }
        culturalPraticeFormView.initCulturalPracticeButton { [weak self] in self?.culturalPraticeViewModel.handleCulturalPracticeButton() }
        culturalPraticeViewModel.reloadTableView = {[weak self] in self?.tableView.reloadData() }
        culturalPraticeViewModel.insertSections = { [weak self] indexPaths in self?.insertNewSections(indexPaths) }
        culturalPraticeViewModel.presentInputFormController = { [weak self] in self?.presentInputFormController()}
        culturalPraticeViewModel.presentSelectFormController = { [weak self] in self?.presentSelectFormController() }
        culturalPraticeViewModel.presentContainerElementController = { [weak self] in self?.presentContainerElementController() }
        culturalPraticeViewModel.reloadSections = { [weak self] indexPaths in self?.reloadSection(indexPaths) }

        culturalPraticeViewModel.deletedAndAddSection = { [weak self] (indexPathRemoveList, indexPathAddList) in
            self?.deletedAndAddSection(indexPathRemoveList, indexPathAddList)
        }

        culturalPraticeViewModel.subscribeToCulturalPracticeStateObs()
    }

    private func deletedAndAddSection(_ indexPathRemoveList: [IndexPath], _ indexPathAddList: [IndexPath]) {
        self.tableView.performBatchUpdates({
            indexPathRemoveList.sorted().reversed().forEach { indexPathRemove in
                self.tableView.deleteSections(IndexSet(integer: indexPathRemove.section), with: .left)
            }

            indexPathAddList.sorted().reversed().forEach { indexPathAdd in
                self.tableView.insertSections(IndexSet(integer: indexPathAdd.section), with: .right)
            }
        })
    }

    private func insertNewSections(_ indexPaths: [IndexPath]) {
        let reverseIndexPath = indexPaths.sorted().reversed()

        self.tableView.performBatchUpdates({
            reverseIndexPath.forEach { indexPath in
                self.tableView.insertSections(IndexSet(integer: indexPath.section), with: .left)
            }
        }) { _ in
            if let indexPath = reverseIndexPath.first {
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }

    private func reloadSection(_ indexPaths: [IndexPath]) {
        self.tableView.performBatchUpdates({
            indexPaths.forEach { indexPath in
                self.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .fade)
            }
        })
    }

    private func presentInputFormController() {
        guard let appDependency = Util.getAppDependency() else {
            return
        }

        let inputFormController = appDependency.processInitInputFormCulturalPracticeHostingController()
        self.present(inputFormController, animated: true)
    }

    private func presentSelectFormController() {
        guard let appDependency = Util.getAppDependency() else {
            return
        }

        let selectFormController = appDependency.processInitSelectFormCulturalPracticeViewController()
        self.present(selectFormController, animated: true)
    }

    private func presentContainerElementController() {
        guard let appDependency = Util.getAppDependency() else {
            return
        }

        let containerElement = appDependency.makeContainerFormCulturalPracticeHostingController()
        self.present(containerElement, animated: true)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        culturalPraticeViewModel.disposeToCulturalPracticeStateObs()
    }

    func registerCell() {
        self.tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: self.cellId)
    }

    func registerHeaderFooterViewSection() {
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: headerFooterSectionViewId)
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        culturalPraticeViewModel.getNumberOfSection()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        ""
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerFooterSectionViewId)
        return headerView
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let typeSection = culturalPraticeViewModel.getTypeSectionByIndexPath(indexPath)

        if  typeSection == ElementUIListData.TYPE_ELEMENT {
            return 300
        }

        return 100
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellOp = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? SubtitleTableViewCell
        let elementUIDataOp = culturalPraticeViewModel.getElementUIDataByIndexPath(indexPath)
        guard let elementUIData = elementUIDataOp, let cell = cellOp else { return UITableViewCell() }

        switch elementUIData {
        case let inputElement as InputElement:
            return culturalPraticeFormView.initCell(cell, inputElement: inputElement)
        case let selectElement as SelectElement:
            return culturalPraticeFormView.initCell(cell, withData: selectElement)
        case let elementUIListData as ElementUIListData:
            return culturalPraticeFormView.initCell(cell, withData: elementUIListData)
        case let rowWithButton as RowWithButton:
            return culturalPraticeFormView.initCell(cell, withData: rowWithButton, andHandle: culturalPraticeViewModel.handleAddDoseFumierButton)
        default:
            return cell
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        culturalPraticeViewModel.handleSelectRow(indexPath)
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        culturalPraticeViewModel.handleRemoveDoseFumierButtonByIndexPath(indexPath, editingStyle: editingStyle)
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        culturalPraticeViewModel.handleCanEditRowByIndexPath(indexPath)
    }

    deinit {
        print("***** denit CulturalPraticeViewController *******")
    }
}
