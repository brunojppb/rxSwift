import RxSwift

func example(of name: String, action: () -> Void) {
    print("---------- Exemple of: \(name) ----------------")
    action()
}

example(of: "PublishSubject") {

    let bag = DisposeBag()

    let subject = PublishSubject<String>()
    subject.onNext("Is anyone listening?")

    // This guy came too late to the party.
    // This subject only emits events for current subscribers
    let subscriptionOne = subject.subscribe(onNext: { (val) in
        print("1) \(val)")
    }, onDisposed: {
        print("1) Bye!")
    })
    // now we see
    subject.on(.next("Hey there"))
    // syntax sugar
    subject.onNext("Now with shortcut")

    let subscriptionTwo = subject.subscribe({ (event) in
        print("2)", event.element ?? event)
    })

    subject.onNext("3")

    // subscripber 1 is going home
    subscriptionOne.dispose()

    subject.onNext("4")

    subject.onCompleted()

    subject.onNext("5")

    subscriptionTwo.dispose()

    // The last subscriber will get the .completed event
    // even after subscribing after the observable terminated
    subject.subscribe({ (event) in
        print("3)", event.element ?? event)
    }).addDisposableTo(bag)

    subject.onNext("?")

}

enum MyError: Error {
    case anError
}

func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, event.element ?? event.error ?? event)
}

example(of: "BehaviourSubject") {
    // Bahviour subjects get an initial value
    let subject = BehaviorSubject(value: "Initial value")
    let bag = DisposeBag()

    // Bahavior subjects always emit the last event
    // Even if you subscribe later
    subject.onNext("X")


    subject.subscribe({ (event) in
        print(label: "1)", event: event)
    }).addDisposableTo(bag)

    subject.onError(MyError.anError)

    subject.subscribe({ (e) in
        print(label: "2)", event: e)
    }).addDisposableTo(bag)
}

example(of: "ReplaySubject") {

    let subject = ReplaySubject<String>.create(bufferSize: 2)
    let bag = DisposeBag()

    subject.onNext("1")
    subject.onNext("2")
    subject.onNext("3")

    subject.subscribe({ (e) in
        print(label: "John:", event: e)
    }).addDisposableTo(bag)


    subject.subscribe({ (e) in
        print(label: "Leo:", event: e)
    }).addDisposableTo(bag)

    subject.onNext("4")

    subject.onError(MyError.anError)
    subject.dispose()

    subject.subscribe({ (e) in
        print(label: "CJ:", event: e)
    }).addDisposableTo(bag)
}

example(of: "Variable") {
    var variable = Variable("Initial value")
    let bag = DisposeBag()

    variable.value = "New init value"

    variable.asObservable()
        .subscribe({ print(label: "1)", event: $0) })
    .addDisposableTo(bag)

    variable.value = "1"

    variable.asObservable()
        .subscribe({ print(label: "2)", event: $0) })
        .addDisposableTo(bag)

    variable.value = "2"
}
