//
//  FarmerTableViewController.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2019-12-26.
//  Copyright © 2019 Alexandre Andze Kande. All rights reserved.
//

import UIKit
import RxSwift

class FarmerTableViewController: UITableViewController, Identifier {
    static var identifier: String = "FarmerTableViewController"
    
    
    let cellID = "myCellId"
    var farmers: [Farmer] = []
    
    
    var sectionsFarmers: [Section<FarmerFormated>]?
    var farmerTableViewModel: FarmerTableViewModel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(
        farmerViewModel: FarmerTableViewModel
    ) {
        self.farmerTableViewModel = farmerViewModel
        super.init(style: .plain)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        farmerTableViewModel.initTitleNavigation(viewController: self)
        farmerTableViewModel.initAddBarButton(viewController: self)
        farmerTableViewModel.registerTableViewCell(cellId: self.cellID, tableView: self.tableView)
        tableView.rowHeight = 60
        farmerTableViewModel.refreshList(tableView: self.tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        farmerTableViewModel.dispatchGetFarmers(offset: 0, limit: 0)
        farmerTableViewModel.susbcribeToTableViewControllerState(farmerTableViewController: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        farmerTableViewModel.disposeToTableViewControllerState()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        farmerTableViewModel.getCountSectionFromSections(sections: sectionsFarmers)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        farmerTableViewModel.getNumberRowByNumberSection(numberSection: section, sections: self.sectionsFarmers)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        farmerTableViewModel.getTitleForHeaderSection(numberOfSection: section, sections: self.sectionsFarmers)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell =  tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        if let sections = self.sectionsFarmers {
            let farmer = farmerTableViewModel.getFarmerByIndexPath(indexPath: indexPath, sections: sections)
            // print(farmer)
            farmer.map {
                if tableViewCell.viewWithTag(1) == nil {
                    tableViewCell.accessoryType = .detailButton
                    tableViewCell.tintColor = Util.getOppositeColorBlackOrWhite()
                    let farmerViewCell = FarmerViewCell(contentView: tableViewCell.contentView)
                    farmerViewCell.initView(textLabel: "\($0.firstName) \($0.lastName)", nameImage: "user")
                } else {
                    let label = tableViewCell.contentView.viewWithTag(1) as? UILabel
                    label?.text =  "\($0.firstName) \($0.lastName)"
                }
                
            }
        }
        
        return tableViewCell
    }
}
