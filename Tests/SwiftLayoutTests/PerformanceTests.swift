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
    
    func testDrawXibView() {
        let nib = UINib(nibName: "XibView", bundle: .module)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! XibView
        view.frame = .init(origin: .zero, size: .init(width: 375, height: 667))
        attachSnapshot(named: "screenshot for XibView", view: view)
    }
    
    func testDrawSwiftLayoutView() {
        let view = SwiftLayoutView(frame: .init(x: 0, y: 0, width: 375, height: 667))
        attachSnapshot(named: "screenshot for SwiftLayoutView", view: view)
    }
    
    func testPerformanceInterfaceBuilder() throws {
        let metrics: [XCTMetric] = [XCTCPUMetric(), XCTMemoryMetric()]
        self.measure(metrics: metrics) {
            let nib = UINib(nibName: "XibView", bundle: .module)
            _ = nib.instantiate(withOwner: nil, options: nil)[0] as! XibView
        }
    }
    
    func testPerformanceLayoutable() throws {
        let metrics: [XCTMetric] = [XCTCPUMetric(), XCTMemoryMetric()]

        self.measure(metrics: metrics) {
            _ = SwiftLayoutView(frame: .init(x: 0, y: 0, width: 375, height: 667))
        }
    }
    
    func attachSnapshot(named: String, view: UIView) {
        XCTContext.runActivity(named: named) { activity in
            let rect = view.bounds
            view.setNeedsLayout()
            view.layoutIfNeeded()
            view.drawHierarchy(in: rect, afterScreenUpdates: true)
            let renderer = UIGraphicsImageRenderer(size: rect.size)
            let image = renderer.image { context in
                view.layer.render(in: context.cgContext)
            }
            let attachment = XCTAttachment(image: image)
            attachment.lifetime = .keepAlways
            activity.add(attachment)
        }
    }
    
}
#endif
