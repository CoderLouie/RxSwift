//
//  RootViewController.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 4/6/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class Person: NSObject {
    @objc dynamic func say(_ name: String) {
        print("person say", name)
    }
    
    static func test(by bag: DisposeBag) {
        let p = Person()
        p.rx.sentMessage(#selector(Person.say(_:))).subscribe { param in
            print("rx sentMessage", param)
        } onError: { error in
            print("rx sentMessage error", error)
        }.disposed(by: bag)
        p.say("xiaoming")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            p.say("wangwu")
        }
    }
}

public class RootViewController : UITableViewController {
    let bag = DisposeBag()
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // force load
        _ = GitHubSearchRepositoriesAPI.sharedAPI
        _ = DefaultWikipediaAPI.sharedAPI
        _ = DefaultImageService.sharedImageService
        _ = DefaultWireframe.shared
        _ = MainScheduler.instance
        _ = Dependencies.sharedDependencies.reachabilityService
        
        let geoService = GeolocationService.instance
        geoService.authorized.drive(onNext: { _ in

        }).dispose()
        geoService.location.drive(onNext: { _ in

        }).dispose()
    }
}
