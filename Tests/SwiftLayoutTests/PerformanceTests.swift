//
//  PerformanceTests.swift
//  
//
//  Created by oozoofrog on 2022/03/18.
//

import XCTest
import SwiftLayout
import SwiftUI

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
    }
    
    func attachSnapshot(named: String, view: UIView) {
        view.setNeedsLayout()
        view.layoutIfNeeded()
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        let image = renderer.image { ctx in
            view.layer.render(in: ctx.cgContext)
        }
        
        XCTContext.runActivity(named: named) { activity in
            let attachment = XCTAttachment(image: image)
            attachment.lifetime = .keepAlways
            activity.add(attachment)
        }
    }
    
    func testDrawXibView() {
        let nib = UINib(nibName: "XibView", bundle: .module)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! XibView
        attachSnapshot(named: "screenshot for XibView", view: view)
    }

    func testDrawSwiftLayoutView() {
        let view = SwiftLayoutView(frame: frame)
        view.sl.updateLayout()
        attachSnapshot(named: "screenshot for SwiftLayoutView", view: view)
    }
    
    func testDrawSwiftLayoutWithoutAssistantsView() {
        let view = SwiftLayoutWithoutAssistantsView(frame: frame)
        view.sl.updateLayout()
        attachSnapshot(named: "screenshot for SwiftLayoutWithoutAssistantsView", view: view)
    }
    
    func testDrawSwiftLayoutWithoutIdentifyingView() {
        let view = SwiftLayoutWithoutIdentifyingView(frame: frame)
        view.sl.updateLayout()
        attachSnapshot(named: "screenshot for SwiftLayoutWithoutIdentifyingView", view: view)
    }
    
    func testDrawNativeApi() {
        let view = NativeApiView(frame: frame)
        view.loadView()
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
    
    func testPerformance1LayoutableWithoutAssistants() throws {
        self.measure(metrics: [XCTCPUMetric()]) {
            startMeasuring()
            let view = SwiftLayoutWithoutAssistantsView(frame: frame)
            view.sl.updateLayout()
            stopMeasuring()
        }
    }
    
    func testPerformance1LayoutableWithoutIdentifying() throws {
        self.measure(metrics: [XCTCPUMetric()]) {
            startMeasuring()
            let view = SwiftLayoutWithoutIdentifyingView(frame: frame)
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
    
    func testPerformance2LayoutableWithoutIdentifyingAndLayout() throws {
        self.measure(metrics: [XCTCPUMetric()]) {
            let view = SwiftLayoutWithoutIdentifyingView(frame: frame)
            startMeasuring()
            view.sl.updateLayout()
            view.setNeedsLayout()
            view.layoutIfNeeded()
            stopMeasuring()
        }
    }
    
    func testPerformance2LayoutableWithoutAssistantsAndLayout() throws {
        self.measure(metrics: [XCTCPUMetric()]) {
            let view = SwiftLayoutWithoutAssistantsView(frame: frame)
            startMeasuring()
            view.sl.updateLayout()
            view.setNeedsLayout()
            view.layoutIfNeeded()
            stopMeasuring()
        }
    }
}
