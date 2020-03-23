//
//  FieldListViewController.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-02-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class FieldListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let fieldListView: FieldListView
    let tableView: UITableView
    let cellID = "my cell id"

    var fields: [FieldType] = []

    var fieldListViewModel: FieldListViewModel

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(
        fieldListViewModel: FieldListViewModel
    ) {
        self.fieldListView = FieldListView()
        self.tableView = fieldListView.tableView
        self.fieldListViewModel = fieldListViewModel
        super.init(nibName: nil, bundle: nil)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.fieldListViewModel.viewController = self
        self.fieldListViewModel.setTableView(tableView: tableView)
    }

    override func loadView() {
        self.view = fieldListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fieldListViewModel.subscribeToObservableFieldListState()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.fieldListViewModel.dispose()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return fields.count
        return fieldListViewModel.fieldList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        let index = indexPath.row
        let fieldType = fieldListViewModel.fieldList[index]
        var fieldId: Int?

        switch fieldType {
        case .multiPolygon(let multi):
            fieldId = multi.id
        case .polygon(let polygon):
            fieldId = polygon.id
        }

        // let fieldSelected = fields[index]
        cell.textLabel?.text = "Parcelle avec le id \(fieldId!)"
        cell.backgroundColor = .systemGray6
        cell.alpha = 0.95
        let image = UIImage(named: "location")?.withTintColor(Util.getOppositeColorBlackOrWhite())
        cell.imageView?.image = image
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        fieldListViewModel.handle(didSelectRowAt: indexPath)
        
    }

}
