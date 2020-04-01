//
//  CulturalPraticeViewController.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-19.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

public class CulturalPraticeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var culturalPraticeViewModel: CulturalPraticeViewModel
    let culturalPraticeView: CulturalPraticeView
    let tableView: UITableView

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(
        culturalPraticeViewModel: CulturalPraticeViewModel
    ) {
        self.culturalPraticeViewModel = culturalPraticeViewModel
        self.culturalPraticeView = CulturalPraticeView()
        self.culturalPraticeViewModel.tableView = self.culturalPraticeView.tableView
        self.tableView = self.culturalPraticeView.tableView
        super.init(nibName: nil, bundle: nil)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.culturalPraticeViewModel.viewController = self
    }

    public override func loadView() {
        self.view = self.culturalPraticeView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        culturalPraticeViewModel.registerCell()
        culturalPraticeViewModel.registerHeaderFooterViewSection()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        culturalPraticeViewModel.subscribeToCulturalPracticeStateObs()
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

        if let _ = element as? CulturalPracticeInputMultiSelectContainer {
            return 350
        }

        return 100
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: culturalPraticeViewModel.cellId, for: indexPath) as? SubtitleTableViewCell

        switch culturalPraticeViewModel.getCulturePracticeElement(by: indexPath) {
        case let addElement as CulturalPracticeAddElement:
            return culturalPraticeViewModel.initCellFor(addElement: addElement, cell: cell!)

        case let inputElement as CulturalPracticeInputElement:
            return culturalPraticeViewModel.initCellFor(inputElement: inputElement, cell: cell!)

        case let inputMultiSelectContainer as CulturalPracticeInputMultiSelectContainer:
            return culturalPraticeViewModel.initCellFor(containerElement: inputMultiSelectContainer, cell: cell!)
        case let multiSelectElement as CulturalPracticeMultiSelectElement:
            return culturalPraticeViewModel.initCellFor(multiSelectElement: multiSelectElement, cell: cell!)
        default:
            return cell!
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        culturalPraticeViewModel.handle(didSelectRowAt: indexPath)
    }

}
