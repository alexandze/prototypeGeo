//
//  FarmerViewModel.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2019-12-29.
//  Copyright © 2019 Alexandre Andze Kande. All rights reserved.
//

import UIKit
import RxSwift

public class FarmerTableViewModel {

    let farmerTableViewInteraction: FarmerTableViewInteractions
    let farmerTableViewControllerStateObs: Observable<FarmerTableViewControllerState>
    var disposableTableViewControllerState: Disposable?

    init(
        farmerTableViewInteraction: FarmerTableViewInteractions,
        farmerTableViewControllerStateObservable: Observable<FarmerTableViewControllerState>
    ) {
        self.farmerTableViewInteraction = farmerTableViewInteraction
        self.farmerTableViewControllerStateObs = farmerTableViewControllerStateObservable
    }

    func initTitleNavigation(viewController: UIViewController) {
        viewController.title = "Producteur"
        // viewController.tabBarController?.navigationController?.popToViewController(viewController, animated: true)
    }

    func initAddBarButton(viewController: UIViewController) {
        let barButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addFarmer(_:))
        )
        barButton.tintColor = Util.getOppositeColorBlackOrWhite()
        viewController.navigationItem.rightBarButtonItems = [barButton]
        viewController.tabBarController?.navigationItem.rightBarButtonItems = [barButton]
    }

    @objc func addFarmer(_ barButtonItem: UIBarButtonItem) {
        // TODO afficher le controlleur pour ajouter un farmer
        //self.dispatchGoToFarmerAddViewController(
        //farmerTableViewInteractions: self.farmerTableViewInteraction
        //)
    }

    func registerTableViewCell(cellId: String, tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }

    func refreshList(tableView: UITableView) {
        tableView.reloadData()
    }

    func dispatchGetFarmers(offset: Int, limit: Int) {
        self.farmerTableViewInteraction.getFamers(offset: offset, limit: limit)
    }

    func susbcribeToTableViewControllerState(farmerTableViewController: FarmerTableViewController) {
        self.disposableTableViewControllerState = farmerTableViewControllerStateObs
            .observeOn(Util.getSchedulerMain())
            .subscribe(onNext: {
            self.setDataTableView(
                farmers: $0.farmers,
                sectionsFarmers: $0.sectionsFarmersFormated,
                farmerTableViewController: farmerTableViewController
            )
        })
    }

    func disposeToTableViewControllerState() {
        self.disposableTableViewControllerState?.dispose()
    }

    func setDataTableView(
        farmers: [Farmer],
        sectionsFarmers: [Section<FarmerFormated>]?,
        farmerTableViewController: FarmerTableViewController) {
        farmerTableViewController.farmers = farmers
        farmerTableViewController.sectionsFarmers = sectionsFarmers
        farmerTableViewController.tableView.reloadData()
    }

    func getCountSectionFromSections(sections: [Section<FarmerFormated>]?) -> Int {
        if let sectionUnwrap = sections {
            return sectionUnwrap.count
        }

        return 0
    }

    func getNumberRowByNumberSection(numberSection: Int, sections: [Section<FarmerFormated>]?) -> Int {
        if let countSection = sections?.count,
            let sectionUnwrap = sections,
            numberSection < countSection {
            return sectionUnwrap[numberSection].rowData.count
        }

        return 0
    }

    func getTitleForHeaderSection(numberOfSection: Int, sections: [Section<FarmerFormated>]?) -> String? {
        if let sectionsUnwrap = sections,
            let countSection = sections?.count,
            numberOfSection < countSection {
            return sectionsUnwrap[numberOfSection].sectionName
        }

        return nil
    }

    func getFarmerByIndexPath(indexPath: IndexPath, sections: [Section<FarmerFormated>]) -> Farmer? {
        let sectionIndex = indexPath.section
        let rowIndex = indexPath.row
        let countSection = sections.count

        if sectionIndex < countSection, rowIndex < sections[sectionIndex].rowData.count {
            return sections[sectionIndex].rowData[rowIndex].farmer
        }

        return nil
    }

    func dispatchGoToFarmerAddViewController(farmerTableViewInteractions: FarmerTableViewInteractions) {

    }

}
