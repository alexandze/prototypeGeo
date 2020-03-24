//
//  CulturalPraticeViewController.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-19.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class CulturalPraticeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
    }

    override func loadView() {
        self.view = self.culturalPraticeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        culturalPraticeViewModel.registerCell()
        culturalPraticeViewModel.registerHeaderFooterViewSection()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        culturalPraticeViewModel.subscribeToCulturalPracticeStateObs()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        culturalPraticeViewModel.disposeToCulturalPracticeStateObs()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        culturalPraticeViewModel.getNumberOfSection()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        culturalPraticeViewModel.getNumberRow(in: section)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        ""
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: culturalPraticeViewModel.headerFooterSectionViewId)
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: culturalPraticeViewModel.cellId, for: indexPath) as! SubtitleTableViewCell
        let imageYes = UIImage(named: "yes48")
        let imageNo = UIImage(named: "no48")
        let imageAdd = UIImage(named: "add48")?.withRenderingMode(.alwaysTemplate)

        cell.detailTextLabel?.text = "Veuillez choisir une valeur"
        cell.detailTextLabel?.font = UIFont(name: "Arial", size: 25)
        cell.detailTextLabel?.textColor = .red
        cell.accessoryView = UIImageView(image: imageNo)

        cell.textLabel?.numberOfLines = 0

        cell.textLabel?.font = UIFont(name: "Arial", size: 15)
        switch culturalPraticeViewModel.getCulturePracticeElement(by: indexPath) {
        case .culturalPracticeAddElement(let addElement):
            return culturalPraticeViewModel.initCellFor(addElement: addElement, for: cell)

        case .culturalPracticeInputElement(let inputElement):
            cell.textLabel?.text = inputElement.titleInput
            cell.detailTextLabel?.textColor = .green
            cell.accessoryView = UIImageView(image: imageYes)
            cell.detailTextLabel?.text = "28 kg/h"

        case .culturalPracticeInputMultiSelectContainer(let inputMultiSelectContainer):
            cell.textLabel?.text = inputMultiSelectContainer.title
        case .culturalPracticeMultiSelectElement(let multiSelectElement):
            cell.textLabel?.text = multiSelectElement.title
        }

        return cell
    }

}
