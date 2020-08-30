//
//  FieldDetailsTableViewHeader.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-19.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class FieldDetailsTableViewHeader: UIView {

    var titleFieldButton: String? {
        get {
            buttonField.title(for: .normal)
        }
        set(title) {
            buttonField.setTitle(title, for: .normal)
        }
    }

    var titleCulturalPracticeButton: String? {
        get {
            buttonCulturalPractice.title(for: .normal)
        }

        set(title) {
            buttonCulturalPractice.setTitle(title, for: .normal)
        }
    }

    private let tagCulturalPracticeButton = 50
    private let tagFieldButton = 51
    private var actionFieldButton: (() -> Void)?
    private var actionCulturalPracticeButton: (() -> Void)?

    private let buttonCulturalPractice: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.layer.borderWidth = 1
        // button.layer.borderColor = UIColor.black.cgColor
        button.setTitleColor(Util.getOppositeColorBlackOrWhite(), for: .normal)
        button.layer.cornerRadius = 15
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping

        button.backgroundColor = .systemGray2
        button.layer.shadowColor = UIColor.systemGray2.cgColor
        button.layer.shadowOpacity = 10
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 5
        return button
    }()

    private let buttonField: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.layer.borderWidth = 1
        // button.layer.borderColor = UIColor.white.cgColor

        button.setTitleColor(Util.getOppositeColorBlackOrWhite(), for: .normal)
        button.layer.cornerRadius = 15
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping

        button.backgroundColor = .systemGray2
        button.layer.shadowColor = UIColor.systemGray2.cgColor
        button.layer.shadowOpacity = 5
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 5
        return button
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
        self.positionFieldAndCulturalPracticeButton()
    }

    func initHandleFieldButton(handleFunc: @escaping () -> Void) {
        actionFieldButton = handleFunc
        buttonField.addTarget(self, action: #selector(handleFieldButton(button:)), for: .touchUpInside)
    }

    func initHandleCulturalPracticeButton(handleFunc: @escaping () -> Void) {
        actionCulturalPracticeButton = handleFunc
        buttonCulturalPractice.addTarget(self, action: #selector(handleCulturalPracticeButton(button:)), for: .touchUpInside)
    }

    @objc private func handleFieldButton(button: UIButton) {
        setColorSelectedButton(button: button)
        actionFieldButton?()
    }

    @objc private func handleCulturalPracticeButton(button: UIButton) {
        setColorSelectedButton(button: button)
        actionCulturalPracticeButton?()
    }

    private func setColorSelectedButton(button: UIButton) {
        switch button.tag {
        case tagFieldButton:
            buttonField.backgroundColor = .systemGray2
            buttonCulturalPractice.backgroundColor = .systemGray4
        case tagCulturalPracticeButton:
            buttonCulturalPractice.backgroundColor = .systemGray2
            buttonField.backgroundColor = .systemGray4
        default:
            break
        }
    }

    private func positionFieldAndCulturalPracticeButton() {
        let viewButton = UIView(frame: .zero)
        viewButton.translatesAutoresizingMaskIntoConstraints = false
        buttonField.tag = tagFieldButton
        buttonCulturalPractice.tag = tagCulturalPracticeButton
        viewButton.addSubview(buttonField)
        viewButton.addSubview(buttonCulturalPractice)
        addSubview(viewButton)

        NSLayoutConstraint.activate([
            buttonField.centerYAnchor.constraint(equalTo: viewButton.centerYAnchor),
            buttonField.leadingAnchor.constraint(equalTo: viewButton.leadingAnchor),
            buttonField.heightAnchor.constraint(equalTo: viewButton.heightAnchor, multiplier: 0.8),
            buttonCulturalPractice.centerYAnchor.constraint(equalTo: viewButton.centerYAnchor),
            buttonCulturalPractice.trailingAnchor.constraint(equalTo: viewButton.trailingAnchor),
            buttonCulturalPractice.heightAnchor.constraint(equalTo: viewButton.heightAnchor, multiplier: 0.8),
            viewButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            viewButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            viewButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            viewButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1),
            buttonField.widthAnchor.constraint(equalTo: viewButton.widthAnchor, multiplier: 0.4),
            buttonCulturalPractice.widthAnchor.constraint(equalTo: viewButton.widthAnchor, multiplier: 0.4)

        ])
    }
}
