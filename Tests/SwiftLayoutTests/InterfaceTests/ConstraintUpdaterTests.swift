@testable import SwiftLayout
import Testing
import SwiftLayoutPlatform

@MainActor
struct ConstraintUpdaterTests {

    @MainActor
    class TestBase {
        let superview = SLView()
        let subview = SLView()
        var activation: Activation?
    }

    // MARK: - Basic Update Tests

    final class BasicUpdateTests: TestBase {

        @Test
        func updateConstant() {
            @LayoutBuilder
            var layout: some Layout {
                superview.sl.sublayout {
                    subview.sl.anchors {
                        Anchors.top.equalToSuper(constant: 10).identifier("topAnchor")
                    }
                }
            }

            activation = layout.active()

            // Verify initial constant
            let initialConstraint = superview.constraints.first {
                $0.identifier == "topAnchor"
            }
            #expect(initialConstraint?.constant == 10)

            // Update constant
            activation?.anchors("topAnchor").update(constant: 20)

            // Verify updated constant
            let updatedConstraint = superview.constraints.first {
                $0.identifier == "topAnchor"
            }
            #expect(updatedConstraint?.constant == 20)
        }

        @Test
        func updatePriority() {
            @LayoutBuilder
            var layout: some Layout {
                superview.sl.sublayout {
                    subview.sl.anchors {
                        Anchors.top.equalToSuper().identifier("topAnchor").priority(.defaultLow)
                    }
                }
            }

            activation = layout.active()

            // Verify initial priority
            let initialConstraint = superview.constraints.first {
                $0.identifier == "topAnchor"
            }
            #expect(initialConstraint?.priority == .defaultLow)

            // Update priority
            activation?.anchors("topAnchor").update(priority: .defaultHigh)

            // Verify updated priority
            let updatedConstraint = superview.constraints.first {
                $0.identifier == "topAnchor"
            }
            #expect(updatedConstraint?.priority == .defaultHigh)
        }

        @Test
        func updateBothConstantAndPriority() {
            @LayoutBuilder
            var layout: some Layout {
                superview.sl.sublayout {
                    subview.sl.anchors {
                        Anchors.leading.equalToSuper(constant: 5).identifier("leadingAnchor").priority(.defaultLow)
                    }
                }
            }

            activation = layout.active()

            // Update both
            activation?.anchors("leadingAnchor").update(constant: 15, priority: .required)

            let updatedConstraint = superview.constraints.first {
                $0.identifier == "leadingAnchor"
            }
            #expect(updatedConstraint?.constant == 15)
            #expect(updatedConstraint?.priority == .required)
        }

        @Test
        func updateWithNilValuesKeepsCurrent() {
            @LayoutBuilder
            var layout: some Layout {
                superview.sl.sublayout {
                    subview.sl.anchors {
                        Anchors.top.equalToSuper(constant: 10).identifier("topAnchor").priority(.defaultHigh)
                    }
                }
            }

            activation = layout.active()

            // Update only constant (priority should remain)
            activation?.anchors("topAnchor").update(constant: 20)

            let constraint = superview.constraints.first {
                $0.identifier == "topAnchor"
            }
            #expect(constraint?.constant == 20)
            #expect(constraint?.priority == .defaultHigh)
        }
    }

    // MARK: - Multiple Constraints Tests

    final class MultipleConstraintsTests: TestBase {

        @Test
        func updateMultipleConstraintsWithSameIdentifier() {
            @LayoutBuilder
            var layout: some Layout {
                superview.sl.sublayout {
                    subview.sl.anchors {
                        Anchors.horizontal.equalToSuper(constant: 10).identifier("horizontalInset")
                    }
                }
            }

            activation = layout.active()

            // Should have 2 constraints with same identifier (leading and trailing)
            let constraintsBefore = superview.constraints.filter {
                $0.identifier == "horizontalInset"
            }
            #expect(constraintsBefore.count == 2)
            #expect(constraintsBefore.allSatisfy { $0.constant == 10 })

            // Update all constraints with the identifier
            activation?.anchors("horizontalInset").update(constant: 20)

            let constraintsAfter = superview.constraints.filter {
                $0.identifier == "horizontalInset"
            }
            #expect(constraintsAfter.count == 2)
            #expect(constraintsAfter.allSatisfy { $0.constant == 20 })
        }

        @Test
        func updateSpecificAttributeWithPredicate() {
            @LayoutBuilder
            var layout: some Layout {
                superview.sl.sublayout {
                    subview.sl.anchors {
                        Anchors.top.equalToSuper(constant: 10).identifier("edges")
                        Anchors.bottom.equalToSuper(constant: -10).identifier("edges")
                    }
                }
            }

            activation = layout.active()

            // Update only top constraint
            activation?.anchors("edges", attribute: .top).update(constant: 30)

            let topConstraint = superview.constraints.first {
                $0.identifier == "edges" && $0.firstAttribute == .top
            }
            let bottomConstraint = superview.constraints.first {
                $0.identifier == "edges" && $0.firstAttribute == .bottom
            }

            #expect(topConstraint?.constant == 30)
            #expect(bottomConstraint?.constant == -10) // unchanged
        }

        @Test
        func updateWithCustomPredicate() {
            @LayoutBuilder
            var layout: some Layout {
                superview.sl.sublayout {
                    subview.sl.anchors {
                        Anchors.leading.equalToSuper(constant: 10).identifier("inset")
                        Anchors.trailing.equalToSuper(constant: -10).identifier("inset")
                        Anchors.top.equalToSuper(constant: 5).identifier("inset")
                    }
                }
            }

            activation = layout.active()

            // Update only constraints with positive constants
            activation?.anchors("inset", predicate: { $0.constant > 0 }).update(constant: 50)

            let leadingConstraint = superview.constraints.first {
                $0.identifier == "inset" && $0.firstAttribute == .leading
            }
            let trailingConstraint = superview.constraints.first {
                $0.identifier == "inset" && $0.firstAttribute == .trailing
            }
            let topConstraint = superview.constraints.first {
                $0.identifier == "inset" && $0.firstAttribute == .top
            }

            #expect(leadingConstraint?.constant == 50)
            #expect(trailingConstraint?.constant == -10) // negative, not updated
            #expect(topConstraint?.constant == 50)
        }
    }

    // MARK: - Edge Cases Tests

    final class EdgeCasesTests: TestBase {

        @Test
        func updateNonExistentIdentifier() {
            @LayoutBuilder
            var layout: some Layout {
                superview.sl.sublayout {
                    subview.sl.anchors {
                        Anchors.top.equalToSuper(constant: 10).identifier("topAnchor")
                    }
                }
            }

            activation = layout.active()

            // This should not crash or cause issues
            activation?.anchors("nonExistent").update(constant: 100)

            // Original constraint should be unchanged
            let constraint = superview.constraints.first {
                $0.identifier == "topAnchor"
            }
            #expect(constraint?.constant == 10)
        }

        @Test
        func updateAfterDeactivation() {
            @LayoutBuilder
            var layout: some Layout {
                superview.sl.sublayout {
                    subview.sl.anchors {
                        Anchors.top.equalToSuper(constant: 10).identifier("topAnchor")
                    }
                }
            }

            activation = layout.active()

            // Store updater before deactivation
            let updater = activation?.anchors("topAnchor")

            activation?.deactive()
            activation = nil

            // This should not crash (weak reference should be nil)
            updater?.update(constant: 100)
        }

        @Test
        func updaterCanBeStoredAndReused() {
            @LayoutBuilder
            var layout: some Layout {
                superview.sl.sublayout {
                    subview.sl.anchors {
                        Anchors.top.equalToSuper(constant: 10).identifier("topAnchor")
                    }
                }
            }

            activation = layout.active()

            // Store updater
            let updater = activation?.anchors("topAnchor")

            // First update
            updater?.update(constant: 20)
            var constraint = superview.constraints.first {
                $0.identifier == "topAnchor"
            }
            #expect(constraint?.constant == 20)

            // Reuse updater
            updater?.update(constant: 30)
            constraint = superview.constraints.first {
                $0.identifier == "topAnchor"
            }
            #expect(constraint?.constant == 30)
        }

        @Test
        func updateWithBothNilDoesNothing() {
            @LayoutBuilder
            var layout: some Layout {
                superview.sl.sublayout {
                    subview.sl.anchors {
                        Anchors.top.equalToSuper(constant: 10).identifier("topAnchor").priority(.defaultHigh)
                    }
                }
            }

            activation = layout.active()

            // Update with both nil values
            activation?.anchors("topAnchor").update(constant: nil, priority: nil)

            let constraint = superview.constraints.first {
                $0.identifier == "topAnchor"
            }
            #expect(constraint?.constant == 10)
            #expect(constraint?.priority == .defaultHigh)
        }
    }

    // MARK: - ConstraintDescriptor Tests

    final class ConstraintDescriptorTests: TestBase {

        @Test
        func descriptorProvidesCorrectProperties() {
            let anotherView = SLView()

            @LayoutBuilder
            var layout: some Layout {
                superview.sl.sublayout {
                    anotherView
                    subview.sl.anchors {
                        Anchors.top.equalTo(anotherView, constant: 15).identifier("relativeTop").priority(.defaultHigh)
                    }
                }
            }

            activation = layout.active()

            var descriptorChecked = false

            activation?.anchors("relativeTop", predicate: { descriptor in
                #expect(descriptor.attribute == .top)
                #expect(descriptor.relation == .equal)
                #expect(descriptor.constant == 15)
                #expect(descriptor.priority == .defaultHigh)
                #expect(descriptor.identifier == "relativeTop")
                descriptorChecked = true
                return true
            }).update(constant: 20)

            #expect(descriptorChecked)
        }
    }

    // MARK: - Width/Height Constraint Tests

    final class DimensionConstraintTests: TestBase {

        @Test
        func updateWidthConstraint() {
            @LayoutBuilder
            var layout: some Layout {
                superview.sl.sublayout {
                    subview.sl.anchors {
                        Anchors.width.equalTo(constant: 100).identifier("widthConstraint")
                    }
                }
            }

            activation = layout.active()

            activation?.anchors("widthConstraint").update(constant: 200)

            let constraint = subview.constraints.first {
                $0.identifier == "widthConstraint"
            }
            #expect(constraint?.constant == 200)
        }

        @Test
        func updateSizeConstraints() {
            @LayoutBuilder
            var layout: some Layout {
                superview.sl.sublayout {
                    subview.sl.anchors {
                        Anchors.size.equalTo(width: 100, height: 50).identifier("sizeConstraints")
                    }
                }
            }

            activation = layout.active()

            // Update only width
            activation?.anchors("sizeConstraints", attribute: .width).update(constant: 150)

            let widthConstraint = subview.constraints.first {
                $0.identifier == "sizeConstraints" && $0.firstAttribute == .width
            }
            let heightConstraint = subview.constraints.first {
                $0.identifier == "sizeConstraints" && $0.firstAttribute == .height
            }

            #expect(widthConstraint?.constant == 150)
            #expect(heightConstraint?.constant == 50)
        }
    }
}
