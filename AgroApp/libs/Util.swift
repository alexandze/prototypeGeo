//
//  Util.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

// TODO afficher les messages deinit seulement en mode debug
// TODO deinit les states
// TODO renomer les actionSuccess en actionResponse
class Util {

    private static var serialDispatchQueueSchedulerForReSwift: SerialDispatchQueueScheduler?
    private static var serialDispatchQueueSchedulerForRequestServer: SerialDispatchQueueScheduler?

    static func getOppositeColorBlackOrWhite() -> UIColor {
        UIColor {(trait: UITraitCollection) -> UIColor in
            switch trait.userInterfaceStyle {
            case .dark:
                return .white
            default:
                return .black
            }
        }
    }

    static func getColorBlackOrWhite() -> UIColor {
        UIColor {(trait: UITraitCollection) -> UIColor in
            switch trait.userInterfaceStyle {
            case .dark:
                return .darkText
            default:
                return .white
            }
        }
    }

    static func getBackgroundColor() -> UIColor {
        .systemGray6
    }

    static func getAlphaValue() -> CGFloat {
        0.95
    }

    static public func getSchedulerBackgroundForReSwift() -> SerialDispatchQueueScheduler {
        if serialDispatchQueueSchedulerForReSwift == nil {
            let conQueue = DispatchQueue(label: "com.uqtr.conQueueReSwift", attributes: .concurrent)
            serialDispatchQueueSchedulerForReSwift = SerialDispatchQueueScheduler(queue: conQueue, internalSerialQueueName: "com.uqtr.conQueue")
            return serialDispatchQueueSchedulerForReSwift!
        }

        return serialDispatchQueueSchedulerForReSwift!
    }

    static public func getSchedulerBackgroundForRequestServer() -> SerialDispatchQueueScheduler {
        if serialDispatchQueueSchedulerForRequestServer == nil {
            let conQueue = DispatchQueue(label: "com.uqtr.conQueueRequestServer", attributes: .concurrent)
            serialDispatchQueueSchedulerForRequestServer = SerialDispatchQueueScheduler(queue: conQueue, internalSerialQueueName: "com.uqtr.conQueueRequestServer")
            return serialDispatchQueueSchedulerForRequestServer!
        }

        return serialDispatchQueueSchedulerForRequestServer!
    }

    static func getSchedulerMain() -> MainScheduler {
        MainScheduler.instance
    }

    static public func runInSchedulerMain(_ functionWhoRunInSchedulerMain: @escaping () -> Void) -> Disposable {
        Completable.create { completableEvent in
            functionWhoRunInSchedulerMain()
            completableEvent(.completed)
            return Disposables.create()
        }.subscribeOn(Util.getSchedulerMain())
        .subscribe()
    }

    static public func runInSchedulerBackground(_ functionWhoRunInSchedulerBackground: @escaping () -> Void) -> Disposable {
        Completable.create { completableEvent in
            functionWhoRunInSchedulerBackground()
            completableEvent(.completed)
            return Disposables.create()
        }.subscribeOn(Util.getSchedulerBackgroundForReSwift())
        .subscribe()
    }

    static public func createRunCompletable(_ funcRun: @escaping () -> Void) -> Completable {
        Completable.create { completableEvent in
            funcRun()
            completableEvent(.completed)
            return Disposables.create()
        }.subscribeOn(getSchedulerBackgroundForReSwift())
        .observeOn(getSchedulerMain())

    }

    static func getAppDependency() -> AppDependencyContainer? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.appDependencyContainer
    }

    static func getGreenColor() -> UIColor {
        UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1)
    }
}

precedencegroup CompositionPrecedence {
    associativity: left
}

infix operator >>>: CompositionPrecedence

func >>> <T, U, V>(lhs: @escaping (T) -> U, rhs: @escaping (U) -> V) -> (T) -> V {
    return { rhs(lhs($0)) }
}
