@testable import Authentication
import XCTest

class KeychainAccessTests: XCTestCase {
    private let keychain = KeychainAccess(server: "www.test-server.com")

    override func tearDown() {
        super.tearDown()
        try? keychain.delete()
    }

    func testInitialState() {
        XCTAssertThrowsError(try keychain.get()) { error in
            XCTAssertEqual(error as? KeychainAccess.Error, .noPassword)
        }
    }

    func testCreation() throws {
        let createdCredentials = KeychainAccess.Credentials(account: "account", password: "password")
        try keychain.put(credentials: createdCredentials)
        let readCredentials = try keychain.get()
        XCTAssertEqual(readCredentials, createdCredentials)
    }

    func testRemoval() {
        XCTAssertNoThrow(try keychain.put(credentials: .init(account: "account", password: "password")))
        XCTAssertNoThrow(try keychain.delete())

        XCTAssertThrowsError(try keychain.get()) { error in
            XCTAssertEqual(error as? KeychainAccess.Error, .noPassword)
        }
    }

    func testUpdating() throws {
        let credentials1 = KeychainAccess.Credentials(account: "account", password: "password")
        let credentials2 = KeychainAccess.Credentials(account: "anotherAccount", password: "anotherPassword")

        XCTAssertNoThrow(try keychain.put(credentials: credentials1))
        XCTAssertNoThrow(try keychain.put(credentials: credentials2))

        let readCredentials = try keychain.get()
        XCTAssertEqual(readCredentials, credentials2)
    }
}
