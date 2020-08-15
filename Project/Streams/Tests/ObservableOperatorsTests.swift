import XCTest
@testable import Streams

class ObservableOperatorsTests: XCTestCase {
    func testMerge() {
        let subjects = [Subject<Int>(), Subject<Int>(), Subject<Int>()]
        let observable = Observables.merge(subjects)
        
    }
}
