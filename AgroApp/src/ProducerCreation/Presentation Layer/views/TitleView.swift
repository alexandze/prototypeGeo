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
        configView()
        centerLabelTitle()
        initPositionButton()
        printCloseButton()
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

    let closeButton: UIButton = {
        let closeButton = UIButton(type: .close)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        return closeButton
    }()

    var handleCloseButtonFunc: (() -> Void)?

    private func configView() {
        backgroundColor = .systemGray6
        alpha = 0.95
    }

    private func centerLabelTitle() {
        addSubview(labelTitle)

        NSLayoutConstraint.activate([
            labelTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelTitle.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func initPositionButton() {
        addSubview(closeButton)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }

    func initHandleCloseButton(_ handleCloseButton: @escaping () -> Void) {
        handleCloseButtonFunc = handleCloseButton
        closeButton.addTarget(self, action: #selector(self.handleCloseButton(sender:)), for: .touchUpInside)
    }

    @objc private func handleCloseButton(sender: UIButton) {
        self.handleCloseButtonFunc?()
    }

    func setTitle(_ title: String) {
        self.labelTitle.text = title
    }

    func hideCloseButton() {
        closeButton.isHidden = true
    }

    func printCloseButton() {
        closeButton.isHidden = false
    }
}
