import XCTest
import UIKit
@testable import SwiftLayout

final class SwiftLayoutTests: XCTestCase {
    
    let root = UIView().tag.root
    let yellow = UIView().tag.yellow
    let green = UIView().tag.green
    let red = UIView().tag.red
    let blue = UIView().tag.blue
    
    ///
    /// ```swift
    /// _ViewNode(view: root, children: [_ViewNode(view: yello)])
    /// ```
    func testViewHierarchyOneView() throws {

        let result = root.layout {
            yellow
        }.active()
        
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
