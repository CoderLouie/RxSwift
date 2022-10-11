//
//  ViewController.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 4/25/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import RxSwift

#if os(iOS)
    import UIKit
    typealias OSViewController = UIViewController
#elseif os(macOS)
    import Cocoa
    typealias OSViewController = NSViewController
#endif

class ViewController: OSViewController {
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("[\(type(of: self)) viewDidLoad]")
    }
    deinit {
        print("[\(type(of: self)) deinit]")
    }
    
}

func traceResCount() {
    print("Resource count \(RxSwift.Resources.total)")
}
public extension DispatchQueue {
    /// Execute the provided closure after a `TimeInterval`.
    ///
    /// - Parameters:
    ///   - delay:   `TimeInterval` to delay execution.
    ///   - closure: Closure to execute.
    @discardableResult
    func after(_ delay: TimeInterval, execute closure: @escaping () -> Void) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: closure)
        asyncAfter(deadline: .now() + delay, execute: item)
        return item
    }
}
