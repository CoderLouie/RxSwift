//
//  ObserverBase.swift
//  RxSwift
//
//  Created by Krunoslav Zaher on 2/15/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

/*
 当接收到error或completed事件或disposes时，
 标记自身为停止状态，不再接收任何事件
 */
class ObserverBase<Element> : Disposable, ObserverType {
    private let isStopped = AtomicInt(0)

    func on(_ event: Event<Element>) {
        switch event {
        case .next:
            if load(self.isStopped) == 0 {
                self.onCore(event)
            }
        case .error, .completed:
            if fetchOr(self.isStopped, 1) == 0 {
                self.onCore(event)
            }
        }
    }

    func onCore(_ event: Event<Element>) {
        rxAbstractMethod()
    }

    func dispose() {
        fetchOr(self.isStopped, 1)
    }
}
