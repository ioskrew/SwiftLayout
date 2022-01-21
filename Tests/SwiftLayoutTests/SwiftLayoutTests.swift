import XCTest
import UIKit
@testable import SwiftLayout
import SwiftUI

final class SwiftLayoutTests: XCTestCase {
    
    let root = UIView().tag.root
    let yellow = UIView().tag.yellow
    let green = UIView().tag.green
    let red = UIView().tag.red
    let blue = UIView().tag.blue
    
    func testViewHierarchyOneInOneView() throws {
        let expect =  _LayoutTree(up: nil,
                                  element: _LayoutElement(view: root),
                                  fork: _LayoutFork(view: yellow))
        let result = root.layout {
            yellow
        }.active()
        
        XCTAssertEqual(result.debug.debugDescription, expect.debug.debugDescription, "\n\(result.debug.debugDescription)\n\(expect.debug.debugDescription)\n")
        
        XCTAssertEqual(yellow.superview, root)
    }
    
    func testViewHierarchyTwoInOneView() throws {
        let expect =  _LayoutTree(up: nil,
                                  element: _LayoutElement(view: root),
                                  fork: _LayoutFork(branches: [yellow, green]))
        let result = root.layout {
            yellow
            green
        }.active()
        
        XCTAssertEqual(result.debug.debugDescription, expect.debug.debugDescription, "\n\(result.debug.debugDescription)\n\(expect.debug.debugDescription)\n")
        
        XCTAssertEqual(root.subviews, [yellow, green])
    }
}

struct LayoutTreeDebug: CustomDebugStringConvertible {
    let tree: LayoutTree
    
    var debugDescription: String { String(describing: tree) }
}

extension LayoutTree {
    var debug: LayoutTreeDebug {
        .init(tree: self)
    }
}

extension UIView {

    var tag: Tag { .init(view: self) }
    
    @dynamicMemberLookup
    struct Tag {
        let view: UIView
        
        subscript(dynamicMember tag: String) -> UIView {
            view.accessibilityIdentifier = tag
            return view
        }
    }
}
