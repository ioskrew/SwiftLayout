import XCTest
import SwiftLayout

final class LayoutableTests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testUpdateLayout() {
        let view = LayoutableView()
        view.frame = .init(x: 0, y: 0, width: 90, height: 90)
        view.layoutIfNeeded()
        
        XCTAssertEqual(view.root.frame, CGRect(x: .zero, y: .zero, width: 90, height: 90))
        XCTAssertEqual(view.child.frame, CGRect(x: .zero, y: .zero, width: 90, height: 90))
        
        contextInActivity("if true") { _ in
            SLTAssertView(view, superview: nil, subviews: [view.root])
            SLTAssertView(view.root, superview: view, subviews: [view.child])
            SLTAssertView(view.child, superview: view.root, subviews: [])
            SLTAssertView(view.friend, superview: nil, subviews: [])
            
            XCTAssertEqual(view.root.addSubviewCallCount(view.child), 1)
            XCTAssertEqual(view.root.addSubviewCallCount(view.friend), 0)
            XCTAssertEqual(view.root.removeFromSuperviewCallCount, 0)
            XCTAssertEqual(view.child.removeFromSuperviewCallCount, 0)
            XCTAssertEqual(view.root.removeFromSuperviewCallCount, 0)
            
            SLTAssertConstraintsEqual(view.constraints, firstView: view.root, secondView: view, tags: [view: "layoutableView", view.root: "layoutableView.root"]) {
                Anchors.allSides()
            }
           
            SLTAssertConstraintsIsEmpty(view.child.constraints)
            SLTAssertConstraintsIsEmpty(view.friend.constraints)
        }
        
        view.flag.toggle()
        
        XCTAssertEqual(view.root.frame, CGRect(x: .zero, y: .zero, width: 90, height: 90))
        XCTAssertEqual(view.friend.frame, CGRect.zero)
        contextInActivity("if false") { _ in
            SLTAssertView(view, superview: nil, subviews: [view.root])
            SLTAssertView(view.root, superview: view, subviews: [view.friend])
            SLTAssertView(view.child, superview: nil, subviews: [])
            SLTAssertView(view.friend, superview: view.root, subviews: [])
            
            XCTAssertEqual(view.root.addSubviewCallCount(view.child), 1)
            XCTAssertEqual(view.root.addSubviewCallCount(view.friend), 1)
            XCTAssertEqual(view.root.removeFromSuperviewCallCount, 0)
            XCTAssertEqual(view.child.removeFromSuperviewCallCount, 1)
            XCTAssertEqual(view.root.removeFromSuperviewCallCount, 0)
            
            SLTAssertConstraintsEqual(view.constraints, firstView: view.root, secondView: view) {
                Anchors.center()
            }
            SLTAssertConstraintsEqual(view.root.constraints) {
                TestAnchors(first: view.root) {
                    Anchors.size(width: 50, height: 50)
                }
                TestAnchors(first: view.friend, second: view.root) {
                    Anchors.allSides()
                }
            }
            SLTAssertConstraintsIsEmpty(view.child.constraints)
            SLTAssertConstraintsIsEmpty(view.friend.constraints)
        }
        
        view.sl.updateLayout(forceLayout: true)
        
        XCTAssertEqual(view.root.frame, CGRect(x: 20, y: 20, width: 50, height: 50))
        XCTAssertEqual(view.friend.frame, CGRect(x: .zero, y: .zero, width: 50, height: 50))
        contextInActivity("if false after update layout") { _ in
            SLTAssertView(view, superview: nil, subviews: [view.root])
            SLTAssertView(view.root, superview: view, subviews: [view.friend])
            SLTAssertView(view.child, superview: nil, subviews: [])
            SLTAssertView(view.friend, superview: view.root, subviews: [])
            
            XCTAssertEqual(view.root.addSubviewCallCount(view.child), 1)
            XCTAssertEqual(view.root.addSubviewCallCount(view.friend), 2)
            XCTAssertEqual(view.root.removeFromSuperviewCallCount, 0)
            XCTAssertEqual(view.child.removeFromSuperviewCallCount, 1)
            XCTAssertEqual(view.root.removeFromSuperviewCallCount, 0)
            
            SLTAssertConstraintsEqual(view.constraints, firstView: view.root, secondView: view) {
                Anchors.center()
            }
            SLTAssertConstraintsEqual(view.root.constraints) {
                TestAnchors(first: view.root) {
                    Anchors.size(width: 50, height: 50)
                }
                TestAnchors(first: view.friend, second: view.root) {
                    Anchors.allSides()
                }
            }
            SLTAssertConstraintsIsEmpty(view.child.constraints)
            SLTAssertConstraintsIsEmpty(view.friend.constraints)
        }
    }
}

extension LayoutableTests {
    private class LayoutableView: UIView, Layoutable {
        @LayoutProperty var flag = true
        
        let root = CallCountView()
        let child = CallCountView()
        let friend = CallCountView()
        
        var activation: Activation?
        
        var layout: some Layout {
            self.sublayout {
                root.anchors {
                    if flag {
                        Anchors.allSides()
                    } else {
                        Anchors.size(width: 50, height: 50)
                        Anchors.center()
                    }
                }.sublayout {
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
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            sl.updateLayout()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            sl.updateLayout()
        }
    }
    
}
