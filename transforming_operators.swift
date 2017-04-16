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

struct Student {
    var score: Variable<Int>
}

example(of: "toArray") {

    let bag = DisposeBag()

    Observable.of(1,2,3,4,5)
        .toArray()
        .subscribe(onNext: { (arr) in
            print("Value: \(arr)")
        })
        .addDisposableTo(bag)

}

example(of: "map") {

    let bag = DisposeBag()
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut

    Observable.of(155,425,1050)
        .map {
            formatter.string(from: $0) ?? ""
        }
        .subscribe(onNext: { (arr) in
            print("Value: \(arr)")
        })
        .addDisposableTo(bag)

}

example(of: "mapWithIndex") {
    let disposeBag = DisposeBag()
    // 1
    Observable.of(1, 2, 3, 4, 5, 6)
        // 2
        .mapWithIndex { integer, index in
            index > 2 ? integer * 2 : integer
        }
        .subscribe(onNext: {
            print($0)
        })
        .addDisposableTo(disposeBag)
}

example(of: "flatMap") {
    let bag = DisposeBag()

    let bruno = Student(score: Variable(80))
    let john = Student(score: Variable(90))

    let student = PublishSubject<Student>()

    student.asObservable()
        .flatMap { $0.score.asObservable() }
        .subscribe(onNext: { (score) in
            print("Score: \(score)")
        })
        .addDisposableTo(bag)

    student.onNext(bruno)
    bruno.score.value = 100
    student.onNext(john)
    john.score.value = 85
    bruno.score.value = 76

}

example(of: "flatMapLatest") {
    let bag = DisposeBag()

    let bruno = Student(score: Variable(80))
    let john = Student(score: Variable(90))

    let student = PublishSubject<Student>()

    student.asObservable()
        .flatMapLatest { $0.score.asObservable() }
        .subscribe(onNext: { (score) in
            print("Score: \(score)")
        })
        .addDisposableTo(bag)

    student.onNext(bruno)
    bruno.score.value = 100
    student.onNext(john)
    john.score.value = 85
    bruno.score.value = 767

}
