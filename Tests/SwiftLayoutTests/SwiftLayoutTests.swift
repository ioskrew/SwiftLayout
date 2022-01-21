import XCTest
import UIKit
@testable import SwiftLayout

final class SwiftLayoutTests: XCTestCase {
    func testDebugDescription() throws {
        let root = UIView().tag.root
        let yellow = UIView().tag.yellow
        let green = UIView().tag.green
        let red = UIView().tag.red
        let blue = UIView().tag.blue
        let result = root.layout {
            yellow {
                blue
            }
            green {
                red
                blue
            }
        }.active()
        
        XCTAssertEqual(yellow.superview, root)
        XCTAssertEqual(green.superview, root)
        XCTAssertEqual(red.superview, green)
        XCTAssertEqual(blue.superview, green)
        
        XCTAssertNotEqual(blue.superview, yellow)
        
        XCTAssertEqual(result.debugDescription, "root: [yellow, green: [red, blue]]")
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
