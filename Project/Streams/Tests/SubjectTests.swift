import XCTest

@testable import Streams

final class SubjectTests: XCTestCase {
    func testSubscribeThenEmit() {
        let subject = Subject<Int>()
        var receivedValues = [Int]()

        _ = subject.subscribe { value in
            receivedValues.append(value)
        }

        subject.emit(1)
        XCTAssertEqual(receivedValues, [1])

        subject.emit(-1)
        XCTAssertEqual(receivedValues, [1, -1])

        subject.emit(3)
        XCTAssertEqual(receivedValues, [1, -1, 3])
    }

    func testSubscriptionDisposal() {
        let subject = Subject<String>()
        var receivedValues = [String]()

        let disposable = subject.subscribe { value in
            receivedValues.append(value)
        }

        subject.emit("a")
        XCTAssertEqual(receivedValues, ["a"])

        subject.emit("b")
        XCTAssertEqual(receivedValues, ["a", "b"])

        disposable.dispose()

        subject.emit("c")
        XCTAssertEqual(receivedValues, ["a", "b"])
    }
}
