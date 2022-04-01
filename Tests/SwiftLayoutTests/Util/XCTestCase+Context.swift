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
    
    func assertView(_ view: UIView, superview: UIView?, subviews: [UIView]) {
        XCTAssertEqual(view.superview, superview)
        XCTAssertEqual(view.subviews.count, subviews.count)
        XCTAssertEqual(Set(view.subviews), Set(subviews))
    }
}
