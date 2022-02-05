//
//  LayoutTests.swift
//  
//
//  Created by oozoofrog on 2022/02/05.
//

import Foundation
import XCTest

protocol _Layout {
    func attachSuperview(_ superview: UIView?)
    func attachSuperview()
    func detachFromSuperview(_ superview: UIView?)
    func detachFromSuperview()
    
    var hashable: AnyHashable { get }
}

extension _Layout {
    func attachSuperview() {
        attachSuperview(nil)
    }
    func detachFromSuperview() {
        detachFromSuperview(nil)
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
    func detachFromSuperview(_ superview: UIView?) {
        for layout in layouts {
            layout.detachFromSuperview(superview)
        }
    }
    
    var hashable: AnyHashable {
        AnyHashable(layouts.map(\.hashable))
    }
}

protocol _LayoutViewContainable: _LayoutContainable {
    var view: UIView { get }
}

extension _LayoutViewContainable {
    func attachSuperview(_ superview: UIView?) {
        superview?.addSubview(self.view)
        for layout in layouts {
            layout.attachSuperview(self.view)
        }
    }
    func detachFromSuperview(_ superview: UIView?) {
        if self.view.superview == superview {
            self.view.removeFromSuperview()
        }
        for layout in layouts {
            layout.detachFromSuperview(self.view)
        }
    }
    
    var hashable: AnyHashable {
        AnyHashable(layouts.map(\.hashable) + [self.view.hashable])
    }
}

extension _Layout where Self: _LayoutContainable, Self: Collection, Element == _Layout {
    var layouts: [_Layout] {
        map({ $0 as _Layout })
    }
}

extension Array: _Layout where Self.Element == _Layout {}
extension Array: _LayoutContainable where Self.Element == _Layout {}

struct _OptionalLayout<L>: _Layout where L: _Layout {
    let layout: L?
    
    func attachSuperview(_ superview: UIView?) {
        layout?.attachSuperview(superview)
    }
    
    func detachFromSuperview(_ superview: UIView?) {
        layout?.detachFromSuperview(superview)
    }
    
    var hashable: AnyHashable {
        AnyHashable(layout?.hashable)
    }
}


struct _ViewLayout<L>: _LayoutViewContainable where L: _LayoutContainable {
    var view: UIView
    var layoutable: L
    
    var layouts: [_Layout] {
        layoutable.layouts
    }
}

@resultBuilder
struct _LayoutBuilder {
    static func buildBlock(_ components: _Layout...) -> [_Layout] {
        components
    }
    static func buildEither(first component: [_Layout]) -> [_Layout] {
        component
    }
    static func buildEither(second component: [_Layout]) -> [_Layout] {
        component
    }
    static func buildOptional(_ component: [_Layout]?) -> [_Layout] {
        component ?? []
    }
}

extension _Layout where Self: UIView {
    
    func callAsFunction<L>(@_LayoutBuilder _ build: () -> L) -> _ViewLayout<L> where L: _Layout {
        _ViewLayout(view: self, layoutable: build())
    }
    
    func attachSuperview(_ superview: UIView?) {
        superview?.addSubview(self)
    }
    
    func detachFromSuperview(_ superview: UIView?) {
        guard self.superview == superview else { return }
        removeFromSuperview()
    }
    
    var hashable: AnyHashable {
        AnyHashable(self)
    }
}

extension UIView: _Layout {}


final class LayoutTests: XCTestCase {

    var root = UIView()
    var child = UIView()
    var grandChild1 = UIView()
    var grandChild2 = UIView()
    
    override func setUp() {
        root = UIView()
        child = UIView()
        grandChild1 = UIView()
        grandChild2 = UIView()
    }
    
    override func tearDown() {
        
    }
    
    func testLayoutTree() {
        let layout: some _Layout = root {
            child {
                grandChild1
                grandChild2
            }
        }
        
        print(layout)
        layout.attachSuperview()
        
        XCTAssertEqual(grandChild1.superview, child)
        XCTAssertEqual(grandChild2.superview, child)
        XCTAssertEqual(child.superview, root)
        
        layout.detachFromSuperview()
        XCTAssertNil(grandChild1.superview)
        XCTAssertNil(grandChild2.superview)
        XCTAssertNil(child.superview)
    }
    
}
