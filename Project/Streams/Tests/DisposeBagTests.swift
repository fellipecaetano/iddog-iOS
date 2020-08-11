import XCTest

@testable import Streams

class DisposeBagTests: XCTestCase {
    func testDisposalOnDeinit() {
        var bag: DisposeBag! = DisposeBag()
        var disposeNotifications = [String]()

        let disposable1 = Disposable {
            disposeNotifications.append("disposable1")
        }
        disposable1.disposed(by: bag)

        let disposable2 = Disposable {
            disposeNotifications.append("disposable2")
        }
        disposable2.disposed(by: bag)

        XCTAssertEqual(disposeNotifications, [])
        bag = nil
        XCTAssertEqual(disposeNotifications, ["disposable1", "disposable2"])
    }
}
