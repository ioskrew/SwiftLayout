//
//  LayoutTests.swift
//  
//
//  Created by oozoofrog on 2022/02/05.
//

import Foundation
import XCTest

final class LayoutTests: XCTestCase {

    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    func testLayoutTree() {
        
    }
    
}

protocol _Layout {
    func active()
    func attachSuperview(_ superview: UIView?)
    func attachSuperview()
}

extension _Layout {
    func active() {
        attachSuperview()
    }
    func attachSuperview() {
        attachSuperview(nil)
    }
}

protocol _LayoutContainable: _Layout {
    var layouts: [_Layout] { get }
}

extension _LayoutContainable {
    func attachSuperview(_ superview: UIView?) {
        for layout in layouts {
            layout.attachSuperview(superview)
        }
    }
}

protocol _LayoutViewContainable: _LayoutContainable {
    var view: UIView { get }
}

extension _LayoutViewContainable {
    func attachSuperview(_ superview: UIView?) {
        superview?.addSubview(view)
    }
}

struct LayoutViewContainer: _LayoutViewContainable {
    var view: UIView
    var layouts: [_Layout]
}

extension Array where Element: _LayoutContainable {
    var layouts: [_Layout] {
        self
    }
}

