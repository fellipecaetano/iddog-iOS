import XCTest
@testable import iddog

class EmailValidationTests: XCTestCase {
    func testValidationResult() {
        XCTAssertEqual(EmailValidation.validate(email: "fellipe.caetano4@gmail.com"), .valid)
        XCTAssertEqual(EmailValidation.validate(email: "fellipecaetano4@gmail.com"), .valid)
        XCTAssertEqual(EmailValidation.validate(email: ""), .blank)
        XCTAssertEqual(EmailValidation.validate(email: "    "), .blank)
        XCTAssertEqual(EmailValidation.validate(email: "fellipecaetano@gmail."), .invalid)
        XCTAssertEqual(EmailValidation.validate(email: "fellipecaetanogmail.com"), .invalid)
        XCTAssertEqual(EmailValidation.validate(email: "fellipecaetano@gmailcom"), .invalid)
        XCTAssertEqual(EmailValidation.validate(email: "@gmail.com"), .invalid)
        XCTAssertEqual(EmailValidation.validate(email: "fellipe.caetano@gmail.gov.com.br"), .valid)
    }
}
