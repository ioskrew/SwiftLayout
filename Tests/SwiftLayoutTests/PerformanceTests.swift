//
//  PerformanceTests.swift
//  
//
//  Created by oozoofrog on 2022/03/18.
//

import XCTest
import SwiftLayout

class PerformanceTests: XCTestCase {
  
    override class var defaultPerformanceMetrics: [XCTPerformanceMetric] { [.wallClockTime] }
    
    override class var defaultMeasureOptions: XCTMeasureOptions {
        let options = XCTMeasureOptions()
        options.invocationOptions = [.manuallyStart, .manuallyStop]
        options.iterationCount = 20
        return options
    }
    
    let frame = CGRect(origin: .zero, size: .init(width: 414.0, height: 896.0))

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        Bundle.module.unload()
    }
    
    func testDrawXibView() {
        let nib = UINib(nibName: "XibView", bundle: .module)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! XibView
        attachSnapshot(named: "screenshot for XibView", view: view)
    }

    func testDrawSwiftLayoutView() {
        let view = SwiftLayoutView(frame: .init(x: 0, y: 0, width: 375, height: 667))
        attachSnapshot(named: "screenshot for SwiftLayoutView", view: view)
    }

    func testDrawNativeApi() {
        let view = NativeApiView(frame: .init(x: 0, y: 0, width: 375, height: 667))
        attachSnapshot(named: "screenshot for NativeApiView", view: view)
    }
    
    func testPerformance1InterfaceBuilder() throws {
        self.measure(metrics: [XCTCPUMetric()]) {
            startMeasuring()
            let nib = UINib(nibName: "XibView", bundle: .module)
            let view = nib.instantiate(withOwner: nil, options: nil)[0] as! XibView
            view.frame = frame
            stopMeasuring()
        }
    }
    
    func testPerformance1NativeApi() throws {
        self.measure(metrics: [XCTCPUMetric()]) {
            startMeasuring()
            let view = NativeApiView(frame: frame)
            view.loadView()
            stopMeasuring()
        }
    }
    
    func testPerformance1Layoutable() throws {
        self.measure(metrics: [XCTCPUMetric()]) {
            startMeasuring()
            let view = SwiftLayoutView(frame: frame)
            view.sl.updateLayout()
            stopMeasuring()
        }
    }
    
    func testPerformance2InterfaceBuilderAndLayout() throws {
        self.measure(metrics: [XCTCPUMetric()]) {
            startMeasuring()
            let nib = UINib(nibName: "XibView", bundle: .module)
            let view = nib.instantiate(withOwner: nil, options: nil)[0] as! XibView
            view.frame = frame
            view.setNeedsLayout()
            view.layoutIfNeeded()
            stopMeasuring()
        }
    }
    
    func testPerformance2NativeApiAndLayout() throws {
        self.measure(metrics: [XCTCPUMetric()]) {
            let view = NativeApiView(frame: frame)
            startMeasuring()
            view.loadView()
            view.setNeedsLayout()
            view.layoutIfNeeded()
            stopMeasuring()
        }
    }
    
    func testPerformance2LayoutableAndLayout() throws {
        self.measure(metrics: [XCTCPUMetric()]) {
            let view = SwiftLayoutView(frame: frame)
            startMeasuring()
            view.sl.updateLayout()
            view.setNeedsLayout()
            view.layoutIfNeeded()
            stopMeasuring()
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
