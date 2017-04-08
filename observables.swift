import RxSwift

func example(of name: String, action: () -> Void) {
    print("---------- Exemple of: \(name) ----------------")
    action()
}

example(of: "on, two, three") {

    let obs = Observable.of(1,2,3,4)

    let obs2 = Observable.from(["hey", "I am"])

    obs.subscribe(onNext: { (value) in
        print(value)
    }, onError: { (error) in
        print("ERRor: \(error.localizedDescription)")
    }, onCompleted: {
        print("completed")
    }, onDisposed: {
        print("disposed")
    })

    let emptyObs = Observable<Void>.empty()

    emptyObs.subscribe(onNext: { (element) in
        print("empty")
    }, onCompleted: {
        print("empty observable only emit completed events")
    })
}



example(of: "range") {
    let obs = Observable<Int>.range(start: 1, count: 10)

    obs.subscribe(onNext: { (value) in
        let n = Double(value)
        let fib = Int(((pow(1.61803, n) - pow(0.61803, n)) / 2.23606).rounded())
        print(fib)
    })
}

example(of: "dispose") {

    let bag = DisposeBag()

    let obs = Observable<Int>.range(start: 1, count: 10)
    obs.subscribe(onNext: { print($0) }).addDisposableTo(bag)
}

example(of: "Create") {

    let disposeBag = DisposeBag()

    enum MyError: Error {
        case anError
    }

    Observable<String>.create({ (observer) -> Disposable in
        observer.onNext("1")
        observer.onError(MyError.anError)
        observer.onCompleted()
        observer.onNext("?")
        return Disposables.create()
    }).subscribe(onNext: { (str) in
        print(str)
    }, onError: { (error) in
        print("Error: \(error)")
    }, onCompleted: {
        print("Completed")
    }, onDisposed: {
        print("Disposed")
    }).addDisposableTo(disposeBag)
}

example(of: "Never") {

    let bag = DisposeBag()

    let observable = Observable<Any>.never()
    observable.do(onSubscribe: {
        print("DO: Subscribed")
    }).subscribe(onNext: { (val) in
        print(val)
    }, onCompleted: {
        print("Completed!")
    }, onDisposed: {
        print("Disposed")
    }).addDisposableTo(bag)
}

example(of: "defered") {
    let disposeBag = DisposeBag()

    var flip = false

    let factory: Observable<Int> = Observable.deferred({ () -> Observable<Int> in
        flip = !flip

        if flip {
            return Observable.of(1,2,3)
        } else {
            return Observable.of(4,5,6)
        }
    })

    for _ in 1...3 {
        factory.subscribe(onNext: { (val) in
            print(val, terminator: "")
        }).addDisposableTo(disposeBag)
        print()
    }

    factory.debug("factory", trimOutput: false)
        .subscribe({ (val) in
        print(val)
    }).addDisposableTo(disposeBag)

}
