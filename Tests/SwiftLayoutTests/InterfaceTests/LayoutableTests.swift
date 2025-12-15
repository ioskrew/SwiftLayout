@testable import SwiftLayout
import Testing
import SwiftLayoutPlatform

@MainActor
struct LayoutableTests {

    @MainActor
    init() {}

    let view = LayoutableView()

    @Test
    func ifTrue() {
        view.frame = .init(x: 0, y: 0, width: 90, height: 90)
        view.slLayoutIfNeeded()

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

        let expectedConstraints = [
            NSLayoutConstraint(item: view.root, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: view.root, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: view.root, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: view.root, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        ]

        #expect(hasSameElements(view.constraints, expectedConstraints, view.tags))
        #expect(view.child.constraints.isEmpty)
        #expect(view.friend.constraints.isEmpty)
    }

    @Test
    func ifFalse() {
        view.frame = .init(x: 0, y: 0, width: 90, height: 90)
        view.slLayoutIfNeeded()
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

        let expectedViewConstraints = [
            NSLayoutConstraint(item: view.root, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: view.root, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0)
        ]

        let expectedRootConstraints = [
            NSLayoutConstraint(item: view.root, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50),
            NSLayoutConstraint(item: view.root, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50
                              ),
            NSLayoutConstraint(item: view.friend, attribute: .leading, relatedBy: .equal, toItem: view.root, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: view.friend, attribute: .trailing, relatedBy: .equal, toItem: view.root, attribute: .trailing, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: view.friend, attribute: .top, relatedBy: .equal, toItem: view.root, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: view.friend, attribute: .bottom, relatedBy: .equal, toItem: view.root, attribute: .bottom, multiplier: 1.0, constant: 0)
        ]

        #expect(hasSameElements(view.constraints, expectedViewConstraints, view.tags))
        #expect(hasSameElements(view.root.constraints, expectedRootConstraints, view.tags))
        #expect(view.child.constraints.testDescriptions(view.tags).isEmpty)
        #expect(view.friend.constraints.testDescriptions(view.tags).isEmpty)
    }

    @Test
    func ifFalseAndForceLayout() {
        view.frame = .init(x: 0, y: 0, width: 90, height: 90)
        view.slLayoutIfNeeded()
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

        let expectedViewConstraints = [
            NSLayoutConstraint(item: view.root, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: view.root, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0)
        ]

        let expectedRootConstraints = [
            NSLayoutConstraint(item: view.root, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50),
            NSLayoutConstraint(item: view.root, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50
                              ),
            NSLayoutConstraint(item: view.friend, attribute: .leading, relatedBy: .equal, toItem: view.root, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: view.friend, attribute: .trailing, relatedBy: .equal, toItem: view.root, attribute: .trailing, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: view.friend, attribute: .top, relatedBy: .equal, toItem: view.root, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: view.friend, attribute: .bottom, relatedBy: .equal, toItem: view.root, attribute: .bottom, multiplier: 1.0, constant: 0)
        ]

        #expect(hasSameElements(view.constraints, expectedViewConstraints, view.tags))
        #expect(hasSameElements(view.root.constraints, expectedRootConstraints, view.tags))
        #expect(view.child.constraints.isEmpty)
        #expect(view.friend.constraints.isEmpty)
    }

    final class LayoutableView: SLView, Layoutable {
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

        var tags: [SLView: String] {
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
