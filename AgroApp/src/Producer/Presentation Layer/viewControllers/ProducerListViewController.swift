//
//  ProducerListViewController.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2019-12-26.
//  Copyright © 2019 Alexandre Andze Kande. All rights reserved.
//

import UIKit
import RxSwift

class ProducerListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let cellID = "myCellId"
    
    var producerListViewModel: ProducerListViewModel
    let producerListView: ProducerListView
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(
        producerListViewModel: ProducerListViewModel,
        producerListView: ProducerListView = ProducerListView()
    ) {
        self.producerListViewModel = producerListViewModel
        self.producerListView = producerListView
        super.init(nibName: nil, bundle: nil)
        self.producerListView.tableView.dataSource = self
        self.producerListView.tableView.delegate = self
    }
    
    override func loadView() {
        view = producerListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTitleNavigation()
        initAddBarButton()
        producerListView.tableView.rowHeight = 60
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        producerListViewModel.showMakeProducerContainer = { [weak self] in self?.showMakeProducerContainer() }
        producerListViewModel.susbcribeToObservableState()
        showNavigationAndTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        producerListViewModel.disposeToObservableState()
    }
    
    func registerTableViewCell(cellId: String, tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    func initTitleNavigation() {
        title = "Producteurs"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell =  tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        return tableViewCell
    }
    
    private func initAddBarButton() {
        let imageButtonAddProducer = UIImage(systemName: "person.crop.circle.fill.badge.plus")
        let barButton = UIBarButtonItem(image: imageButtonAddProducer, style: .done, target: self, action: #selector(handleAddProducerButton(_:)))
        barButton.tintColor = Util.getOppositeColorBlackOrWhite()
        navigationItem.rightBarButtonItems = [barButton]
        tabBarController?.navigationItem.rightBarButtonItems = [barButton]
    }
    
    @objc private func handleAddProducerButton(_ barButtonItem: UIBarButtonItem) {
        // TODO call view model function
        producerListViewModel.showMakeProducerContainer?()
    }
    
    func showMakeProducerContainer() {
        guard let appDependency = Util.getAppDependency() else {
            return
        }
        
        navigationController?.pushViewController(appDependency.makeContainerMapAndTitleNavigationController(), animated: true)
    }
    
    private func showNavigationAndTabBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
}
