import XCTest
import UIKit
@testable import SwiftLayout

final class SwiftLayoutTests: XCTestCase {
    
    var superview: UIView!
    
    var root: UIView = UIView().viewTag.root
    var button: UIButton = UIButton().viewTag.button
    var label: UIView = UILabel().viewTag.label
    var redView: UIView = UIView().viewTag.redView
    var image: UIImageView = UIImageView().viewTag.image
    
    var layoutable: AnyLayoutable?
    
    override func setUp() {
        
        superview = UIView().viewTag.superview
       
        root.removeFromSuperview()
        button.removeFromSuperview()
        label.removeFromSuperview()
        redView.removeFromSuperview()
        image.removeFromSuperview()
    }
    
    func testLayoutTypes() {
        
        
    }
    
//    func testLayoutTreeBuild() {
//        context("Layoutable.active() 호출은") {
//            let tree = root {
//                yellow
//            }.active()
//            context("LayoutTree를 반환한다.") {
//                XCTAssertTrue(tree.layoutable is LayoutTree, "\(type(of: tree)) is not LayoutTree")
//                XCTAssertEqual(yellow.superview, root)
//            }
//        }
//        context("LayoutTree의 인스턴스를 보관하지 않으면") {
//            context("LayoutTree가 deinit될 때 view hierarchy도 사라진다") {
//                XCTAssertNil(yellow.superview)
//            }
//        }
//        context("Layoutable 생성 후") {
//            let tree = root {
//                yellow
//            }.active()
//            context("deactive()를 호출하면 ") {
//                tree.deactive()
//                context("LayoutTree의 view hierarchy를 모두 제거한다.") {
//                    XCTAssertTrue(tree.layoutable is LayoutTree, "\(type(of: tree)) is not LayoutTree")
//                    XCTAssertNil(yellow.superview)
//                }
//            }
//        }
//        context("LayoutTree 생성 후") {
//            superview.addSubview(root)
//            let tree = root {
//                yellow
//            }.active()
//            context("deactive상태가 되면") {
//                tree.deactive()
//                context("root tree의 뷰의 superview는 해제되지 않는다.") {
//                    XCTAssertEqual(root.superview, self.superview)
//                    XCTAssertNil(yellow.superview)
//                }
//            }
//        }
//    }
//
//    func testLayoutContainableDoNotContain() {
//        context("root의 layoutable을 보관하지 않으면") {
//            root {
//                yellow
//            }
//            context("yellow의 superview는 사라진다") {
//                XCTAssertNil(yellow.superview)
//            }
//        }
//    }
//
//    func testSimpleViewHierarchy() {
//        layoutable = root {
//            yellow
//        }.active()
//
//        XCTAssertEqual(yellow.superview, root)
//    }
//
//    func testViewBlockHierarchy() {
//        layoutable = root {
//            yellow
//            green
//        }.active()
//
//        XCTAssertEqual(Set(root.subviews), Set([yellow, green]))
//    }
//
//    func testNDepthViewHierarchy() {
//        layoutable = root {
//            yellow {
//                green
//                red {
//                    blue
//                }
//            }
//        }.active()
//
//        print(layoutable!)
//        XCTAssertEqual(blue.superview, red)
//        XCTAssertEqual(red.superview, yellow)
//        XCTAssertEqual(green.superview, yellow)
//        XCTAssertEqual(yellow.superview, root)
//    }
    
}

@dynamicMemberLookup
struct Tag<Taggable> where Taggable: UIAccessibilityIdentification {
    let taggable: Taggable
    
    subscript(dynamicMember tag: String) -> Taggable {
        taggable.accessibilityIdentifier = tag
        return taggable
    }
}

extension UIAccessibilityIdentification {
    var viewTag: Tag<Self> {
        Tag(taggable: self)
    }
}
