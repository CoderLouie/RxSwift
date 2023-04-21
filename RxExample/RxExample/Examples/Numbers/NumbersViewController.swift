//
//  NumbersViewController.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 12/6/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension NumbersViewController {
    private func test1() {
        test_59()
    }
    private func test2() {
        test_other4()
    }
    private func test3() {
        test_observerOn()
    }
}

final class Player {
    let relay: BehaviorRelay<Int>
    init(score: Int) {
        relay = BehaviorRelay(value: score)
    }
}

// MARK: - 六、Subject的使用
extension NumbersViewController {
    func test_memory() {
        
    }
}
// MARK: - 七、Subject的使用
extension NumbersViewController {
    
    func test_other4() {
        //1. 创建序列
        let ob = Observable<Int>.create { obserber -> Disposable in
            // 3:发送信号
//            obserber.onNext(3)
            obserber.onError(RxError.timeout)
            return Disposables.create()
        }
        let ob1 = Observable<String>.create { obserber -> Disposable in
            // 3:发送信号
            obserber.onNext("success")
            obserber.onCompleted()
            return Disposables.create()
        }
        consume(Observable.just(10).flatMap { _ in ob }.flatMap { _ in ob1 })
    }
    
    func test_other3() {
        traceResCount()
        //1. 创建序列
        let ob = Observable<Int>.create { obserber -> Disposable in
            // 3:发送信号
            DispatchQueue.main.after(1) {
                obserber.onNext(3)
                obserber.onCompleted()
            }
            return Disposables.create {
                print("销毁释放了")
            }
        }
        var disposable: Disposable?
        disposable =  consume1(ob.observe(on: ConcurrentDispatchQueueScheduler(qos: .default)).map { "\($0)" })
        traceResCount()
        DispatchQueue.main.after(2) {
            traceResCount()
        }
    }
    func test_other21() {
        traceResCount()
        //1. 创建序列
        let ob = Observable<Int>.create { obserber -> Disposable in
            // 3:发送信号
            DispatchQueue.main.after(1) {
                obserber.onNext(3)
                obserber.onCompleted()
            }
            return Disposables.create {
                print("销毁释放了")
            }
        }
        let dispose = consume1(ob)
        traceResCount()
//        dispose.dispose()
        DispatchQueue.main.after(2) {
            traceResCount()
        }
    }
    func test_other2() {
        traceResCount()
        //1. 创建序列
        let ob = Observable<Int>.create { obserber -> Disposable in
            // 3:发送信号
            obserber.onNext(3)
            obserber.onCompleted()
            return Disposables.create {
                print("销毁释放了")
            }
        }
        traceResCount()
        let dispose = consume1(ob)
        traceResCount()
//        dispose.dispose()
        DispatchQueue.main.async {
            traceResCount()
        }
    }
    func test_other1() {
        //1. 创建序列
        let ob = Observable<Int>.create { obserber -> Disposable in
            // 3:发送信号
            DispatchQueue.global().async {
                obserber.onNext(3)
            }
            DispatchQueue.main.async {
                obserber.onCompleted()
            }
            return Disposables.create()
        }
        consume(ob)
    }
    func test_observerOn() {
        //1. 创建序列
        let ob = Observable<Int>.create { obserber -> Disposable in
            // 3:发送信号
            obserber.onNext(3)
            obserber.onCompleted()
            return Disposables.create()
        }
        consume(ob.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default)).map { num in
            return "发送了 \(num)"
        }.observe(on: MainScheduler.instance))
//        consume(ob.observe(on: ConcurrentDispatchQueueScheduler(qos: .default)).map { num in
//            return "发送了 \(num)"
//        }.observe(on: MainScheduler.instance))
    }
}
// MARK: - 六、Subject的使用
extension NumbersViewController {
    func test_6() {
        
    }
    func test_65() {
        
        let sub = BehaviorRelay(value: 2)
        print(sub.value)
        consume(tag: "第一次订阅", sub.asObservable())
        sub.accept(20)
        print(sub.value)
        // 其实就是对BehaviorSubject的封装，不能发送error和complete事件，同时可以获取发送的value值
        /*
         2
         第一次订阅onNext: 2
         第一次订阅onNext: 20
         20
         */
    }
    func test_64() {
        
        let sub = AsyncSubject<Int>()
        sub.onNext(4)
        sub.onNext(5)
        sub.onNext(6)
        consume(tag: "第一次订阅", sub)
        sub.onNext(7)
        consume(tag: "第二次订阅", sub)
        sub.onCompleted()
        // 只有当发送onCompleted事件时才会向所有订阅者发送最后一次保存的元素并结束序列
        /*
         第一次订阅onNext: 7
         第二次订阅onNext: 7
         第一次订阅onCompleted
         第一次订阅onDisposed
         第二次订阅onCompleted
         第二次订阅onDisposed
         */
    }
    func test_63() {
        
        let sub = ReplaySubject<Int>.create(bufferSize: 3)
        sub.onNext(4)
        sub.onNext(5)
        sub.onNext(6)
        consume(tag: "第一次订阅", sub)
        sub.onNext(7)
        consume(tag: "第二次订阅", sub)
        /*
         第一次订阅onNext: 4
         第一次订阅onNext: 5
         第一次订阅onNext: 6
         第一次订阅onNext: 7
         第二次订阅onNext: 5
         第二次订阅onNext: 6
         第二次订阅onNext: 7
         */
    }
    func test_62() {
        
        let sub = BehaviorSubject(value: 2)
        consume(tag: "第一次订阅", sub)
        sub.onNext(4)
        consume(tag: "第二次订阅", sub)
        sub.onNext(5)
        /*
         第一次订阅onNext: 2
         第一次订阅onNext: 4
         第二次订阅onNext: 4
         第一次订阅onNext: 5
         第二次订阅onNext: 5
         */
    }
    
    func test_61() {
        let sub = PublishSubject<Int>()
        sub.onNext(1)
        sub.onNext(2)
        consume(tag: "第一次订阅", sub)
        sub.onNext(3)
        consume(tag: "第二次订阅", sub)
        sub.onNext(4)
        /*
         第一次订阅onNext: 3
         第一次订阅onNext: 4
         第二次订阅onNext: 4
         */
    }
}


// MARK: - 五、高阶函数
extension NumbersViewController {
    func test_524() {
        let ob = Observable<String>.create {
            print("beging")
            sleep(2)
            $0.onNext("start")
            $0.onCompleted()
            return Disposables.create()
        }.publish()
        consume(tag: "第一次订阅", ob)
        consume(tag: "第二次订阅", ob)
        let _ = ob.connect()
    }
    
    func test_523() {
        var count = 1
        let ob = Observable<String>.create {
            $0.onNext("fish1")
            $0.onNext("fish2")
            if count < 5 {
                $0.onError(RxError.argumentOutOfRange)
                count += 1
            }
            $0.onNext("go")
            $0.onNext("hello")
            $0.onCompleted()
            return Disposables.create()
        }
        consume(ob.retry(2)
                    .debug("retry")
        )
        /*
         订阅到:fish1
         订阅到:fish2
         订阅到:fish1
         订阅到:fish2
         error: Argument out of range.
         */
        // 相当于重复2次调用序列的闭包subscribeHandler
    }
    func test_522() {
        let sub = PublishSubject<String>()
        // 1.
//        consume(sub.catchAndReturn("fish"))
        // 2.
        consume(sub.catch { _ in Observable.of("fish") })
        // 1和2 实现的效果一样
        sub.onNext("good")
        sub.onNext("friend")
        sub.onError(RxError.argumentOutOfRange)
    }
    func test_521() {
        // 一般用于控制顺序
        let sub1 = BehaviorSubject(value: 1)
        let sub2 = BehaviorSubject(value: 2)
        let sub = BehaviorSubject(value: sub1)
        consume(sub.concat())
        sub1.onNext(3)
        sub1.onNext(4)
        sub.onNext(sub2)// 切换源
        sub2.onNext(5)
        sub2.onNext(6)
        sub1.onCompleted()// sub1完成后才能订阅到sub2发出的数据
        sub2.onNext(7)
        // 1,3,4,6,7
    }
    func test_520() {
        consume(Observable.of(1,10,100).reduce(0, accumulator: +))
        // 111
    }
    func test_519() {
        Observable.of(1,2,3,4,5)
            .toArray()
            .subscribe { arr in
                print(arr)
            } onFailure: { err in
                print(err)
            } onDisposed: {
                print("onDisposed")
            }.disposed(by: disposeBag)

    }
    func test_518() {
        let sub1 = PublishSubject<Int>()
        let sub2 = PublishSubject<Int>()
        consume(sub1.skip(until: sub2))// sub2发出信号后，sub1才能发送信号，类似一个开关
        sub1.onNext(1)
        sub1.onNext(2)
        sub2.onNext(3)
        sub1.onNext(4)
        sub1.onNext(5)
        // 4,5
    }
    func test_517() {
        consume(Observable.of(1,2,3,4,5).skip(1))
        // 2,3,4,5
        consume(Observable.of(1,2,3,4,5).skip(while: {$0<4}))// 跳过符合条件的序列值
        // 4,5
    }
    func test_516() {
        let sub1 = PublishSubject<Int>()
        let sub2 = PublishSubject<Int>()
        consume(sub1.take(until: sub2))
        sub1.onNext(1)
        sub1.onNext(2)
        sub2.onNext(3)
        // 1, 2
    }
    func test_515() {
        consume(Observable.of(1,5,3,2,4).take(while: { $0 > 2 }))
        // 没有符合的
        consume(Observable.of(1,5,3,2,4).take(until: { $0 > 4 }))
        // 1
        consume(Observable.of(5,3,2,4,1).take(while: { $0 > 2 }))// 一旦条件不满足就停止发送
        // 5,3
        consume(Observable.of(1,2,3,4,5).take(until: { $0 > 4 }))// 一旦条件满足就停止发送
        // 1,2,3,4
    }
    func test_514() {
//        consume(Observable.of(1,2,3,4,5).take(3))
        // 1,2,3
        consume(Observable.of(1,2,3,4,5).takeLast(3))
        // 3,4,5
    }
    func test_513() {
        consume(Observable.of(1,2,3,4,5).single())
        // "Sequence contains more than one element."
        consume(Observable.of(1,2,3,4,5).single {$0>=2})
        // 2, "Sequence contains more than one element."
        consume(Observable.of(1,2,3,4,5).single {$0==2})
        // 2
    }
    func test_512() {
        consume(Observable.of(1,2,3,4,5).element(at: 1))
        // 2
    }
    func test_511() {
        consume(Observable.of(1,2,2,3,3,3,4,4,4,4).distinctUntilChanged())
        // 1,2,3,4
    }
    func test_510() {
        consume(Observable.of(1,2,3,4,5).filter { $0 % 2 > 0 })
        // 1, 3, 5
    }
    func test_59() {
        let ob = Observable.of(10,20,30,40)
        consume(ob.reduce(2, accumulator: +))
        // 102
        consume(ob.scan(2, accumulator: +))
        // 12, 32, 62, 102
    }
    /*
     latMap和flatMapLatest的区别是，当原序列有新的事件发生的时候，flatMapLast 会自动取消上一个事件的订阅，转到新的事件的订阅上面， flatMap则会订阅全部。
     */
    // MARK: flatMapLatest
    func test_58() {
        let player1 = Player(score: 20)
        let player2 = Player(score: 30)
        let relay = BehaviorRelay(value: player1)
        
        consume(relay.flatMapLatest { $0.relay })
        player1.relay.accept(40)
        player2.relay.accept(50)
        relay.accept(player2)
        player2.relay.accept(60)
        player1.relay.accept(70)
        player1.relay.accept(80)
        player2.relay.accept(90)
        // 20, 40, 50, 60, 90
    }
    // MARK: flatMap
    func test_57() {
        let player1 = Player(score: 20)
        let player2 = Player(score: 30)
        let relay = BehaviorRelay(value: player1)
        
        consume(relay.flatMap { $0.relay })
        player1.relay.accept(40)
        player2.relay.accept(50)
        relay.accept(player2)
        player2.relay.accept(60)
        player1.relay.accept(70)
        player1.relay.accept(80)
        player2.relay.accept(90)
        // 20, 40, 50, 60, 70, 80, 90
    }
    // MARK: Map
    func test_56() {
        consume(Observable.of(1,2,3).map { $0 + 2 })
    }
    func test_55() {
        let sub1 = BehaviorSubject(value: "1")
        let sub2 = BehaviorSubject(value: "2")
        let sub = BehaviorSubject(value: sub2)
        consume(sub.switchLatest())
        sub1.onNext("3")
        sub1.onNext("41")
        sub1.onNext("45")
        sub2.onNext("5")
        
        // 切换订阅源
        sub.onNext(sub1)
        sub2.onNext("6")
        sub1.onNext("7")
        /*
         2,5,45,7
         */
    }
    func test_54() {
        let sub1 = PublishSubject<Int>()
        let sub2 = PublishSubject<Int>()
        consume(Observable.of(sub1, sub2).merge())
        sub1.onNext(1)
        sub2.onNext(2)
        sub2.onNext(3)
        // 1,2,3
    }
    func test_53() {
        let ob = Observable.of(1,2,3,4)
            .startWith(5)
            .startWith(6)
            .startWith(7)
            .startWith(8,9,10)
        consume(ob)
        /*
         8,9,10,7,6,5,1,2,3,4
         */
    }
    // MARK: Zip
    func test_52() {
        let strSub = PublishSubject<String>()
        let intSub = PublishSubject<Int>()
        let ob = Observable.zip(strSub, intSub) {
            "\($0):\($1)"
        }
        consume(ob)
        intSub.onNext(11)
        intSub.onNext(12)
        strSub.onNext("test11")
        intSub.onNext(13)
        strSub.onNext("test12")
        strSub.onNext("test13")
        /*
         test11:11
         test12:12
         test13:13
         */
    }
    // MARK: combineLatest
    func test_51() {
        let strSub = PublishSubject<String>()
        let intSub = PublishSubject<Int>()
        let ob = Observable.combineLatest(strSub, intSub) {
            "\($0):\($1)"
        }
        consume(ob)
        strSub.onNext("Hello")
        strSub.onNext("this")
        strSub.onNext("is")
        strSub.onNext("combine")
        intSub.onNext(3)
        intSub.onNext(25)
        strSub.onNext("hello")
        /*
         combine:3
         combine:25
         hello:25
         */
    }
}
// MARK: - 四、Observable的创建
extension NumbersViewController {
    func test_4() {
        
    }
    func test_411() {
        // 永远不会发出 Event 也不会终止
        consume(Observable<Int>.never())
    }
    func test_410() {
        consume(Observable<Int>.error(RxError.argumentOutOfRange))
    }
    func test_49() {
        consume(Observable<Int>.repeatElement(2))
    }
    func test_48() {
        let ob = Observable<Int>.timer(.seconds(2), period: .seconds(1), scheduler: MainScheduler.asyncInstance)
//        consume()
        let _ = ob.subscribe {
            print("onNext \($0)")
        } onDisposed: {
            print("onDisposed")
        }

        
        // consume(Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.asyncInstance))
    }
    func test_47() {
        consume(Observable<Int>.generate(initialState: 0, condition: { $0 < 10 }, iterate: { $0 + 3 }))
    }
    func test_46() {
        consume(Observable<Int>.range(start: 3, count: 6))
    }
    func test_45() {
        var isEven = true
        Observable<Int>.deferred {
            isEven = !isEven
            if isEven {
                return Observable<Int>.of(2,4,6,8,10)
            } else {
                return Observable<Int>.of(1,3,5,7,9)
            }
        }
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
    }
    func test_44() {
        consume(Observable<[String: Any]>.from(optional: ["name":"fish","age":18]))
    }
    func test_43() { 
        consume(Observable<[Int]>.of([1,2,3]))
    }
    func test_42() {
        // 只有一个元素，订阅完成直接发送complete
        consume(Observable<[Int]>.just([1,2,3]))
    }
    func test_41() {
        // 用于创建一个空序列，只能接受到complete事件
        consume(Observable<Int>.empty())
    }
}
// MARK: - 三、Observer的创建
extension NumbersViewController {
    // 4. 使用 Binder 创建Observable
    func test_34() {
         //观察者
         let observer: Binder<String> = Binder(label) { (view, text) in
             //收到发出的索引数后显示到label上
             view.text = text
         }
         //Observable序列（每隔1秒钟发出一个索引数）
         let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
         observable
             .map { "当前索引数：\($0 )"}
             .bind(to: observer)
             .disposed(by: disposeBag)
         
    }
    // 3. 使用 AnyObserver 创建Observer
    func test_33() {
        //观察者
        let observer: AnyObserver<String> = AnyObserver { (event) in
           switch event {
           case .next(let data):
               print(data)
           case .error(let error):
               print(error)
           case .completed:
               print("completed")
           }
        }

        let observable = Observable.of("A", "B", "C")
        let _ = observable.subscribe(observer)
    }
    // 2. 在 bind/bindTo 方法中创建Observer
    func test_32() {
        //Observable序列（每隔1秒钟发出一个索引数）
        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        // 1
        observable
            .map { "当前索引数：\($0 )"}
            .bind { [weak self] (text) in
                //收到发出的索引数后显示到label上
                self?.label.text = text
            }
            .disposed(by: disposeBag)
        // 2
        observable
            .map { "当前索引数：\($0 )"}
            .bind(to: self.label.rx.text)
            .disposed(by: disposeBag)
    }
}

//https://juejin.cn/post/7081812555777179662

// MARK: - 二、序列的核心逻辑
extension NumbersViewController {
    func test_21() {
        // MARK: Create
        //1. 创建序列
        let ob = Observable<Any>.create { obserber -> Disposable in
            // 3:发送信号
            obserber.onNext("kyl发送了信号")
            obserber.onCompleted()
            return Disposables.create()
        }
        
        // 2:订阅信号
        let _ = ob.subscribe(onNext: { (text) in
            print("订阅到:\(text)")
        }, onError: { (error) in
            print("error: \(error)")
        }, onCompleted: {
            print("完成")
        }) {
            print("销毁")
        }
    }
}
 

class NumbersViewController: ViewController {
    @IBOutlet weak var number1: UITextField!
    @IBOutlet weak var number2: UITextField!
    @IBOutlet weak var number3: UITextField!

    @IBOutlet weak var result: UILabel!

    @IBOutlet weak var label: UILabel!
    
    var name: String?
    
    let p = Person()
    
    @IBAction func test1ButtonClicked(_ sender: UIButton) {
        test1()
    }
    @IBAction func test2ButtonClicked(_ sender: UIButton) {
        test2()
    }
    @IBAction func test3ButtonClicked(_ sender: UIButton) {
        test3()
    }
    
    func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    func consume1<Element>(tag: String = "", _ observable: Observable<Element>) -> Disposable {
        return observable.subscribe(onNext: { (text) in
            print("\(tag)onNext: \(text)")
        }, onError: { (error) in
            print("\(tag)onError:\(error)")
        }, onCompleted: {
            print("\(tag)onCompleted")
        }) {
            print("\(tag)onDisposed")
        }
    }
    func consume<Element>(tag: String = "", _ observable: Observable<Element>) {
        observable.subscribe(onNext: { (text) in
            print("\(tag)onNext: \(text)")
        }, onError: { (error) in
            print("\(tag)onError:\(error)")
        }, onCompleted: {
            print("\(tag)onCompleted")
        }) {
            print("\(tag)onDisposed")
        }.disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        test_driver()
    }
    
//    func test_finishWithNilWhenDealloc() -> Observable<AnyObject?> {
//        let deallocating = p.rx.deallocating
//
//        return deallocating
//            .map { _ in
//                return Observable.just(nil)
//            }
//            .startWith(self.asObservable())
//            .switchLatest()
//    }

    func test_driver() {
        let ob = number1.rx.text.orEmpty
            .asDriver()
            .flatMap {
                self.dealWithInput($0).asDriver(onErrorJustReturn: "检测到错误事件")
            }
        ob.map { "长度: \($0.count)" }
        .drive(result.rx.text)
        .disposed(by: disposeBag)
        
        ob.drive(label.rx.text)
        .disposed(by: disposeBag)
        
        ob.drive { print("1订阅到 \($0)") }
        .disposed(by: disposeBag)
        
        ob.drive { print("2订阅到 \($0) \(Thread.current)") }
        .disposed(by: disposeBag)
    }
    func dealWithInput(_ text: String) -> Observable<String> {
        .create { ob in
            if text == "1234" {
                ob.onError(RxError.argumentOutOfRange)
            }
            DispatchQueue.global().async {
                ob.onNext("已经输入\(text)")
                ob.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    private func accumate() {
        Observable.combineLatest(number1.rx.text.orEmpty, number2.rx.text.orEmpty, number3.rx.text.orEmpty) { textValue1, textValue2, textValue3 -> Int in
                return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
            }
            .map { $0.description }
            .bind(to: result.rx.text)
            .disposed(by: disposeBag)
    }
}
