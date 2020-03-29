//
//  HeaderPresentedView.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class HeaderPresentedView: UIView {

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
        addSubviewInSuperView()
        initConstraintButtonClose()
        initConstraintLabelTitle()
    }

    public var textTitle: String = "" {
        didSet {
            titleLable.text = textTitle
        }
    }

    func handleCloseButtonWith(_ handleFunc: @escaping (() -> Void)) {
        self.handleCloseButtonFunc = handleFunc
    }

    private let buttonClose: UIButton  = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleClose(button:)), for: .touchUpInside)
        return button
    }()

    private let titleLable: UILabel = {
        let label = UILabel()
        label.textColor = Util.getOppositeColorBlackOrWhite()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.numberOfLines = 0
        return label
    }()

    private var handleCloseButtonFunc: (() -> Void)?

    @objc private func handleClose(button: UIButton) {
        handleCloseButtonFunc?()
    }

    private func addSubviewInSuperView() {
        addSubview(buttonClose)
        addSubview(titleLable)
    }

    private func initConstraintButtonClose() {
        NSLayoutConstraint.activate([
            buttonClose.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            buttonClose.topAnchor.constraint(equalTo: topAnchor, constant: 5)
        ])
    }

    private func initConstraintLabelTitle() {
        NSLayoutConstraint.activate([
            titleLable.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLable.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLable.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7)
        ])
    }

}
