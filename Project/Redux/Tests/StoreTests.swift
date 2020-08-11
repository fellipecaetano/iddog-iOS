import XCTest

@testable import Redux

class StoreTests: XCTestCase {
    private let store = Store<Int, String>(initialState: 0, reducer: Reducer { state, action in
        switch action {
        case "inc":
            state = state + 1
        case "dec":
            state = state - 1
        default:
            break
        }
    })
    
    func testReducer() {
        var receivedValues = [Int]()
        
        let disposable = store.subscribe { value in
            receivedValues.append(value)
        }
        
        XCTAssertEqual(receivedValues, [0])
        
        store.emit("inc")
        XCTAssertEqual(receivedValues, [0, 1])
        
        store.emit("dec")
        XCTAssertEqual(receivedValues, [0, 1, 0])
        
        store.emit("dec")
        XCTAssertEqual(receivedValues, [0, 1, 0, -1])
        
        store.emit("abc")
        XCTAssertEqual(receivedValues, [0, 1, 0, -1, -1])
        
        disposable.dispose()
        store.emit("inc")
        XCTAssertEqual(receivedValues, [0, 1, 0, -1, -1])
    }
}
