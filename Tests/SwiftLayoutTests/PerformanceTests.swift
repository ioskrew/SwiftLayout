//
//  PerformanceTests.swift
//  
//
//  Created by oozoofrog on 2022/03/18.
//

import XCTest
import SwiftLayout

class PerformanceTests: XCTestCase {
    
    let frame = CGRect(origin: .zero, size: .init(width: 414.0, height: 896.0))

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        Bundle.module.unload()
    }
    
//    func testDrawXibView() {
//        let nib = UINib(nibName: "XibView", bundle: .module)
//        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! XibView
//        view.frame = .init(origin: .zero, size: .init(width: 375, height: 667))
//        attachSnapshot(named: "screenshot for XibView", view: view)
//    }
//
//    func testDrawSwiftLayoutView() {
//        let view = SwiftLayoutView(frame: .init(x: 0, y: 0, width: 375, height: 667))
//        attachSnapshot(named: "screenshot for SwiftLayoutView", view: view)
//    }
//
//    func testDrawNativeApi() {
//        let view = NativeApiView(frame: .init(x: 0, y: 0, width: 375, height: 667))
//        attachSnapshot(named: "screenshot for NativeApiView", view: view)
//    }
    
    func testPerformanceInterfaceBuilder() throws {
        let metrics: [XCTMetric] = [XCTCPUMetric(), XCTMemoryMetric()]
        self.measure(metrics: metrics) {
            let nib = UINib(nibName: "XibView", bundle: .module)
            let view = nib.instantiate(withOwner: nil, options: nil)[0] as! XibView
            view.frame = frame
        }
    }
    
    func testPerformanceNativeApi() throws {
        let metrics: [XCTMetric] = [XCTCPUMetric(), XCTMemoryMetric()]
        self.measure(metrics: metrics) {
            _ = NativeApiView(frame: frame)
        }
    }
    
    func testPerformanceLayoutable() throws {
        let metrics: [XCTMetric] = [XCTCPUMetric(), XCTMemoryMetric()]
        self.measure(metrics: metrics) {
            _ = SwiftLayoutView(frame: frame)
        }
    }
    
    func testPerformanceInterfaceBuilderAndLayout() throws {
        let metrics: [XCTMetric] = [XCTCPUMetric(), XCTMemoryMetric()]
        self.measure(metrics: metrics) {
            let nib = UINib(nibName: "XibView", bundle: .module)
            let view = nib.instantiate(withOwner: nil, options: nil)[0] as! XibView
            view.frame = frame
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
    
    func testPerformanceNativeApiAndLayout() throws {
        let metrics: [XCTMetric] = [XCTCPUMetric(), XCTMemoryMetric()]
        self.measure(metrics: metrics) {
            let view = NativeApiView(frame: frame)
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
    
    func testPerformanceLayoutableAndLayout() throws {
        let metrics: [XCTMetric] = [XCTCPUMetric(), XCTMemoryMetric()]
        self.measure(metrics: metrics) {
            let view = SwiftLayoutView(frame: frame)
            view.setNeedsLayout()
            view.layoutIfNeeded()
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
