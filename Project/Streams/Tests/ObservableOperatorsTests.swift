import XCTest
@testable import Streams

class ObservableOperatorsTests: XCTestCase {
    func testMerge() {
        let subjects = [Subject<Int>(), Subject<Int>(), Subject<Int>()]
        let observable = Observables.merge(subjects)
        let observer = TestObserver<Int>.observing(observable)

        XCTAssertEqual(observer.values, [])

        subjects[1].emit(2)
        XCTAssertEqual(observer.values, [2])

        subjects[0].emit(-2)
        XCTAssertEqual(observer.values, [2, -2])

        subjects[2].emit(3)
        XCTAssertEqual(observer.values, [2, -2, 3])
        
        subjects[0].emit(0)
        XCTAssertEqual(observer.values, [2, -2, 3, 0])
        
        subjects[1].emit(-1)
        XCTAssertEqual(observer.values, [2, -2, 3, 0, -1])
    }
    
    func testDistinctUntilChanged() {
        let subject = Subject<String>()
        let observable = subject.distinctUntilChanged()
        let observer = TestObserver<String>.observing(observable)
        
        XCTAssertEqual(observer.values, [])
        
        subject.emit("a")
        XCTAssertEqual(observer.values, ["a"])
        
        subject.emit("b")
        XCTAssertEqual(observer.values, ["a", "b"])
        
        subject.emit("b")
        XCTAssertEqual(observer.values, ["a", "b"])
        
        subject.emit("abc")
        XCTAssertEqual(observer.values, ["a", "b", "abc"])

        subject.emit("abc")
        XCTAssertEqual(observer.values, ["a", "b", "abc"])
    }
}
