import RxSwift

enum MyError: Error {
    case anError
}

func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, event.element ?? event.error ?? event)
}

func example(of name: String, action: () -> Void) {
    print("---------- Exemple of: \(name) ----------------")
    action()
}

example(of: "ignoreElements") {

    let strikes = PublishSubject<String>()
    let bag = DisposeBag()

    strikes
        .ignoreElements()
        .subscribe(onCompleted: { (val) in
            print("You are out!")
        }).addDisposableTo(bag)

    strikes.onNext("X")
    strikes.onNext("X")
    strikes.onNext("X")

    strikes.onCompleted()

}

example(of: "elementAt") {

    let strikes = PublishSubject<String>()
    let bag = DisposeBag()

    strikes
        .elementAt(1)
        .subscribe(onNext: { (s) in
            print("Element \(s)")
        }, onCompleted: { (val) in
            print("You are out!")
        }).addDisposableTo(bag)

    strikes.onNext("X")
    strikes.onNext("Y")
    strikes.onNext("Z")

    strikes.onCompleted()

}

example(of: "filter") {

    let bag = DisposeBag()

    Observable.of(1,2,3,4,5,6,7)
        .filter({$0 % 2 == 0})
        .subscribe(onNext: { print("Value \($0)") })
        .addDisposableTo(bag)

}


example(of: "skip") {
    let disposeBag = DisposeBag()
    // 1
    Observable.of("A", "B", "C", "D", "E", "F")
        // 2
        .skip(3)
        .subscribe(onNext: {
            print($0) })
        .addDisposableTo(disposeBag)
}

example(of: "skipWhile") {
    let disposeBag = DisposeBag()
    // 1
    Observable.of(2, 2, 3, 4, 4)
        // 2
        .skipWhile { i in
            i % 2 == 0
        }
        .subscribe(onNext: {
            print($0)
        })
        .addDisposableTo(disposeBag)
}
