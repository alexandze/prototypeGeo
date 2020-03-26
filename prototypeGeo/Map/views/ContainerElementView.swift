//
//  ContainerElementView.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-24.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class ContainerElementView: UIView {
    let TAG = 89

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(containerElement: CulturalPracticeInputMultiSelectContainer, contentView: UIView) {
        super.init(frame: .zero)
        initView(containerElement: containerElement, contentView: contentView)
    }

    private func initView(containerElement: CulturalPracticeInputMultiSelectContainer, contentView: UIView) {
        let labels = createLabelsFor(containerElement: containerElement)
        print(labels)
    }

    private func createLabelsFor(containerElement: CulturalPracticeInputMultiSelectContainer) -> [(UILabel, UILabel)] {
        let inputTitlesValues = initLabelTitleAndValueWith(culturalInputElement: containerElement.culturalInputElement)
        let multiSlectTitlesValues = initLabelTitleAndValueWith(culturalMultiSelectElement: containerElement.culturalPracticeMultiSelectElement)
        return (inputTitlesValues + multiSlectTitlesValues)
    }

    func initLabelTitleAndValueWith(culturalInputElement: [CulturalPracticeElement]) -> [(UILabel, UILabel)] {
        var labelTitleValue: [(UILabel, UILabel)] = []

        (0..<culturalInputElement.count).forEach { index in
            if case .culturalPracticeInputElement(let culturalPracticeInputElement) = culturalInputElement[index] {

                labelTitleValue.append(
                    (
                        createLabelTitle(title: culturalPracticeInputElement.titleInput),
                        createLabelValue(culturalPracticeValue: culturalPracticeInputElement.value)
                    )
                )
            }
        }

        return labelTitleValue
    }

    func initLabelTitleAndValueWith(culturalMultiSelectElement: [CulturalPracticeElement]) -> [(UILabel, UILabel)] {
        var labelTitleValue: [(UILabel, UILabel)] = []

        (0..<culturalMultiSelectElement.count).forEach { index in
            if case CulturalPracticeElement.culturalPracticeMultiSelectElement(let culturalPracticeMultiSelectElement) = culturalMultiSelectElement[index] {
                labelTitleValue.append(
                    (
                        createLabelTitle(title: culturalPracticeMultiSelectElement.title),
                        createLabelValue(culturalPracticeValue: culturalPracticeMultiSelectElement.value)
                    )
                )
            }
        }

        return labelTitleValue
    }

    func createLabelTitle(title: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "Arial", size: 15)
        label.textColor = Util.getOppositeColorBlackOrWhite()
        label.text = title
        return label
    }

    func createLabelValue(culturalPracticeValue: CulturalPracticeValue?) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "Arial", size: 25)

        if culturalPracticeValue != nil {
            label.text = culturalPracticeValue!.getValue()
            label.textColor = Util.getOppositeColorBlackOrWhite()
            return label
        }

        label.text = NSLocalizedString("Veuillez choisir une valuer", comment: "Veuillez choisir une valuer")
        label.textColor = .red
        return label
    }

}
