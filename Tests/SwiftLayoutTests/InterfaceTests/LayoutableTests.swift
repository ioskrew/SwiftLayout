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
        assertTrueCase(view)
        
        view.flag.toggle()
        
        XCTAssertEqual(view.root.frame, CGRect(x: .zero, y: .zero, width: 90, height: 90))
        XCTAssertEqual(view.friend.frame, CGRect.zero)
        assertFalseCase(view)
        
        view.sl.updateLayout(forceLayout: true)
        
        XCTAssertEqual(view.root.frame, CGRect(x: 20, y: 20, width: 50, height: 50))
        XCTAssertEqual(view.friend.frame, CGRect(x: .zero, y: .zero, width: 50, height: 50))
        assertFalseCase(view)
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
            self {
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
    
    private func assertTrueCase(_ view: LayoutableView) {
        assertView(view, superview: nil, subviews: [view.root])
        assertView(view.root, superview: view, subviews: [view.child])
        assertView(view.child, superview: view.root, subviews: [])
        assertView(view.friend, superview: nil, subviews: [])
        
        XCTAssertEqual(view.root.addSubviewCallCount(view.child), 1)
        XCTAssertEqual(view.root.addSubviewCallCount(view.friend), 0)
        XCTAssertEqual(view.root.removeFromSuperviewCallCount, 0)
        XCTAssertEqual(view.child.removeFromSuperviewCallCount, 0)
        XCTAssertEqual(view.root.removeFromSuperviewCallCount, 0)
        
        assertConstrints(view.constraints, [
            NSLayoutConstraint(item: view.root, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: view.root, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: view.root, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: view.root, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0),
        ])
        assertConstrints(view.root.constraints, [
            NSLayoutConstraint(item: view.child, attribute: .top, relatedBy: .equal, toItem: view.root, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: view.child, attribute: .bottom, relatedBy: .equal, toItem: view.root, attribute: .bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: view.child, attribute: .leading, relatedBy: .equal, toItem: view.root, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: view.child, attribute: .trailing, relatedBy: .equal, toItem: view.root, attribute: .trailing, multiplier: 1.0, constant: 0),
        ])
        assertConstrints(view.child.constraints, [])
        assertConstrints(view.friend.constraints, [])
    }
    
    private func assertFalseCase(_ view: LayoutableView) {
        assertView(view, superview: nil, subviews: [view.root])
        assertView(view.root, superview: view, subviews: [view.friend])
        assertView(view.child, superview: nil, subviews: [])
        assertView(view.friend, superview: view.root, subviews: [])
        
        XCTAssertEqual(view.root.addSubviewCallCount(view.child), 1)
        XCTAssertEqual(view.root.addSubviewCallCount(view.friend), 1)
        XCTAssertEqual(view.root.removeFromSuperviewCallCount, 0)
        XCTAssertEqual(view.child.removeFromSuperviewCallCount, 1)
        XCTAssertEqual(view.root.removeFromSuperviewCallCount, 0)
        
        assertConstrints(view.constraints, [
            NSLayoutConstraint(item: view.root, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: view.root, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0),
        ])
        assertConstrints(view.root.constraints, [
            NSLayoutConstraint(item: view.root, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 50),
            NSLayoutConstraint(item: view.root, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 50),
            
            NSLayoutConstraint(item: view.friend, attribute: .top, relatedBy: .equal, toItem: view.root, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: view.friend, attribute: .bottom, relatedBy: .equal, toItem: view.root, attribute: .bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: view.friend, attribute: .leading, relatedBy: .equal, toItem: view.root, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: view.friend, attribute: .trailing, relatedBy: .equal, toItem: view.root, attribute: .trailing, multiplier: 1.0, constant: 0),
        ])
        assertConstrints(view.child.constraints, [])
        assertConstrints(view.friend.constraints, [])
    }
}
