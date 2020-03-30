//
//  ContainerElementView.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-24.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class ContainerElementView: UIView {
    static let TAG = 89
    private let parentView: UIView = {
        let parentView = UIView()
        parentView.translatesAutoresizingMaskIntoConstraints = false
        parentView.tag = ContainerElementView.TAG
        return parentView
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(containerElement: CulturalPracticeInputMultiSelectContainer) {
        super.init(frame: .zero)
        initView(containerElement: containerElement)
    }

    func addViewTo(contentView: UIView) {
        contentView.addSubview(parentView)

        NSLayoutConstraint.activate([
            parentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            parentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            parentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            parentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func initView(containerElement: CulturalPracticeInputMultiSelectContainer) {
        let labels = createLabelsFor(containerElement: containerElement)
        initContraintOf(labelsTitleAndValue: labels, containerElement: containerElement)
    }

    private func initContraintOf(labelsTitleAndValue: [(UILabel, (UILabel, UIImageView))], containerElement: CulturalPracticeInputMultiSelectContainer) {
        (0..<labelsTitleAndValue.count).forEach { index in
            self.addToParentView(labelsTitleAndValue: labelsTitleAndValue[index])

            if index == 0 {
                let titleCellLabel = createLabelFor(titleCell: containerElement.title)
                addToParentView(label: titleCellLabel)
                NSLayoutConstraint.activate(createContraintToParentViewFor(titleCellLabel: titleCellLabel))
                return NSLayoutConstraint.activate(
                    createContraintToParentViewFor(firstLabelTitleValue: labelsTitleAndValue[index], titleCellLabel: titleCellLabel)
                )
            }

            if index == (labelsTitleAndValue.count - 1) {
                return NSLayoutConstraint.activate(
                    createContraintToParentViewFor(lastLabelTitleValue: labelsTitleAndValue[index], previousLabelTitleValue: labelsTitleAndValue[index - 1])
                )
            }

            return NSLayoutConstraint.activate(
                createContraintToParentViewFor(
                    currentLabelTitleValue: labelsTitleAndValue[index],
                    previousLabelTitleValue: labelsTitleAndValue[index - 1]
                )
            )
        }
    }

    private func createContraintToParentViewFor(titleCellLabel: UILabel) -> [NSLayoutConstraint] {
        [
            titleCellLabel.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 30),
            titleCellLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor)
        ]
    }

    private func createContraintToParentViewFor(firstLabelTitleValue: (UILabel, (UILabel, UIImageView)), titleCellLabel: UILabel) -> [NSLayoutConstraint] {
        let titleLabel = firstLabelTitleValue.0
        let valueLabel = firstLabelTitleValue.1.0
        let imageView = firstLabelTitleValue.1.1

        return [
            titleLabel.topAnchor.constraint(equalTo: titleCellLabel.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            titleLabel.widthAnchor.constraint(equalTo: parentView.widthAnchor, multiplier: 0.8),
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            valueLabel.widthAnchor.constraint(equalTo: parentView.widthAnchor, multiplier: 0.8),
            imageView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -10),
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -20)
        ]
    }

    private func createContraintToParentViewFor(
        currentLabelTitleValue: (UILabel, (UILabel, UIImageView)),
        previousLabelTitleValue: (UILabel, (UILabel, UIImageView))

    ) -> [NSLayoutConstraint] {
        let previousValueLabel = previousLabelTitleValue.1.0
        let currentTitleLabel = currentLabelTitleValue.0
        let currentValueLabel = currentLabelTitleValue.1.0
        let imageView = currentLabelTitleValue.1.1

        return [
            currentTitleLabel.topAnchor.constraint(equalTo: previousValueLabel.bottomAnchor, constant: 20),
            currentTitleLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            currentTitleLabel.widthAnchor.constraint(equalTo: parentView.widthAnchor, multiplier: 0.8),
            currentValueLabel.topAnchor.constraint(equalTo: currentTitleLabel.bottomAnchor),
            currentValueLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            currentValueLabel.widthAnchor.constraint(equalTo: parentView.widthAnchor, multiplier: 0.8),
            imageView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -10),
            imageView.topAnchor.constraint(equalTo: currentTitleLabel.bottomAnchor, constant: -20)
        ]
    }

    private func createContraintToParentViewFor(
        lastLabelTitleValue: (UILabel, (UILabel, UIImageView)),
        previousLabelTitleValue: (UILabel, (UILabel, UIImageView))

    ) -> [NSLayoutConstraint] {
        let previousValueLabel = previousLabelTitleValue.1.0
        let currentTitleLabel = lastLabelTitleValue.0
        let currentValueLabel = lastLabelTitleValue.1.0
        let imageView = lastLabelTitleValue.1.1

        return [
            currentTitleLabel.topAnchor.constraint(equalTo: previousValueLabel.bottomAnchor, constant: 20),
            currentTitleLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            currentTitleLabel.widthAnchor.constraint(equalTo: parentView.widthAnchor, multiplier: 0.8),
            currentValueLabel.topAnchor.constraint(equalTo: currentTitleLabel.bottomAnchor),
            currentValueLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            currentValueLabel.widthAnchor.constraint(equalTo: parentView.widthAnchor, multiplier: 0.8),
            currentValueLabel.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -30),
            imageView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -10),
            imageView.topAnchor.constraint(equalTo: currentTitleLabel.bottomAnchor, constant: -20)
        ]
    }

    private func addToParentView(labelsTitleAndValue: (UILabel, (UILabel, UIImageView))) {
        parentView.addSubview(labelsTitleAndValue.0)
        parentView.addSubview(labelsTitleAndValue.1.0)
        parentView.addSubview(labelsTitleAndValue.1.1)
    }

    private func addToParentView(label: UILabel) {
        parentView.addSubview(label)
    }

    private func createLabelsFor(containerElement: CulturalPracticeInputMultiSelectContainer) -> [(UILabel, (UILabel, UIImageView))] {
        let inputTitlesValues = initLabelTitleAndValueWith(culturalInputElement: containerElement.culturalInputElement)
        let multiSlectTitlesValues = initLabelTitleAndValueWith(culturalMultiSelectElement: containerElement.culturalPracticeMultiSelectElement)
        return (inputTitlesValues + multiSlectTitlesValues)
    }

    private func initLabelTitleAndValueWith(culturalInputElement: [CulturalPracticeElementProtocol]) -> [(UILabel, (UILabel, UIImageView))] {
        var labelTitleValue: [(UILabel, (UILabel, UIImageView))] = []

        (0..<culturalInputElement.count).forEach { index in
            if let culturalPracticeInputElement = culturalInputElement[index] as? CulturalPracticeInputElement {

                labelTitleValue.append(
                    (
                        createLabelFor(title: culturalPracticeInputElement.title),
                        createLabelFor(culturalPracticeValue: culturalPracticeInputElement.value)
                    )
                )
            }
        }

        return labelTitleValue
    }

    private func initLabelTitleAndValueWith(culturalMultiSelectElement: [CulturalPracticeElementProtocol]) -> [(UILabel, (UILabel, UIImageView))] {
        var labelTitleValue: [(UILabel, (UILabel, UIImageView))] = []

        (0..<culturalMultiSelectElement.count).forEach { index in
            if let culturalPracticeMultiSelectElement = culturalMultiSelectElement[index] as? CulturalPracticeMultiSelectElement {
                labelTitleValue.append(
                    (
                        createLabelFor(title: culturalPracticeMultiSelectElement.title),
                        createLabelFor(culturalPracticeValue: culturalPracticeMultiSelectElement.value)
                    )
                )
            }
        }

        return labelTitleValue
    }

    private func createLabelFor(titleCell: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "Arial", size: 35)
        label.textColor = Util.getOppositeColorBlackOrWhite()
        label.text = titleCell
        return label
    }

    private func createLabelFor(title: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "Arial", size: 15)
        label.textColor = Util.getOppositeColorBlackOrWhite()
        label.text = title
        return label
    }

    private func createLabelFor(culturalPracticeValue: CulturalPracticeValueProtocol?) -> (UILabel, UIImageView) {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "Arial", size: 25)

        if culturalPracticeValue != nil {
            label.text = culturalPracticeValue!.getValue()
            label.textColor = Util.getOppositeColorBlackOrWhite()
            return (label, createImageViewYes())
        }

        label.text = NSLocalizedString("Veuillez choisir une valuer", comment: "Veuillez choisir une valuer")
        label.textColor = .red
        return (label, createImageViewNo())
    }

    private func createImageViewYes() -> UIImageView {
        let imageView = UIImageView(image: getImageIconYes())
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView

    }

    private func createImageViewNo() -> UIImageView {
        let imageView = UIImageView(image: getImageIconNo())
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    private func getImageIconYes() -> UIImage? {
        UIImage(named: "yes48")
    }

    private func getImageIconNo() -> UIImage? {
        UIImage(named: "no48")
    }

}
