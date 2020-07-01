//
//  TitleView.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-02-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class TitleView: UIView {

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
        configView(view: self)
        centerLabel(parentView: self, label: self.labelTitle)
    }

    let labelTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Util.getOppositeColorBlackOrWhite()
        return label
    }()

    private func configView(view: UIView) {
        view.backgroundColor = .systemGray6
        view.alpha = 0.95
    }

    private func centerLabel(parentView: UIView, label: UILabel) {
        addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: parentView.centerYAnchor)
        ])
    }

    public func setTitle(title: String) {
        self.labelTitle.text = title
    }
}
