import XCTest
import UIKit
import SwiftLayout

final class LayoutBuildingTest: XCTestCase {
    func testUpdateLayout() {
        let view = LayoutView()
        let root = view.root
        view.updateLayout()
        
        XCTAssertEqual(root.addSubviewCount, 1)
        
        view.updateLayout()
        
        XCTAssertEqual(root.addSubviewCount, 1)
        XCTAssertEqual(root.findConstraints(items: (view.child, root)).count, 4)
        XCTAssertEqual(view.child.superview, root)
        XCTAssertNil(view.friend.superview)
        
        view.flag.toggle()
        view.updateLayout()
        
        XCTAssertEqual(root.addSubviewCount, 2)
        XCTAssertEqual(root.findConstraints(items: (view.friend, root)).count, 4)
        XCTAssertEqual(view.friend.superview, root)
        XCTAssertNil(view.child.superview)
    }
}

extension LayoutBuildingTest {
    class MockView: UIView {
        var addSubviewCount = 0
        override func addSubview(_ view: UIView) {
            addSubviewCount += 1
            super.addSubview(view)
        }
    }
    
    class LayoutView: UIView, LayoutBuilding {
        var flag = true
        
        let root = MockView().viewTag.root
        let child = UIView().viewTag.child
        let friend = UIView().viewTag.friend
        
        var deactivable: Deactivable?
        
        var layout: some Layout {
            root {
                if flag {
                    child.anchors {
                        Anchors.allSides()
                    }
                } else {
                    friend.anchors {
                        Anchors.allSides()
                    }
                }
            }
        }
    }
}
