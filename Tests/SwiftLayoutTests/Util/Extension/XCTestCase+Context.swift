import XCTest

extension XCTestCase {

    func context(_ description: String, _ block: () -> Void) {
        try? XCTContext.runActivity(named: description, block: { _ in
            try setUpWithError()
            setUp()
            block()
            tearDown()
            try tearDownWithError()
        })
    }

    func contextContinuous(_ description: String, _ block: () throws -> Void) rethrows {
        try XCTContext.runActivity(named: description, block: { _ in try block() })
    }

    func contextInActivity(_ description: String, _ block: (XCTActivity) throws -> Void) rethrows {
        try XCTContext.runActivity(named: description, block: block)
    }

}
