import XCTest

extension XCTestCase {

    enum Run {
        case run
        case skip
    }
    
    func context(_ run: Run, _ description: String, _ block: () -> Void) {
        if run == .run {
            XCTContext.runActivity(named: description, block: { _ in block() })
        } else if run == .skip {
            XCTFail("skip: " + description)
        }
    }
    
    func context(skip: Bool = false, _ description: String, _ block: () -> Void) {
        guard !skip else { return }
        XCTContext.runActivity(named: description, block: { _ in block() })
    }
    
}
