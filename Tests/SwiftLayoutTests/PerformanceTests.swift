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
        Bundle.module.unload()
    }
    
    func testDrawXibView() {
        let nib = UINib(nibName: "XibView", bundle: .module)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! XibView
        attachSnapshot(named: "screenshot for XibView", view: view)
    }

    func testDrawSwiftLayoutView() {
        let view = SwiftLayoutView(frame: frame)
        attachSnapshot(named: "screenshot for SwiftLayoutView", view: view)
    }

    func testDrawNativeApi() {
        let view = NativeApiView(frame: frame)
        attachSnapshot(named: "screenshot for NativeApiView", view: view)
    }

    @available(iOS 15.0, *)
    func testDrawSwiftUI() {
        let view = _UIHostingView(rootView: SwiftUIView())
        view.frame = frame
        attachSnapshot(named: "screenshot for SwiftUIView", view: view)
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
    
    @available(iOS 15.0, *)
    func testPerformance1SwiftUI() throws {
        let superview = UIView(frame: frame)
        self.measure(metrics: [XCTCPUMetric()]) {
            startMeasuring()
            let view = _UIHostingView(rootView: SwiftUIView())
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.frame = frame
            superview.addSubview(view)
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
    @available(iOS 15.0, *)
    func testPerformance2SwiftUIAndLayout() throws {
        let superview = UIView(frame: frame)
        self.measure(metrics: [XCTCPUMetric()]) {
            startMeasuring()
            let view = _UIHostingView(rootView: SwiftUIView())
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.frame = frame
            superview.addSubview(view)
            view.setNeedsLayout()
            view.layoutIfNeeded()
            stopMeasuring()
        }
    }
    
    func attachSnapshot(named: String, view: UIView) {
        let superview = UIView(frame: view.bounds)
        view.translatesAutoresizingMaskIntoConstraints = true
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        superview.addSubview(view)
        XCTContext.runActivity(named: named) { activity in
            superview.setNeedsLayout()
            superview.layoutIfNeeded()
            superview.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
            let image = renderer.image { context in
                superview.layer.render(in: context.cgContext)
            }
            let attachment = XCTAttachment(image: image)
            attachment.lifetime = .keepAlways
            activity.add(attachment)
        }
    }
    
}
