//
//  CulturalPracticeFormViewModel.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class CulturalPracticeFormViewModelImpl: CulturalPracticeFormViewModel {
    let culturalPracticeFormObs: Observable<CulturalPracticeFormState>
    var disposableCulturalPracticeFormObs: Disposable?
    var disposableDispatchActionUpdateElement: Disposable?
    var viewController: UIViewController?
    var multiSelectElement: CulturalPracticeMultiSelectElement?
    var hasSubscribeToState = false
    var pickerView: UIPickerView?
    let actionDispatcher: ActionDispatcher

    init(
        culturalPracticeFormObs: Observable<CulturalPracticeFormState>,
        actionDispatcher: ActionDispatcher
    ) {
        self.culturalPracticeFormObs = culturalPracticeFormObs
        self.actionDispatcher = actionDispatcher
    }

    public func subscribeToCulturalPracticeFormObs() {
        if !hasSubscribeToState {
            hasSubscribeToState = true
            self.initHandleCloseButton()
            self.disabledInteractiveDismissPresentedView()

            disposableCulturalPracticeFormObs = culturalPracticeFormObs.subscribe { event in
                guard let selectElement = event.element?.culturalPraticeElement as? CulturalPracticeMultiSelectElement,
                    let fieldType = event.element?.fieldType,
                    let culturalPracticeFormStateSubAction = event.element?.culturalPracticeSubAction
                    else { return }

                switch culturalPracticeFormStateSubAction {
                case .newDataForm:
                    self.handleNewFormData(multiSelectElement: selectElement, fieldType: fieldType)
                case .printAlert:
                    self.handlePrintAlert()
                case .formIsDirty:
                    print("form is Dirty")
                    break
                case .closeWithSave:
                    self.handleCloseWithSave(selectElement: selectElement)
                case .closeWithoutSave:
                    print("close without save")
                    break
                }
            }
        }
    }

    public func disabledInteractiveDismissPresentedView() {
        getCulturalPracticeFormViewController().isModalInPresentation = true
    }

    public func handle(numberOfRowsInComponent component: Int) -> Int {
        self.multiSelectElement!.tupleCulturalTypeValue.count
    }

    public func handle(titleForRow row: Int) -> String {
        self.multiSelectElement!.tupleCulturalTypeValue[row].1
    }

    public func handle(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width * 0.9, height: 90))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = self.multiSelectElement!.tupleCulturalTypeValue[row].1
        label.textColor = Util.getOppositeColorBlackOrWhite()
        label.sizeToFit()
        return label
    }

    public func disposeToCulturalPracticeFormObs() {
        disposableCulturalPracticeFormObs?.dispose()
        disposableDispatchActionUpdateElement?.dispose()
    }

    public func dispatchFormIsDirty() {
        self.disposableDispatchActionUpdateElement = self.runInSchedulerBackground {
            self.actionDispatcher.dispatch(CulturalPracticeFormAction.SetFormIsDirtyAction(isDirty: true))
        }
    }

    private func handleNewFormData(multiSelectElement: CulturalPracticeMultiSelectElement, fieldType: FieldType) {
        setSelectElement(selectElement: multiSelectElement)
        setTitle(multiSelectElement.title)
        setTextDetailWith(fieldType: fieldType, and: multiSelectElement)
        setPickerView(pickerView: initPickerViewWith(selectElement: multiSelectElement))
        initCurrentValueOfPickerView()
        initHandleValidateButton()
    }

    private func handlePrintAlert() {
        let alertController = createAlert()
        addActionYesTo(alertController: alertController)
        addActionNoTo(alertController: alertController)
        presentedAlert(alertController: alertController)
    }

    private func createAlert() -> UIAlertController {
        return UIAlertController(
            title: NSLocalizedString(
                "Voulez-vous enregistrer la valeur choisie ?",
                comment: "Voulez-vous enregistrer la valeur choisie ?"
            ),
            message: nil,
            preferredStyle: .alert
        )
    }

    private func addActionYesTo(alertController: UIAlertController) {
        alertController.addAction(
            UIAlertAction(
                title: NSLocalizedString("Oui", comment: "Oui"),
                style: .default,
                handler: { _ in
                    self.dispatchClosePresentedViewControllerWithSave()
            })
        )
    }

    private func addActionNoTo(alertController: UIAlertController) {
        alertController.addAction(
            UIAlertAction(
                title: NSLocalizedString("Non", comment: "Non"),
                style: .default,
                handler: { _ in
                    print("No action")
                    //TODO dispatch close form without save
            }
            )
        )
    }

    private func dispatchClosePresentedViewControllerWithSave() {
        let indexSelected = self.getSelectedIndexOfPickerView()

        self.disposableDispatchActionUpdateElement = self.runInSchedulerBackground {
            self.actionDispatcher.dispatch(
                CulturalPracticeFormAction.ClosePresentedViewControllerWithSaveAction(indexSelected: indexSelected)
            )
        }
    }

    private func presentedAlert(alertController: UIAlertController) {
        self.getCulturalPracticeFormViewController().present(alertController, animated: true)
    }

    private func initHandleValidateButton() {
        getCulturalPracticeFormView().handleValidateButton {
            // TODO dispatch clickButton validate
        }
    }

    private func handleCloseWithSave(selectElement: CulturalPracticeMultiSelectElement) {
        self.setSelectElement(selectElement: selectElement)

        self.disposableDispatchActionUpdateElement = self.runInSchedulerBackground {
            self.dispatchActionUpdateCulturalPracticeElement(action: self.createActionUpdateCulturalPracticeElementWith(selectElement: selectElement))
        }

        self.disposableDispatchActionUpdateElement = self.runInSchedulerMain {
            self.dismissViewController()
        }
    }

    private func closePresentedViewControllerWithoutSave() {
        self.dismissViewController()
    }

    private func dispatchClosePresentedViewController() {
        self.actionDispatcher.dispatch(
            CulturalPracticeFormAction.ClosePresentedViewControllerAction(indexSelected: self.getSelectedIndexOfPickerView())
        )
    }

    private func dismissViewController() {
        self.getCulturalPracticeFormViewController().dismiss(animated: true)
    }

    private func dispatchActionUpdateCulturalPracticeElement(action: CulturalPracticeAction.UpdateCulturalPracticeElement) {
        self.disposableDispatchActionUpdateElement = Completable.create { completableEvent in
            self.actionDispatcher.dispatch(action)
            completableEvent(.completed)
            return Disposables.create()
        }.subscribeOn(Util.getSchedulerBackground())
        .subscribe()
    }

    //TODO utils function
    private func runInSchedulerBackground(_ functionWhoRunInSchedulerBackground: @escaping () -> Void) -> Disposable {
        Completable.create { completableEvent in
            functionWhoRunInSchedulerBackground()
            completableEvent(.completed)
            return Disposables.create()
        }.subscribeOn(Util.getSchedulerBackground())
        .subscribe()
    }

    //TODO utils function
    private func runInSchedulerMain(_ functionWhoRunInSchedulerMain: @escaping () -> Void) -> Disposable {
        Completable.create { completableEvent in
            functionWhoRunInSchedulerMain()
            completableEvent(.completed)
            return Disposables.create()
        }.subscribeOn(Util.getSchedulerMain())
        .subscribe()
    }

    private func createActionUpdateCulturalPracticeElementWith(selectElement: CulturalPracticeMultiSelectElement) -> CulturalPracticeAction.UpdateCulturalPracticeElement {
        CulturalPracticeAction.UpdateCulturalPracticeElement(culturalPracticeElementProtocol: selectElement)
    }

    private func setSelectElementWithCurrentValue(currentIndexChooseValue: Int) {
        self.multiSelectElement!.value = self.multiSelectElement!.tupleCulturalTypeValue[currentIndexChooseValue].0
    }

    private func getSelectedIndexOfPickerView() -> Int {
        self.pickerView!.selectedRow(inComponent: 0)
    }

    private func setPickerView(pickerView: UIPickerView) {
        self.pickerView = pickerView
    }

    private func setSelectElement(selectElement: CulturalPracticeMultiSelectElement) {
        self.multiSelectElement = selectElement
    }

    private func setTitle(_ title: String) {
        getCulturalPracticeFormView().textTitle = title
    }

    private func setTextDetailWith(fieldType: FieldType, and culturalPracticeElementProtocol: CulturalPracticeElementProtocol) {
        switch fieldType {
        case .polygon(let polygon):
            getCulturalPracticeFormView().textDetail =
                "Choisir une valeur (\(culturalPracticeElementProtocol.title)) pour la parcelle \(polygon.id)"
        case .multiPolygon(let multipolygon):
            getCulturalPracticeFormView().textDetail =
                "Choisir une valeur (\(culturalPracticeElementProtocol.title)) pour la parcelle \(multipolygon.id)"
        }
    }

    private func initPickerViewWith(selectElement: CulturalPracticeMultiSelectElement?) -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.delegate = getCulturalPracticeFormViewController()
        pickerView.dataSource = getCulturalPracticeFormViewController()
        getCulturalPracticeFormView().initPickerView(pickerView: pickerView)
        return pickerView
    }

    private func initCurrentValueOfPickerView() {
        self.multiSelectElement?.value.map { valueElement in
            let firstIndex = type(of: valueElement).getValues()?.firstIndex { $0.0.getValue() == valueElement.getValue() }
            firstIndex.map { self.pickerView?.selectRow($0, inComponent: 0, animated: false) }
        }
    }

    private func getCulturalPracticeFormView() -> CuturalPracticeFormView {
        (viewController as! CulturalPracticeFormViewController).culturalPracticeFormView
    }

    private func getCulturalPracticeFormViewController() -> CulturalPracticeFormViewController {
        viewController as! CulturalPracticeFormViewController
    }

    private func initHandleCloseButton() {
        getCulturalPracticeFormView().handleCloseButton {
            self.dispatchClosePresentedViewController()
        }
    }
}

protocol CulturalPracticeFormViewModel {
    var viewController: UIViewController? {get set}
    func subscribeToCulturalPracticeFormObs()
    func disposeToCulturalPracticeFormObs()
    func handle(numberOfRowsInComponent component: Int) -> Int
    func handle(titleForRow row: Int) -> String
    func handle(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    func dispatchFormIsDirty()
}
