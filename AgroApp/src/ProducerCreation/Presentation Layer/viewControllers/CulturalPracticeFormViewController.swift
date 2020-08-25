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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(
        culturalPraticeViewModel: CulturalPraticeFormViewModel
    ) {
        self.culturalPraticeViewModel = culturalPraticeViewModel
        self.culturalPraticeFormView = CulturalPracticeFormView()
        self.culturalPraticeViewModel.culturalPraticeView = self.culturalPraticeFormView
        self.culturalPraticeViewModel.tableView = self.culturalPraticeFormView.tableView
        self.tableView = self.culturalPraticeFormView.tableView
        super.init(nibName: nil, bundle: nil)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.culturalPraticeViewModel.viewController = self
    }

    public override func loadView() {
        self.view = self.culturalPraticeFormView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        culturalPraticeViewModel.registerCell()
        culturalPraticeViewModel.registerHeaderFooterViewSection()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        culturalPraticeViewModel.subscribeToCulturalPracticeStateObs()
        culturalPraticeFormView.initDefaultColorButtonHeader()
        
        culturalPraticeFormView.initFieldButton {
            self.culturalPraticeViewModel.handleFieldButton()
        }
        
        culturalPraticeFormView.initCulturalPracticeButton {
            self.culturalPraticeViewModel.handleCulturalPracticeButton()
        }
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        culturalPraticeViewModel.disposeToCulturalPracticeStateObs()
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        culturalPraticeViewModel.getNumberOfSection()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        culturalPraticeViewModel.getNumberRow(in: section)
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        ""
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: culturalPraticeViewModel.headerFooterSectionViewId)
        return headerView
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let element = culturalPraticeViewModel.getCulturePracticeElement(by: indexPath)

        if  (element as? CulturalPracticeContainerElement) != nil {
            return 300
        }

        return 100
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: culturalPraticeViewModel.cellId, for: indexPath) as? SubtitleTableViewCell

        switch culturalPraticeViewModel.getCulturePracticeElement(by: indexPath) {
        case let addElement as CulturalPracticeAddElement:
            return culturalPraticeFormView.initCell(cell, withData: addElement) {
                [weak self] in self?.culturalPraticeViewModel.handleFuncAddDoseFumier()
            }
        case let inputElement as CulturalPracticeInputElement:
            return culturalPraticeFormView.initCell(cell, withData: inputElement)
        case let inputMultiSelectContainer as CulturalPracticeContainerElement:
            return culturalPraticeFormView.initCell(cell, withData: inputMultiSelectContainer)
        case let multiSelectElement as CulturalPracticeMultiSelectElement:
            return culturalPraticeFormView.initCell(cell, withData: multiSelectElement)
        default:
            return cell ?? UITableViewCell()
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        culturalPraticeViewModel.tableView(didSelectRowAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        culturalPraticeViewModel.handleRemoveDoseFumierOnTableView(
            editingStyle: editingStyle,
            indexPath: indexPath
        )
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        culturalPraticeViewModel.handleCanEditRow(indexPath: indexPath)
    }

    deinit {
        print("***** denit CulturalPraticeViewController *******")
    }
}
