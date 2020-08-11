import XCTest
@testable import Streams

final class SubjectTests: XCTestCase {
    func testSubscribe() {
        let subject = Subject<Int>()
        var receivedValues = [Int]()
        
        subject.subscribe { value in
            receivedValues.append(value)
        }
        
        subject.emit(1)
        XCTAssertEqual(receivedValues, [1])
        
        subject.emit(-1)
        XCTAssertEqual(receivedValues, [1, -1])
        
        subject.emit(3)
        XCTAssertEqual(receivedValues, [1, -1, 3])
    }
}
