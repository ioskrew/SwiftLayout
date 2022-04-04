import XCTest

extension XCTestCase {

    func context(_ description: String, _ block: () -> Void) {
        try! XCTContext.runActivity(named: description, block: { _ in
            try setUpWithError()
            setUp()
            block()
            tearDown()
            try tearDownWithError()
        })
    }
    
    func contextContinuous(_ description: String, _ block: () throws -> Void) {
        try! XCTContext.runActivity(named: description, block: { _ in try block() })
    }
    
    func contextInActivity(_ description: String, _ block: (XCTActivity) throws -> Void) {
        try! XCTContext.runActivity(named: description, block: block)
    }
    
    func assertConstrints(_ constraints1: [NSLayoutConstraint], _ constraints2: [NSLayoutConstraint], sorted: Bool = true) {
        XCTAssertEqual(constraints1.count, constraints2.count)
        
        func customHash(_ constrint: NSLayoutConstraint) -> Int {
            var hasher = Hasher()
            hasher.combine(constrint.firstItem as? NSObject)
            hasher.combine(constrint.firstAttribute)
            hasher.combine(constrint.secondItem as? NSObject)
            hasher.combine(constrint.secondAttribute)
            hasher.combine(constrint.relation)
            hasher.combine(constrint.constant)
            hasher.combine(constrint.multiplier)
            hasher.combine(constrint.priority)
            return hasher.finalize()
        }
        
        zip(
            sorted ? constraints1.sorted { customHash($0) < customHash($1) } : constraints1,
            sorted ? constraints2.sorted { customHash($0) < customHash($1) } : constraints2
        ).forEach {
            XCTAssertTrue($0.0.firstItem === $0.1.firstItem)
            XCTAssertEqual($0.0.firstAttribute, $0.1.firstAttribute)
            XCTAssertEqual($0.0.relation, $0.1.relation)
            XCTAssertTrue($0.0.secondItem === $0.1.secondItem)
            XCTAssertEqual($0.0.secondAttribute, $0.1.secondAttribute)
            XCTAssertEqual($0.0.constant, $0.1.constant)
            XCTAssertEqual($0.0.multiplier, $0.1.multiplier)
        }
    }
}
