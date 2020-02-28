//
//  FieldListView.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-02-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class FieldListView: UIView {

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        initConstraintTableView(parentView: self, tableView: tableView)
    }
    
    public let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private func initConstraintTableView(parentView: UIView, tableView: UITableView) {
        parentView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: parentView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
        ])
    }

}
