import Testing
@testable import SwiftLayout
import UIKit

@MainActor
struct LayoutableTests {
    
    let view = LayoutableView()
    
    @Test
    func ifTrue() {
        view.frame = .init(x: 0, y: 0, width: 90, height: 90)
        view.layoutIfNeeded()
        
        #expect(view.root.frame == CGRect(x: .zero, y: .zero, width: 90, height: 90))
        #expect(view.child.frame == CGRect(x: .zero, y: .zero, width: 90, height: 90))
        
        #expect(view.superview == nil && view.subviews == [view.root])
        #expect(view.root.superview == view && view.root.subviews == [view.child])
        #expect(view.child.superview == view.root && view.child.subviews == [])
        #expect(view.friend.superview == nil && view.friend.subviews == [])
        
        #expect(view.root.addSubviewCallCount(view.child) == 1)
        #expect(view.root.addSubviewCallCount(view.friend) == 0)
        #expect(view.root.removeFromSuperviewCallCount == 0)
        #expect(view.child.removeFromSuperviewCallCount == 0)
        #expect(view.root.removeFromSuperviewCallCount == 0)
        
        #expect(isEqual(view.constraints, view.tags) {
            TestAnchors(first: view.root, second: view) {
                Anchors.allSides.equalToSuper()
            }
        })
        
        #expect(view.child.constraints.isEmpty)
        #expect(view.friend.constraints.isEmpty)
    }
    
    @Test
    func ifFalse() {
        view.frame = .init(x: 0, y: 0, width: 90, height: 90)
        view.layoutIfNeeded()
        view.flag = false
        
        #expect(view.root.frame == CGRect(x: .zero, y: .zero, width: 90, height: 90))
        #expect(view.friend.frame == CGRect.zero)
        #expect(view.superview == nil && view.subviews == [view.root])
        #expect(view.root.superview == view && view.root.subviews == [view.friend])
        #expect(view.child.superview == nil && view.child.subviews == [])
        #expect(view.friend.superview == view.root && view.friend.subviews == [])
        
        #expect(view.root.addSubviewCallCount(view.child) == 1)
        #expect(view.root.addSubviewCallCount(view.friend) == 1)
        #expect(view.root.removeFromSuperviewCallCount == 0)
        #expect(view.child.removeFromSuperviewCallCount == 1)
        #expect(view.root.removeFromSuperviewCallCount == 0)
        
        let constraints = view.constraints
        let expected = Anchors.center.equalToSuper().constraints(
            item: view.root,
            toItem: view
        )
        #expect(isEqual(view.constraints, view.tags) {
            TestAnchors(first: view.root, second: view) {
                Anchors.center.equalToSuper()
            }
        })
        #expect(isEqual(view.root.constraints, view.tags) {
            TestAnchors(first: view.root) {
                Anchors.size.equalTo(
                    width: 50,
                    height: 50
                )
            }
            TestAnchors(first: view.friend, second: view.root) {
                Anchors.allSides.equalToSuper()
            }
        })
        #expect(view.child.constraints.testDescriptions(view.tags).isEmpty)
        #expect(view.friend.constraints.testDescriptions(view.tags).isEmpty)
    }
    
    @Test
    func ifFalseAndForceLayout() {
        view.frame = .init(x: 0, y: 0, width: 90, height: 90)
        view.layoutIfNeeded()
        view.flag = false
        view.sl.updateLayout(forceLayout: true)
        
        #expect(view.root.frame == CGRect(x: 20, y: 20, width: 50, height: 50))
        #expect(view.friend.frame == CGRect(x: .zero, y: .zero, width: 50, height: 50))
        #expect(view.superview == nil && view.subviews == [view.root])
        #expect(view.root.superview == view && view.root.subviews == [view.friend])
        #expect(view.child.superview == nil && view.child.subviews == [])
        #expect(view.friend.superview == view.root && view.friend.subviews == [])
        
        #expect(view.root.addSubviewCallCount(view.child) == 1)
        #expect(view.root.addSubviewCallCount(view.friend) == 2)
        #expect(view.root.removeFromSuperviewCallCount == 0)
        #expect(view.child.removeFromSuperviewCallCount == 1)
        #expect(view.root.removeFromSuperviewCallCount == 0)
        
        #expect(isEqual(view.constraints, view.tags) {
            TestAnchors(first: view.root, second: view) {
                Anchors.center.equalToSuper()
            }
        })
        #expect(isEqual(view.root.constraints, view.tags) {
            TestAnchors(first: view.root) {
                Anchors.size.equalTo(
                    width: 50,
                    height: 50
                )
            }
            TestAnchors(first: view.friend, second: view.root) {
                Anchors.allSides.equalToSuper()
            }
        })
        #expect(view.child.constraints.isEmpty)
        #expect(view.friend.constraints.isEmpty)
    }
    
    final class LayoutableView: UIView, Layoutable {
        @LayoutProperty var flag = true
        
        let root = CallCountView()
        let child = CallCountView()
        let friend = CallCountView()
        
        var activation: Activation?
        
        var layout: some Layout {
            self.sl.sublayout {
                root.sl.anchors {
                    if flag {
                        Anchors.allSides.equalToSuper()
                    } else {
                        Anchors.size.equalTo(width: 50, height: 50)
                        Anchors.center.equalToSuper()
                    }
                }.sublayout {
                    if flag {
                        child.sl.anchors {
                            Anchors.allSides.equalToSuper()
                        }
                    } else {
                        friend.sl.anchors {
                            Anchors.allSides.equalToSuper()
                        }
                    }
                }
            }
        }
        
        var tags: [UIView: String] {
            [self: "layoutableView", root: "layoutableView.root"]
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
