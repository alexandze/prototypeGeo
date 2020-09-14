//
//  FieldListViewModel.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-02-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift
import UIKit
import ReSwift

class FieldListViewModelImpl: FieldListViewModel {

    let fieldListStateObs: Observable<FieldListState>
    let actionDispatcher: ActionDispatcher
    var disposableFieldListState: Disposable?
    var fieldList: [Field] = []
    var tableView: UITableView?
    weak var viewController: UIViewController?
    var fieldListState: FieldListState?
    var disposeActionDispatcher: Disposable?

    init(
        fieldListStateObs: Observable<FieldListState>,
        actionDispatcher: ActionDispatcher
    ) {
        self.fieldListStateObs = fieldListStateObs
        self.actionDispatcher = actionDispatcher
    }

    func subscribeToObservableFieldListState() {
        self.disposableFieldListState = fieldListStateObs
            .observeOn(MainScheduler.instance)
            .subscribe {[weak self] in
                guard let state = $0.element, let subAction = state.subAction else { return }
                self?.setValues(state: state)

                switch subAction {
                case .selectedFieldOnMapActionSuccess:
                    self?.handleSelectedFieldOnMapActionSuccess()
                case .deselectedFieldOnMapActionSuccess:
                    self?.handleDeselectedFieldOnMapActionSuccess()
                case .willSelectFieldOnListActionSucccess:
                    self?.handleWillSelectFieldOnListActionSuccess()
                case .initFieldList:
                    self?.handleInitFieldList()
                case .isAppearActionSuccess:
                    self?.handleIsAppearActionResponse()
                case .updateFieldSuccess:
                    self?.handleUpdateFieldSuccess()
                case .removeFieldResponse(indexPathFieldRemoved: let indexPathRemoveField, fieldRemoved: let fieldRemoved):
                    self?.handleRemoveFieldResponse(indexPathFieldRemoved: indexPathRemoveField, fieldRemoved: fieldRemoved)
                case .initNimSelectValueActionResponse:
                    print("initNimSelectValueActionResponse")
                case .checkIfAllFieldIsValidActionResponse(isAllFieldValid: let isAllFieldValid):
                    self?.handleCheckIfAllFieldIsValidActionResponse(isAllFieldValid)
                case .notResponse:
                    break
                }

                self?.config()
        }
    }

    func dispose() {
        _ = Util.runInSchedulerBackground {
            self.disposableFieldListState?.dispose()
        }

        self.dispatchIsDisappear()
    }

    func setTableView(tableView: UITableView) {
        self.tableView = tableView
    }

    private func setValues(state: FieldListState) {
        self.fieldListState = state
        self.fieldList = state.fieldList ?? []
    }

    private func config() {
        self.dispatchSetTitleAction()
        self.dispatchSetCurrentViewControllerInNavigationAction()
        self.dispatchIsAppear()
    }
}

// handler
extension FieldListViewModelImpl {

    func handle(didSelectRowAt indexPath: IndexPath) {
        dispatchWillSelectFieldOnListAction(indexPath: indexPath)
    }

    func handleRemoveFieldInList(editingStyle: UITableViewCell.EditingStyle, indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            self.dispatchRemoveField(indexPath: indexPath)
        default:
            break
        }
    }
    
    private func handleCheckIfAllFieldIsValidActionResponse(_ isAllFieldValid: Bool) {
        
    }

    private func handleIsAppearActionResponse() {
        guard let isAppear = self.fieldListState?.isAppear, isAppear else {
            return
        }

        tableView?.reloadData()
    }

    private func handleRemoveFieldResponse(indexPathFieldRemoved: IndexPath, fieldRemoved: Field) {
        tableView?.beginUpdates()
        self.tableView?.deleteRows(at: [indexPathFieldRemoved], with: .left)
        tableView?.endUpdates()

        let action = MapFieldAction.WillDeselectFieldOnMapAction(field: fieldRemoved)
        dispatch(action: action)
    }

    private func handleSelectedFieldOnMapActionSuccess() {
        if let isAppear = fieldListState?.isAppear, isAppear {
            tableView?.beginUpdates()
            self.tableView?.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
            tableView?.endUpdates()
            return
        }
    }

    private func handleDeselectedFieldOnMapActionSuccess() {
        guard let indexDeleted = fieldListState?.indexForRemove else { return }

        if let isAppear = fieldListState?.isAppear, isAppear {
            tableView?.beginUpdates()
            self.tableView?.deleteRows(at: [IndexPath(row: indexDeleted, section: 0)], with: .top)
            tableView?.endUpdates()
            return
        }
    }

    private func handleWillSelectFieldOnListActionSuccess() {
        let appDelegate = self.viewController!.getAppDelegate()

        appDelegate.map {
            self
                .viewController?
                .navigationController?
                .pushViewController(
                    $0.appDependencyContainer.processInitCulturalPracticeViewController(),
                    animated: true
            )
        }
    }

    private func handleInitFieldList() {
        dispatchSetCurrentViewControllerInNavigationAction()
    }

    private func handleUpdateFieldSuccess() {
        // TODO dispatch check if all Field is Valid
    }
}

// TODO Interaction
extension FieldListViewModelImpl {

    func dispatchIsDisappear() {
        let action = FieldListAction.IsAppearAction(isAppear: false)
        dispatch(action: action)
    }

    func dispatchIsAppear() {
        if fieldListState?.isAppear == nil || fieldListState!.isAppear == false {
            let action = FieldListAction.IsAppearAction(isAppear: true)
            dispatch(action: action)
        }
    }

    /// action for set title of TitleNavigationViewController
    private func dispatchSetTitleAction() {
        if fieldListState?.isAppear == nil || fieldListState!.isAppear == false {
            let action = ContainerTitleNavigationAction.SetTitleAction(title: fieldListState?.title ?? "")
            dispatch(action: action)
        }
    }

    private func dispatchSetCurrentViewControllerInNavigationAction() {
        if fieldListState?.isAppear == nil || fieldListState!.isAppear == false {
            let action = ContainerTitleNavigationAction
                .SetCurrentViewControllerAction(currentViewControllerInNavigation: .fieldList)

            dispatch(action: action)
        }
    }

    private func dispatch(action: Action) {
        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(action)
        }
    }

    private func dispatchWillSelectFieldOnListAction(indexPath: IndexPath) {
        let fieldSelected = fieldList[indexPath.row]
        let action = FieldListAction.SelectFieldOnListAction(field: fieldSelected)
        dispatch(action: action)
    }

    private func dispatchRemoveField(indexPath: IndexPath) {
        let action = FieldListAction.RemoveFieldAction(indexPath: indexPath)

        _ = Util.runInSchedulerBackground { [weak self] in
            self?.actionDispatcher.dispatch(action)
        }
    }
}

protocol FieldListViewModel {
    func subscribeToObservableFieldListState()
    func dispose()
    func setTableView(tableView: UITableView)
    var  fieldList: [Field] {get}
    var  viewController: UIViewController? {get set}
    func handle(didSelectRowAt indexPath: IndexPath)
    func dispatchIsDisappear()
    func dispatchIsAppear()
    func handleRemoveFieldInList(editingStyle: UITableViewCell.EditingStyle, indexPath: IndexPath)
}
