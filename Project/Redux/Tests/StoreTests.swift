import Streams
import XCTest

@testable import Redux

class StoreTests: XCTestCase {
    private var store: Store<Int, StoreTestsAction, Void>!

    override func setUp() {
        store = Store<Int, StoreTestsAction, Void>(
            initialState: 0,
            reducer: Reducer { state, action, _ in
                switch action {
                case .increment:
                    state = state + 1
                case .decrement:
                    state = state - 1
                case let .incrementDeferred(expectation):
                    let effect: Effect<StoreTestsAction> = Effect<StoreTestsAction>.run {
                        onComplete in
                        expectation.fulfill()
                        onComplete(.increment)
                        return Disposable.none
                    }

                    return effect.timed(interval: 0.5, repeats: false)
                }

                return Effect.empty
            },
            environment: ()
        )
    }

    func testReducer() {
        var receivedValues = [Int]()

        let disposable = store.subscribe { value in
            receivedValues.append(value)
        }

        XCTAssertEqual(receivedValues, [0])

        store.emit(.increment)
        XCTAssertEqual(receivedValues, [0, 1])

        store.emit(.increment)
        XCTAssertEqual(receivedValues, [0, 1, 2])

        store.emit(.decrement)
        XCTAssertEqual(receivedValues, [0, 1, 2, 1])

        disposable.dispose()
        store.emit(.increment)
        XCTAssertEqual(receivedValues, [0, 1, 2, 1])
    }

    func testEffects() {
        var receivedValues = [Int]()

        _ = store.subscribe { value in
            receivedValues.append(value)
        }

        let expectation = XCTestExpectation(description: "Deferred reducer effect")
        store.emit(.incrementDeferred(expectation: expectation))

        XCTAssertEqual(receivedValues, [0])
        wait(for: [expectation], timeout: 0.6)
        XCTAssertEqual(receivedValues, [0, 1])
    }
}

private enum StoreTestsAction {
    case increment
    case decrement
    case incrementDeferred(expectation: XCTestExpectation)
}
