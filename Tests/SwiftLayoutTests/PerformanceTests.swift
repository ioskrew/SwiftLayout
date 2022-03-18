//
//  PerformanceTests.swift
//  
//
//  Created by oozoofrog on 2022/03/18.
//

#if canImport(UIKit)
import XCTest
import SwiftLayout
import UIKit

class PerformanceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPerformanceInterfaceBuilder() throws {
        let metrics: [XCTMetric] = [XCTCPUMetric(), XCTMemoryMetric(), XCTClockMetric(), XCTStorageMetric()]
        self.measure(metrics: metrics) {
            let nib = UINib(nibName: "TestView", bundle: .module)
            let view = nib.instantiate(withOwner: nil, options: nil)[0] as! TestView
            view.frame = .init(x: 0, y: 0, width: 375, height: 667)
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
    
    func testPerformanceLayoutable() throws {
        let metrics: [XCTMetric] = [XCTCPUMetric(), XCTMemoryMetric(), XCTClockMetric(), XCTStorageMetric()]
        self.measure(metrics: metrics) {
            let view = TestView2(frame: .init(x: 0, y: 0, width: 375, height: 667))
            view.sl.updateLayout()
        }
    }

}
#endif
