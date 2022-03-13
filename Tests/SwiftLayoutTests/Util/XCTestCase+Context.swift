import XCTest

extension XCTestCase {

    func context(_ description: String, _ block: () -> Void) {
        print("[TEST] start \(description)")
        try! XCTContext.runActivity(named: description, block: { _ in
            try setUpWithError()
            setUp()
            block()
            tearDown()
            try tearDownWithError()
        })
    }
    
}
