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
            .subscribe {
                guard let state = $0.element, let subAction = state.subAction else { return }
                self.setValues(state: state)

                switch subAction {
                case .selectedFieldOnMapActionSuccess:
                    self.handleSelectedFieldOnMapActionSuccess()
                case .deselectedFieldOnMapActionSuccess:
                    self.handleDeselectedFieldOnMapActionSuccess()
                case .willSelectFieldOnListActionSucccess:
                    self.handleWillSelectFieldOnListActionSuccess()
                case .initFieldList:
                    self.handleInitFieldList()
                case .isAppearActionSuccess:
                    break
                case .updateFieldSuccess:
                    self.handleUpdateFieldSuccess()
                }
                self.dispatchSetTitleAction()
                self.dispatchSetCurrentViewControllerInNavigationAction()
                self.dispatchIsAppear()

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
}

// handler
extension FieldListViewModelImpl {
    private func handleSelectedFieldOnMapActionSuccess() {
        if fieldListState?.isAppear == nil || fieldListState!.isAppear == true {
            tableView?.beginUpdates()
            self.tableView?.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
            tableView?.endUpdates()
            return
        }

        tableView?.reloadData()
    }

    private func handleDeselectedFieldOnMapActionSuccess() {
        guard let indexDeleted = fieldListState?.indexForRemove else { return }

        if fieldListState?.isAppear == nil || fieldListState!.isAppear == true {
            tableView?.beginUpdates()
            self.tableView?.deleteRows(at: [IndexPath(row: indexDeleted, section: 0)], with: .top)
            tableView?.endUpdates()
            return
        }

        tableView?.reloadData()
    }

    private func handleWillSelectFieldOnListActionSuccess() {
        _ = dispatchDidSelectedFieldOnListActionObs()?
            .subscribe { _ in
                let appDelegate = self.viewController!.getAppDelegate()

                appDelegate.map {
                    self.viewController?.navigationController?.pushViewController($0.appDependencyContainer.processInitCulturalPracticeViewController(), animated: true)
                }
        }
    }

    private func handleInitFieldList() {
        dispatchSetCurrentViewControllerInNavigationAction()
    }

    public func handle(didSelectRowAt indexPath: IndexPath) {
        dispatchWillSelectFieldOnListAction(indexPath: indexPath)
    }

    private func handleUpdateFieldSuccess() {
        if fieldListState!.isAppear != nil && fieldListState!.isAppear == false {
            tableView?.reloadData()
        }
    }
}

extension FieldListViewModelImpl {
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
                .SetCurrentViewControllerInNavigationAction(currentViewControllerInNavigation: .fieldList)

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
        let action = FieldListAction.WillSelectFieldOnListAction(field: fieldSelected)
        dispatch(action: action)
    }

    private func dispatchDidSelectedFieldOnListActionObs() -> Completable? {
        guard let fieldSelected = fieldListState?.currentField else { return nil }

        return Util.createRunCompletable {
            let action = CulturalPracticeFormAction.SelectedFieldOnListAction(field: fieldSelected)
            self.actionDispatcher.dispatch(action)
        }
    }

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
}
