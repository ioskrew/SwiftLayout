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
    
    func testViewHierarchy() throws {
        context("root: [yellow]") {
            let expect = LayoutTree(root, content: yellow)
            let dsl = root {
                yellow
            }
            XCTAssertEqual(dsl, expect)
            XCTAssertEqual(dsl.debugDescription, "root: [yellow]")
            XCTAssertEqual(yellow.superview, root)
        }
        
        context("root: [yellow: [green]]") {
            let expect = LayoutTree(root, content: LayoutTree(yellow, content: green))
            let dsl = root {
                yellow {
                    green
                }
            }
            
            let dsl2 = root {
                yellow
            }
            
            XCTAssertEqual(dsl, expect)
            XCTAssertNotEqual(dsl2, expect)
            XCTAssertEqual(dsl.debugDescription, "root: [yellow: [green]]")
            XCTAssertEqual(yellow.superview, root)
            XCTAssertEqual(green.superview, yellow)
        }
        
        context("root: [yellow, green]") {
            let expect = LayoutTree(root, content: LayoutTree(branches: [yellow, green]))
            let dsl = root {
                yellow
                green
            }
            
            XCTAssertEqual(dsl, expect)
            XCTAssertEqual(dsl.debugDescription, "root: [yellow, green]")
            
            XCTAssertEqual(root.subviews.map(\.layoutIdentifier), [yellow, green].map(\.layoutIdentifier))
        }
        
        context("root: [yellow: [red], green]") {
            let expect = LayoutTree(root, content: LayoutTree(branches: [LayoutTree(yellow, content: red), green]))
            let dsl = root {
                yellow {
                    red
                }
                green
            }
            
            XCTAssertEqual(dsl, expect)
            XCTAssertEqual(dsl.debugDescription, "root: [yellow: [red], green]")
            
            XCTAssertEqual(root.subviews.map(\.layoutIdentifier), [yellow, green].map(\.layoutIdentifier))
            XCTAssertEqual(red.superview, yellow)
        }
    }
}

struct LayoutTreeDebug: CustomDebugStringConvertible {
    let tree: LayoutTree
    
    var debugDescription: String {
        String(describing: tree)
    }
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
