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
    
    func testLayoutTreeBuild() {
        let tree = root {
            yellow
        }
        
        XCTAssertTrue(tree is LayoutTree, "\(type(of: tree)) is not LayoutTree")
    }
    
    func testLayoutContainableDoNotContain() {
        context("root의 layoutable을 보관하지 않으면") {
            root {
                yellow
            }
            context("yellow의 superview는 사라진다") {
                XCTAssertNil(yellow.superview)
            }
        }
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
    
    func testNDepthViewHierarchy() {
        root {
            yellow {
                green
                red {
                    blue
                }
            }
        }
        
        XCTAssertEqual(blue.superview, red)
        XCTAssertEqual(red.superview, yellow)
        XCTAssertEqual(green.superview, yellow)
        XCTAssertEqual(yellow.superview, root)
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
