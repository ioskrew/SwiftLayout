import XCTest

extension XCTestCase {

    func context(_ description: String, _ block: () -> Void) {
        XCTContext.runActivity(named: description, block: { _ in block() })
    }
    
}
