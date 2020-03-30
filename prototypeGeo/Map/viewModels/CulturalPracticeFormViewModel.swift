//
//  CulturalPracticeFormViewModel.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift

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

    func subscribeToCulturalPracticeFormObs() {
        if !hasSubscribeToState {
            hasSubscribeToState = true

            disposableCulturalPracticeFormObs = culturalPracticeFormObs.subscribe { event in
                guard let culturalPracticeElement = event.element?.culturalPraticeElement,
                    let fieldType = event.element?.fieldType,
                    let culturalPracticeFormStateSubAction = event.element?.culturalPracticeSubAction
                    else { return }

                switch culturalPracticeFormStateSubAction {
                case .newDataForm:
                    self.handle(culturalPracticeElement: culturalPracticeElement, fieldType: fieldType)
                case .printAlert:
                    //TODO Afficher l'alerte
                    break
                }
            }
        }
    }

    private func handle(culturalPracticeElement: CulturalPracticeElementProtocol, fieldType: FieldType) {
        switch culturalPracticeElement {
        case let inputElement as CulturalPracticeInputElement:
            //TODO init input view
            print(inputElement)
        case let multiSelectElement as CulturalPracticeMultiSelectElement:
            handle(multiSelectElement: multiSelectElement, fieldType: fieldType)
        case let containerInputMultiSelect as CulturalPracticeInputMultiSelectContainer:
            //TODO init container view
            print(containerInputMultiSelect)
        default:
            break
        }
    }

    private func handle(multiSelectElement: CulturalPracticeMultiSelectElement, fieldType: FieldType) {
        setSelectElement(selectElement: multiSelectElement)
        setTitle(multiSelectElement.title)
        setTextDetailWith(fieldType: fieldType, and: multiSelectElement)
        setPickerView(pickerView: initPickerViewWith(selectElement: multiSelectElement))
        initCurrentValueOfPickerView()
        initHandleValidateButton()
    }

    private func initHandleValidateButton() {
        getCulturalPracticeFormView().handleValidateButton {
            let currentIndexChooseValue = self.getSelectedIndexOfPickerView()
            self.setSelectElementWithCurrentValue(currentIndexChooseValue: currentIndexChooseValue)
            self.dispatchActionUpdateCulturalPracticeElement(action: self.createActionUpdateCulturalPracticeElementWith())
            self.dismissViewController()
        }
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

    private func createActionUpdateCulturalPracticeElementWith() -> CulturalPracticeAction.UpdateCulturalPracticeElement {
        CulturalPracticeAction.UpdateCulturalPracticeElement(culturalPracticeElementProtocol: self.multiSelectElement!)
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

    func handle(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width * 0.9, height: 90))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = self.multiSelectElement!.tupleCulturalTypeValue[row].1
        label.textColor = Util.getOppositeColorBlackOrWhite()
        label.sizeToFit()
        return label
    }

    func handle(numberOfRowsInComponent component: Int) -> Int {
        self.multiSelectElement!.tupleCulturalTypeValue.count
    }

    func handle(titleForRow row: Int) -> String {
        self.multiSelectElement!.tupleCulturalTypeValue[row].1
    }

    private func getCulturalPracticeFormView() -> CuturalPracticeFormView {
        (viewController as! CulturalPracticeFormViewController).culturalPracticeFormView
    }

    private func getCulturalPracticeFormViewController() -> CulturalPracticeFormViewController {
        viewController as! CulturalPracticeFormViewController
    }

    func disposeToCulturalPracticeFormObs() {
        disposableCulturalPracticeFormObs?.dispose()
        disposableDispatchActionUpdateElement?.dispose()
    }

    func initHandleCloseButton() {
        if let formViewController = viewController as? CulturalPracticeFormViewController {
            formViewController.culturalPracticeFormView.handleCloseButton {
                //TODO afficher le modal pour sauvegarder ou pas
                self.viewController?.dismiss(animated: true)
            }
        }
    }
}

protocol CulturalPracticeFormViewModel {
    var viewController: UIViewController? {get set}
    func initHandleCloseButton()
    func subscribeToCulturalPracticeFormObs()
    func disposeToCulturalPracticeFormObs()
    func handle(numberOfRowsInComponent component: Int) -> Int
    func handle(titleForRow row: Int) -> String
    func handle(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
}
