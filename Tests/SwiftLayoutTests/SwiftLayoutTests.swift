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
    
    func testClearDuplicatedViewBranch() {
        let dsl = root.layout {
            yellow {
                green
            }
            red {
                blue
                green
            }
        }
        XCTAssertEqual(dsl.debugDescription, "UIView[root] { UIView[yellow], UIView[red] { UIView[blue], UIView[green] } }")
    }
    
    func testViewHierarchy() throws {
        context("UIView[root] { UIView[yellow] }") {
            let expect = LayoutTree(root, content: yellow)
            let dsl = root.layout {
                yellow
            }
            XCTAssertLayoutEqual(dsl, expect)
            XCTAssertEqual(dsl.debugDescription, "UIView[root] { UIView[yellow] }")
            XCTAssertEqual(yellow.superview, root)
        }
        
        context("UIView[root] { UIView[yellow], UIView[green] }") {
            let expect = LayoutTree(root, content: LayoutTree(branches: [yellow, green]))
            let dsl = root.layout {
                yellow
                green
            }
            
            XCTAssertLayoutEqual(dsl, expect)
            XCTAssertEqual(dsl.debugDescription, "UIView[root] { UIView[yellow], UIView[green] }")
            
            XCTAssertEqual(root.subviews.map(\.layoutIdentifier), [yellow, green].map(\.layoutIdentifier))
        }
        
        context("UIView[root] { UIView[yellow] { UIView[green] } }") {
            let expect = LayoutTree(root, content: LayoutTree(yellow, content: green))
            let dsl = root.layout {
                yellow {
                    green
                }
            }
            
            let dsl2 = root.layout {
                yellow
            }
            
            XCTAssertLayoutEqual(dsl, expect)
            XCTAssertLayoutNotEqual(dsl2, expect)
            XCTAssertEqual(dsl.debugDescription, "UIView[root] { UIView[yellow] { UIView[green] } }")
            XCTAssertEqual(yellow.superview, root)
            XCTAssertEqual(green.superview, yellow)
        }
        
        context("UIView[root] { UIView[yellow] { UIView[red] }, UIView[green] }") {
            let expect = LayoutTree(root, content: LayoutTree(branches: [LayoutTree(yellow, content: red), green]))
            let dsl = root.layout {
                yellow {
                    red
                }
                green
            }
            
            XCTAssertLayoutEqual(dsl, expect)
            XCTAssertEqual(dsl.debugDescription, "UIView[root] { UIView[yellow] { UIView[red] }, UIView[green] }")
            
            XCTAssertEqual(root.subviews.map(\.layoutIdentifier), [yellow, green].map(\.layoutIdentifier))
            XCTAssertEqual(red.superview, yellow)
        }
        
        context("root: [yellow: [red], green: [blue]]") {
            let bluetree = LayoutTree(content: .view(blue))
            let redtree = LayoutTree(content: .view(red))
            let yellowtree = LayoutTree(yellow, content: redtree)
            let greentree = LayoutTree(green, content: bluetree)
            let roottree = LayoutTree(root, content: LayoutTree(branches: [yellowtree, greentree]))
            let dsl = root.layout {
                yellow {
                    red
                }
                green {
                    blue
                }
            }
            
            XCTAssertLayoutEqual(dsl, roottree)
            XCTAssertEqual(dsl.debugDescription, "UIView[root] { UIView[yellow] { UIView[red] }, UIView[green] { UIView[blue] } }")
            
            XCTAssertEqual(root.subviews.map(\.layoutIdentifier), [yellow, green].map(\.layoutIdentifier))
            XCTAssertEqual(red.superview, yellow)
            XCTAssertEqual(blue.superview, green)
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
