//
//  CulturalPraticeView.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-19.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit
import RxSwift

class CulturalPracticeFormView: UIView {

    let fieldDetailsTableViewHeader: FieldDetailsTableViewHeader = {
        let fieldDetailsTableViewHeader = FieldDetailsTableViewHeader()
        fieldDetailsTableViewHeader.translatesAutoresizingMaskIntoConstraints = false
        fieldDetailsTableViewHeader.titleFieldButton = "Parcelle"
        fieldDetailsTableViewHeader.titleCulturalPracticeButton = "Pratique Culturelle"
        fieldDetailsTableViewHeader.backgroundColor = Util.getBackgroundColor()
        fieldDetailsTableViewHeader.alpha = Util.getAlphaValue()
        return fieldDetailsTableViewHeader
    }()

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

    func initFieldButton(_ buttonElement: ButtonElement? = nil, withAction actionButton: @escaping () -> Void) {
        fieldDetailsTableViewHeader.initHandleFieldButton {
            actionButton()
        }
    }

    func initCulturalPracticeButton(_ buttonElement: ButtonElement? = nil, withAction actionButton: @escaping () -> Void) {
        fieldDetailsTableViewHeader.initHandleCulturalPracticeButton {
            actionButton()
        }
    }

    func initCell(_ cell: UITableViewCell, withData selectElement: SelectElement) -> UITableViewCell {
        removeContainerElementViewToContainerView(cell.contentView)
        configLabelTitle(cell.textLabel, elementUIData: selectElement)
        configDetailLabel(cell.detailTextLabel, value: selectElement.value)
        configAccessoryViewCell(cell, value: selectElement.value)
        return cell
    }

    func initCell(
        _ cell: UITableViewCell,
        withData rowWithButton: RowWithButton,
        andHandle handleAddButton: @escaping () -> Void
    ) -> UITableViewCell {
        removeContainerElementViewToContainerView(cell.contentView)
        cell.detailTextLabel?.font = UIFont(name: "Arial", size: 20)
        cell.textLabel?.font = UIFont(name: "Arial", size: 15)
        cell.textLabel?.text = NSLocalizedString("Cliquer sur le boutton", comment: "Cliquer sur le boutton")
        cell.detailTextLabel?.textColor = Util.getOppositeColorBlackOrWhite()
        cell.detailTextLabel?.text = rowWithButton.title

        if !(cell.accessoryView is UIButton) {
            cell.accessoryView = createAddButton(handleAddButton: handleAddButton)
        }

        return cell
    }

    func initCell(_ cell: UITableViewCell, withData elementUIListData: ElementUIListData) -> UITableViewCell {
        cell.textLabel?.text = nil
        cell.detailTextLabel?.text = nil
        cell.accessoryView = nil
        removeContainerElementViewToContainerView(cell.contentView)
        let container = ContainerElementView(elementUIListData: elementUIListData)
        container.addViewTo(contentView: cell.contentView)
        return cell
    }

    func createAddButton(handleAddButton: @escaping () -> Void) -> UIButton {
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

    func initCell(
        _ cell: UITableViewCell,
        inputElement: InputElement
    ) -> UITableViewCell {
        removeContainerElementViewToContainerView(cell.contentView)

        configLabelTitle(cell.textLabel, elementUIData: inputElement)
        configDetailLabel(cell.detailTextLabel, value: inputElement.value, unitType: inputElement.unitType)

        configAccessoryViewCell(cell, value: inputElement.value)
        return cell
    }

    private func configAccessoryViewCell(_ cell: UITableViewCell, value: String?) {
        if let value = value, !value.isEmpty {
            let imageViewYes = UIImageView(image: getImageIconYes())
            cell.accessoryView = imageViewYes
            return imageViewYes.sizeToFit()
        }

        let imageViewNo = UIImageView(image: getImageIconNo())
        cell.accessoryView = imageViewNo
        imageViewNo.sizeToFit()
    }

    private func removeContainerElementViewToContainerView(_ containerView: UIView) {
        containerView.viewWithTag(ContainerElementView.TAG)?.removeFromSuperview()
    }

    @objc private func handleAddButton(sender: UIButton) {
        self.handleAddButtonFunc?()
    }

    private func configDetailLabel(_ detailLabel: UILabel?, value: String? = nil, unitType: String? = nil) {
        detailLabel?.font = UIFont(name: "Arial", size: 20)
        detailLabel?.numberOfLines = 2

        if let value = value, !value.isEmpty {
            detailLabel?.text = value + " " + (unitType ?? "")
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

    private func configLabelTitle(_ labelTitle: UILabel?, elementUIData: ElementUIData) {
        labelTitle?.font = UIFont(name: "Arial", size: 15)
        labelTitle?.textColor = Util.getOppositeColorBlackOrWhite()
        labelTitle?.numberOfLines = 2
        labelTitle?.text = elementUIData.title
    }

    private func initConstraintTableView() {
        addSubview(tableView)
        addSubview(fieldDetailsTableViewHeader)

        NSLayoutConstraint.activate([
            fieldDetailsTableViewHeader.topAnchor.constraint(equalTo: topAnchor),
            fieldDetailsTableViewHeader.leadingAnchor.constraint(equalTo: leadingAnchor),
            fieldDetailsTableViewHeader.trailingAnchor.constraint(equalTo: trailingAnchor),
            fieldDetailsTableViewHeader.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
            tableView.topAnchor.constraint(equalTo: fieldDetailsTableViewHeader.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9)
        ])
    }

    // TODO afficher les messages d'erreur pour les dose fumier
    private func printMesageErrorNotCompletedDoseFumier() {
        _ = Observable.just(0)
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .do(onNext: {_ in print("1") })
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .do(onNext: { _ in print("2") })
            .subscribe()
    }

    // TODO afficher les messages d'erreur pour les dose fumier
    private func printMessageErrorMaxDoseFumier() {

    }
}
