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
            let expect = LayoutTree(view: .view(root), branches: [yellow])
            XCTAssertEqual(yellow.superview, root)
            let dsl = root {
                yellow
            }
            XCTAssertEqual(dsl, expect)
            XCTAssertEqual(dsl.debugDescription, "root(UIView): [yellow(UIView)]")
        }
        
        context("root: [yellow: [green]]") {
            let expect = LayoutTree(view: .view(root), branches: [LayoutTree(view: yellow, content: green)])
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
            XCTAssertEqual(dsl.debugDescription, "root(UIView): [yellow(UIView): [green(UIView)]]")
        }
        
        context("root 밑에 yellow, yellow 밑에 blue뷰 구조를 직접 생성") {
            
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
