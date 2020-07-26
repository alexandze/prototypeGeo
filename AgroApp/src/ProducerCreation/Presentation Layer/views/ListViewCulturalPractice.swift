//
//  CulturalPraticeView.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-19.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class ListViewCulturalPractice: UIView {

    var handleAddButtonFunc: (() -> Void)?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
        initConstraintTableView()
    }

    let TAG_ADD_BUTTON = 50

    public let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGray6
        tableView.alpha = 0.95
        tableView.rowHeight = 80
        return tableView
    }()

    private func initConstraintTableView() {
        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    public func initCellFor(multiSelectElement: CulturalPracticeMultiSelectElement, cell: UITableViewCell) -> UITableViewCell {
        removeContainerElementViewTo(containerView: cell.contentView)
        config(labelTitle: cell.textLabel, culturalPracticeElementProtocol: multiSelectElement)
        config(detailLabel: cell.detailTextLabel, culturalPracticeValueProtocol: multiSelectElement.value)
        configAccessoryView(of: cell, culturalPracticeProtocol: multiSelectElement.value)
        return cell
    }

    func initCellFor(
        addElement: CulturalPracticeAddElement,
        cell: UITableViewCell,
        handleAddButton: @escaping () -> Void
    ) -> UITableViewCell {
        removeContainerElementViewTo(containerView: cell.contentView)
        cell.detailTextLabel?.font = UIFont(name: "Arial", size: 20)
        cell.textLabel?.font = UIFont(name: "Arial", size: 15)
        cell.textLabel?.text = NSLocalizedString("Cliquer sur le boutton", comment: "Cliquer sur le boutton")
        cell.detailTextLabel?.textColor = Util.getOppositeColorBlackOrWhite()
        cell.detailTextLabel?.text = addElement.title

        if !(cell.accessoryView is UIButton) {
            cell.accessoryView = createAddButton(handleAddButton: handleAddButton)
        }

        return cell
    }

    func initCellFor(containerElement: CulturalPracticeContainerElement, cell: UITableViewCell) -> UITableViewCell {
        cell.textLabel?.text = nil
        cell.detailTextLabel?.text = nil
        cell.accessoryView = nil
        removeContainerElementViewTo(containerView: cell.contentView)
        let container = ContainerElementView(containerElement: containerElement)
        container.addViewTo(contentView: cell.contentView)
        return cell
    }

    func initCellFor(inputElement: CulturalPracticeInputElement, cell: UITableViewCell) -> UITableViewCell {
        removeContainerElementViewTo(containerView: cell.contentView)
        config(
            labelTitle: cell.textLabel,
            culturalPracticeElementProtocol: inputElement
        )

        config(detailLabel: cell.detailTextLabel, culturalPracticeValueProtocol: inputElement.value)
        configAccessoryView(of: cell, culturalPracticeProtocol: inputElement.value)
        return cell
    }

    private func configAccessoryView(of cell: UITableViewCell, culturalPracticeProtocol: CulturalPracticeValueProtocol?) {
        if culturalPracticeProtocol != nil {
            let imageViewYes = UIImageView(image: getImageIconYes())
            cell.accessoryView = imageViewYes
            return imageViewYes.sizeToFit()
        }

        let imageViewNo = UIImageView(image: getImageIconNo())
        cell.accessoryView = imageViewNo
        imageViewNo.sizeToFit()
    }

    private func removeContainerElementViewTo(containerView: UIView) {
        containerView.viewWithTag(ContainerElementView.TAG)?.removeFromSuperview()
    }

    public func createAddButton(handleAddButton: @escaping () -> Void) -> UIButton {
        self.handleAddButtonFunc = handleAddButton
        let imageAdd = getImageIconAdd()
        let addButton = UIButton(type: .custom)
        addButton.setImage(imageAdd, for: .normal)
        addButton.tintColor = Util.getOppositeColorBlackOrWhite()
        addButton.sizeToFit()
        addButton.tag = TAG_ADD_BUTTON
        addButton.addTarget(self, action: #selector(handleAddButton(sender:)), for: .touchUpInside)
        return addButton
    }

    @objc private func handleAddButton(sender: UIButton) {
        self.handleAddButtonFunc?()
    }

    private func config(detailLabel: UILabel?, culturalPracticeValueProtocol: CulturalPracticeValueProtocol?) {
        detailLabel?.font = UIFont(name: "Arial", size: 20)
        detailLabel?.numberOfLines = 2

        if culturalPracticeValueProtocol != nil {
            detailLabel?.text = culturalPracticeValueProtocol!.getValue() + " " + getUnitFrom(culturalPracticeValueProtocol: culturalPracticeValueProtocol!)
            detailLabel?.textColor = Util.getGreenColor()
            return
        }

        detailLabel?.text = NSLocalizedString("Veuillez choisir une valeur", comment: "Veuillez choisir une valuer")
        detailLabel?.textColor = .red
    }

    private func getImageIconYes() -> UIImage? {
        UIImage(named: "yes48")
    }

    private func getImageIconNo() -> UIImage? {
        UIImage(named: "no48")
    }

    private func getImageIconAdd() -> UIImage? {
        UIImage(named: "add48")?.withRenderingMode(.alwaysTemplate)
    }

    private func config(labelTitle: UILabel?, culturalPracticeElementProtocol: CulturalPracticeElementProtocol) {
        labelTitle?.font = UIFont(name: "Arial", size: 15)
        labelTitle?.textColor = Util.getOppositeColorBlackOrWhite()
        labelTitle?.numberOfLines = 2
        labelTitle?.text = culturalPracticeElementProtocol.title
    }

    private func getUnitFrom(culturalPracticeValueProtocol: CulturalPracticeValueProtocol) -> String {
        guard let unit = culturalPracticeValueProtocol.getUnitType()?.convertToString() else {
            return ""
        }

        return unit
    }
}
