import XCTest
import UIKit
@testable import SwiftLayout

final class SwiftLayoutTests: XCTestCase {
    
    var root: UIView!
    var yellow: UIView!
    var green: UIView!
    var red: UIView!
    var blue: UIView!
    
    override func setUp() {
        
        root = UIView().tag.root
        yellow = UIView().tag.yellow
        green = UIView().tag.green
        red = UIView().tag.red
        blue = UIView().tag.blue
        
    }
    
    func testSimpleViewHierarchy() {
        root {
            yellow
        }
        
        XCTAssertEqual(yellow.superview, root)
    }
    
    func testViewBlockHierarchy() {
        root {
            yellow
            green
        }
        
        XCTAssertEqual(Set(root.subviews), Set([yellow, green]))
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
