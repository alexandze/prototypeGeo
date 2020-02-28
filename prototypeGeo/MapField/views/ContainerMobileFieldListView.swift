//
//  ContainerMobileFieldListView.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-02-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class ContainerMobileFieldListView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var tableView: UITableView?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        configView(view: self)
        initViewTitle(parentView: self)
        self.tableView = initTableView(parentView: self)
    }
    
    private func initViewTitle(parentView: UIView) {
        let titleView = TitleView()
        titleView.clipsToBounds = true
        titleView.tag = 1
        titleView.setTitle(title: "Liste des parcelles choisies")
        titleView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(titleView)
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func initTableView(parentView: UIView) -> UITableView {
        let tableViewContainer = FieldListView()
        tableViewContainer.tag = 2
        tableViewContainer.clipsToBounds = true
        tableViewContainer.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(tableViewContainer)
        let titleView = parentView.viewWithTag(1)!
        
        NSLayoutConstraint.activate([
            tableViewContainer.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            tableViewContainer.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            tableViewContainer.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            tableViewContainer.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
        ])
        
        return tableViewContainer.tableView
    }
    
    private func configView(view: UIView) {
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
    }

}
