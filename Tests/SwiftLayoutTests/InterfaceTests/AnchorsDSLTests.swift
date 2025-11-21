@testable import SwiftLayout
import Testing
import UIKit

extension Tag {
    @Tag
    static var deactivation: Self
}

/// test cases for constraint DSL syntax
struct AnchorsDSLTests { // swiftlint:disable:this type_body_length

    @MainActor
    class AnchorsDSLTestsBase {
        var superview: UIView = UIView()
        var subview: UIView = UIView()
        var siblingview: UIView = UIView()
        var layoutGuied: UILayoutGuide = UILayoutGuide()

        var activation: Activation?

        var tags: [UIView: String] {
            [superview: "superview", subview: "subview", siblingview: "siblingview"]
        }

        init() {
            superview = UIView()
            subview = UIView()
            siblingview = UIView()
        }
    }

    final class ActivationTests: AnchorsDSLTestsBase {

        @Test
        func active() {
            @LayoutBuilder
            var layout: some Layout {
                superview.sl.sublayout {
                    subview.sl.anchors {
                        Anchors.cap.equalToSuper()
                        Anchors.bottom.equalTo(siblingview, attribute: .top)
                    }
                    siblingview.sl.anchors {
                        Anchors.width.equalTo(constant: 37)
                        Anchors.height.equalToSuper().multiplier(0.5)
                        Anchors.centerX.bottom
                    }
                }
            }

            activation = layout.active()

            let expectedSuperViewConstraints = [
                NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: 0),

                NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1, constant: 0),

                NSLayoutConstraint(item: siblingview, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0.5, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: 0)
            ]

            let expectedSiblingviewConstraints = [
                NSLayoutConstraint(item: siblingview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 37)
            ]

            #expect(hasSameElements(superview.constraints, expectedSuperViewConstraints, tags))
            #expect(subview.constraints.isEmpty)
            #expect(hasSameElements(siblingview.constraints, expectedSiblingviewConstraints, tags))
        }

        @Test(.tags(.deactivation))
        func deactive() async throws {

            @LayoutBuilder
            var layout: some Layout {
                superview.sl.sublayout {
                    subview.sl.anchors {
                        Anchors.cap.equalToSuper()
                        Anchors.bottom.equalTo(siblingview, attribute: .top)
                    }
                    siblingview.sl.anchors {
                        Anchors.width.equalTo(constant: 37)
                        Anchors.height.equalToSuper().multiplier(0.5)
                        Anchors.centerX.bottom
                    }
                }
            }

            func activate() async {
                activation = layout.active()
            }

            func deactivate() async {
                activation?.deactive()
            }

            func expectation() async {
                #expect(superview.constraints.isEmpty)
                #expect(subview.constraints.isEmpty)
                #expect(siblingview.constraints.isEmpty)
            }

            await activate()
            await deactivate()

            // TODO: deinit of Activation using Task for removeSubviews and removeConstraints, so check need to be update after Task of deinit
            // TODO: Replace sleep
            try await Task.sleep(nanoseconds: 1000)
            await expectation()
        }

        @Test
        func finalActive() async {
            @LayoutBuilder
            var layout: some Layout {
                superview.sl.sublayout {
                    subview.sl.anchors {
                        Anchors.cap.equalToSuper()
                        Anchors.bottom.equalTo(siblingview, attribute: .top)
                    }
                    siblingview.sl.anchors {
                        Anchors.width.equalTo(constant: 37)
                        Anchors.height.equalToSuper().multiplier(0.5)
                        Anchors.centerX.bottom
                    }
                }
            }

            layout.finalActive()

            let expectedSuperViewConstraints = [
                NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: 0),

                NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1, constant: 0),

                NSLayoutConstraint(item: siblingview, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0.5, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: 0)
            ]

            let expectedSiblingviewConstraints = [
                NSLayoutConstraint(item: siblingview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 37)
            ]

            #expect(hasSameElements(superview.constraints, expectedSuperViewConstraints, tags))
            #expect(subview.constraints.isEmpty)
            #expect(hasSameElements(siblingview.constraints, expectedSiblingviewConstraints, tags))
        }

    }

    final class UpdateLayoutTests: AnchorsDSLTestsBase {
        let bottomToSiblingTopIdentifier = "bottom-to-sibling-top"

        var flag = true

        var layout: some Layout {
            superview.sl.sublayout {
                subview.sl.anchors {
                    if flag {
                        Anchors.cap.equalToSuper()
                        Anchors.bottom.equalTo(siblingview, attribute: .top).identifier(bottomToSiblingTopIdentifier)
                    } else {
                        Anchors.size.equalTo(width: 37, height: 19)
                        Anchors.top.equalToSuper(constant: 10)
                    }
                }
                siblingview.sl.anchors {
                    Anchors.width.equalTo(constant: 37)
                    Anchors.height.equalToSuper().multiplier(0.5)
                    Anchors.centerX.bottom
                }
            }
        }

        @Test
        func active() {
            activation = layout.active()

            let bottomToSiblingTop = NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1, constant: 0)
            bottomToSiblingTop.identifier = bottomToSiblingTopIdentifier

            let expectedSuperViewConstraints = [
                NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: 0),

                bottomToSiblingTop,

                NSLayoutConstraint(item: siblingview, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0.5, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: 0)
            ]

            let expectedSiblingviewConstraints = [
                NSLayoutConstraint(item: siblingview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 37)
            ]

            #expect(hasSameElements(superview.constraints, expectedSuperViewConstraints, tags))
            #expect(subview.constraints.isEmpty)
            #expect(hasSameElements(siblingview.constraints, expectedSiblingviewConstraints, tags))
        }

        @Test
        func updateWithoutChange() {
            active()
            activation = layout.update(fromActivation: activation!)

            let bottomToSiblingTop = NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1, constant: 0)
            bottomToSiblingTop.identifier = bottomToSiblingTopIdentifier

            let expectedSuperViewConstraints = [
                NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: 0),

                bottomToSiblingTop,

                NSLayoutConstraint(item: siblingview, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0.5, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: 0)
            ]

            let expectedSiblingviewConstraints = [
                NSLayoutConstraint(item: siblingview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 37)
            ]

            #expect(hasSameElements(superview.constraints, expectedSuperViewConstraints, tags))
            #expect(subview.constraints.isEmpty)
            #expect(hasSameElements(siblingview.constraints, expectedSiblingviewConstraints, tags))
        }

        @Test
        func updateAnchors() {
            updateWithoutChange()
            activation?.anchors("bottom-to-sibling-top").update(constant: -5, priority: .defaultLow)

            let bottomToSiblingTop = NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1, constant: -5)
            bottomToSiblingTop.priority = .defaultLow
            bottomToSiblingTop.identifier = bottomToSiblingTopIdentifier

            let expectedSuperViewConstraints = [
                NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: 0),

                bottomToSiblingTop,

                NSLayoutConstraint(item: siblingview, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0.5, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: 0)
            ]

            let expectedSiblingviewConstraints = [
                NSLayoutConstraint(item: siblingview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 37)
            ]

            #expect(hasSameElements(superview.constraints, expectedSuperViewConstraints, tags))
            #expect(subview.constraints.isEmpty)
            #expect(hasSameElements(siblingview.constraints, expectedSiblingviewConstraints, tags))
        }

        @Test
        func updateAgainAfterUpdateAnchors() {
            updateAnchors()
            activation = layout.update(fromActivation: activation!)

            let bottomToSiblingTop = NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1, constant: 0)
            bottomToSiblingTop.identifier = bottomToSiblingTopIdentifier

            let expectedSuperViewConstraints = [
                NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: 0),

                bottomToSiblingTop,

                NSLayoutConstraint(item: siblingview, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0.5, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: 0)
            ]

            let expectedSiblingviewConstraints = [
                NSLayoutConstraint(item: siblingview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 37)
            ]

            #expect(hasSameElements(superview.constraints, expectedSuperViewConstraints, tags))
            #expect(subview.constraints.isEmpty)
            #expect(hasSameElements(siblingview.constraints, expectedSiblingviewConstraints, tags))
        }


        @Test
        func updateWithChange() {
            updateWithoutChange()
            flag.toggle()

            activation = layout.update(fromActivation: activation!)

            let expectedSuperViewConstraints = [
                NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 10),

                NSLayoutConstraint(item: siblingview, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0.5, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: 0)
            ]

            let expectedSubviewConstraints = [
                NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 37),
                NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 19)
            ]

            let expectedSiblingviewConstraints = [
                NSLayoutConstraint(item: siblingview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 37)
            ]

            #expect(hasSameElements(superview.constraints, expectedSuperViewConstraints, tags))
            #expect(hasSameElements(subview.constraints, expectedSubviewConstraints, tags))
            #expect(hasSameElements(siblingview.constraints, expectedSiblingviewConstraints, tags))
        }

        @Test(.tags(.deactivation))
        func deactive() {
            updateWithChange()
            activation?.deactive()
            activation = nil

            #expect(superview.constraints.isEmpty)
            #expect(subview.constraints.isEmpty)
            #expect(siblingview.constraints.isEmpty)
        }
    }

    struct ConditionalSyntaxTests {
        final class IfTests: AnchorsDSLTestsBase {

            var flag = true

            @LayoutBuilder
            var layout: some Layout {
                superview.sl.sublayout {
                    subview.sl.anchors {
                        if flag {
                            Anchors.cap.equalToSuper()
                        } else {
                            Anchors.shoe.equalToSuper()
                        }
                    }
                }
            }

            @Test
            func ifTrue() {
                flag = true

                activation = layout.active()

                let expectedSuperviewConstraints = [
                    NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: 0)
                ]

                #expect(hasSameElements(superview.constraints, expectedSuperviewConstraints, tags))
                #expect(subview.constraints.isEmpty)
            }

            @Test
            func ifFalse() {
                flag = false
                activation = layout.active()

                let expectedSuperviewConstraints = [
                    NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: 0)
                ]

                #expect(hasSameElements(superview.constraints, expectedSuperviewConstraints, tags))
                #expect(subview.constraints.isEmpty)
            }
        }

        final class SwitchCaseTests: AnchorsDSLTestsBase {
            enum LayoutCase: Sendable {
                case allSides
                case centerAndSize
                case horizontalAndSize
            }

            var testCase: LayoutCase = .allSides

            @LayoutBuilder
            var layout: some Layout {
                superview.sl.sublayout {
                    subview.sl.anchors {
                        switch testCase {
                        case .allSides:
                            Anchors.allSides.equalToSuper()
                        case .centerAndSize:
                            Anchors.center.equalToSuper()
                            Anchors.size.equalTo(width: 11, height: 37)
                        case .horizontalAndSize:
                            Anchors.horizontal.equalToSuper()
                            Anchors.vertical.equalToSuper(inwardOffset: 11)
                        }
                    }
                }
            }

            @Test
            func caseAllSides() {
                self.testCase = .allSides

                activation = layout.active()

                let expectedSuperviewConstraints = [
                    NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0),
                    NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
                    NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
                    NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0.0)
                ]

                #expect(hasSameElements(superview.constraints, expectedSuperviewConstraints, tags))
                #expect(subview.constraints.isEmpty)
            }

            @Test
            func caseCenterAndSize() {
                self.testCase = .centerAndSize

                activation = layout.active()

                let expectedSuperviewConstraints = [
                    NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0),
                    NSLayoutConstraint(item: subview, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: 0.0)
                ]

                let expectedSubviewConstraints = [
                    NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 11.0),
                    NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 37.0)
                ]

                #expect(hasSameElements(superview.constraints, expectedSuperviewConstraints, tags))
                #expect(hasSameElements(subview.constraints, expectedSubviewConstraints, tags))
            }

            @Test
            func caseHorizontalAndSize() {
                self.testCase = .horizontalAndSize

                activation = layout.active()

                let expectedSuperviewConstraints = [
                    NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 11.0),
                    NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
                    NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
                    NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: -11.0)
                ]

                #expect(hasSameElements(superview.constraints, expectedSuperviewConstraints, tags))
                #expect(subview.constraints.isEmpty)
            }
        }

        final class OptionalTests: AnchorsDSLTestsBase {
            var optionalAnchors: Anchors?
            var optionalExpression: AnchorsExpression<AnchorsDimensionAttribute>?
            var optionalMixedExpression: AnchorsMixedExpression?

            @LayoutBuilder
            var layout: some Layout {
                superview.sl.sublayout {
                    subview.sl.anchors {
                        optionalAnchors
                        optionalExpression
                        optionalMixedExpression
                    }
                }
            }

            @Test
            func anchorIsNil() {
                optionalAnchors = nil
                optionalExpression = nil
                optionalMixedExpression = nil

                activation = layout.active()

                #expect(superview.constraints.isEmpty)
                #expect(subview.constraints.isEmpty)
            }

            @Test
            func anchorIsSome() {
                optionalAnchors = Anchors.center.equalToSuper()
                optionalExpression = Anchors.width.height
                optionalMixedExpression = Anchors.leading.top

                activation = layout.active()

                let expectedSubviewConstraints = [
                    NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0),
                    NSLayoutConstraint(item: subview, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: 0),

                    NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 1.0, constant: 0),
                    NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 1.0, constant: 0),

                    NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0),
                    NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0)
                ]

                #expect(hasSameElements(superview.constraints, expectedSubviewConstraints, tags))
            }
        }

        final class ForInTest: AnchorsDSLTestsBase {
            @Test
            func forIn() {
                let xAxis = [
                    Anchors.leading,
                    Anchors.trailing
                ]
                let yAxis = [
                    Anchors.top,
                    Anchors.bottom
                ]

                @LayoutBuilder
                var layout: some Layout {
                    superview.sl.sublayout {
                        subview.sl.anchors {
                            for anchors in xAxis {
                                anchors
                            }
                            for anchors in yAxis {
                                anchors
                            }
                        }
                    }
                }

                activation = layout.active()

                let expectedSubviewConstraints = [
                    NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0),
                    NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0),
                    NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0),
                    NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0)
                ]

                #expect(hasSameElements(superview.constraints, expectedSubviewConstraints, tags))
                #expect(subview.constraints.isEmpty)
            }
        }
    }

    final class ComplexUsageTests: AnchorsDSLTestsBase {
        @Test
        func omitable() {
            var layout: some Layout {
                superview.sl.sublayout {
                    subview.sl.anchors {
                        Anchors.top
                        Anchors.bottom
                        Anchors.horizontal
                    }
                    siblingview.sl.anchors {
                        Anchors.center
                        Anchors.size
                        Anchors.allSides
                    }
                }
            }

            layout.finalActive()

            let expectedConstraints = [
                NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0),

                NSLayoutConstraint(item: siblingview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 1.0, constant: 0),

                NSLayoutConstraint(item: siblingview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0)
            ]

            #expect(hasSameElements(superview.constraints, expectedConstraints, tags))
            #expect(subview.constraints.isEmpty)
            #expect(siblingview.constraints.isEmpty)
        }

        @Test
        func constraintUpdaterSurvivesLayoutChanges() throws {
            var flag = true

            var layout: some Layout {
                superview.sl.sublayout {
                    subview.sl.anchors {
                        Anchors.width.equalTo(constant: 10) 
                        if flag {
                            Anchors.center.equalToSuper().identifier("center-anchor")
                        }
                    }
                }
            }

            activation = layout.active()
            let updater = try #require(activation?.anchors("center-anchor", attribute: .centerX))

            // Update while anchors are active; both center constraints should change.
            updater.update(constant: 7)

            var centerXConstraint = NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 7)
            centerXConstraint.identifier = "center-anchor"

            let centerYConstraint = NSLayoutConstraint(item: subview, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1, constant: 0)
            centerYConstraint.identifier = "center-anchor"

            let expectedSuperViewConstraintsAfterUpdate = [
                centerXConstraint,
                centerYConstraint,
            ]

            let expectedSubviewConstraints = [
                NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 10)
            ]

            #expect(hasSameElements(superview.constraints, expectedSuperViewConstraintsAfterUpdate, tags))
            #expect(hasSameElements(subview.constraints, expectedSubviewConstraints, tags))

            // Disable the flagged anchors; updater should now find nothing to mutate.
            flag = false
            activation = layout.update(fromActivation: activation!)

            #expect(superview.constraints.isEmpty)
            #expect(hasSameElements(subview.constraints, expectedSubviewConstraints, tags))

            updater.update(constant: 7)

            #expect(superview.constraints.isEmpty)
            #expect(hasSameElements(subview.constraints, expectedSubviewConstraints, tags))

            // Re-enable the anchors; updater is once again able to mutate the revived constraints.
            flag = true
            activation = layout.update(fromActivation: activation!)

            centerXConstraint = NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 0)
            centerXConstraint.identifier = "center-anchor"

            let expectedSuperViewConstraintsWhenFlagOn = [
                centerXConstraint,
                centerYConstraint,
            ]

            #expect(hasSameElements(superview.constraints, expectedSuperViewConstraintsWhenFlagOn, tags))
            #expect(hasSameElements(subview.constraints, expectedSubviewConstraints, tags))

            updater.update(constant: 7)

            centerXConstraint = NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 7)
            centerXConstraint.identifier = "center-anchor"

            let expectedSuperViewConstraintsAfterUpdateAgain = [
                centerXConstraint,
                centerYConstraint,
            ]

            #expect(hasSameElements(superview.constraints, expectedSuperViewConstraintsAfterUpdateAgain, tags))
            #expect(hasSameElements(subview.constraints, expectedSubviewConstraints, tags))
        }

        @Test
        func identifier() {
            let identifyingView = UIView()

            @LayoutBuilder
            var layout: some Layout {
                superview.sl.sublayout {
                    subview.sl.anchors {
                        Anchors.cap.equalToSuper()
                        Anchors.bottom.equalTo("someIdentifier", attribute: .top)
                    }
                    identifyingView.sl.identifying("someIdentifier").sl.anchors {
                        Anchors.width.equalTo(constant: 37)
                        Anchors.height.equalToSuper().multiplier(0.5)
                        Anchors.centerX
                        Anchors.bottom
                    }
                }
            }

            layout.finalActive()

            let expectedSuperViewConstraints = [
                NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0),

                NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: identifyingView, attribute: .top, multiplier: 1.0, constant: 0),

                NSLayoutConstraint(item: identifyingView, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0.5, constant: 0),
                NSLayoutConstraint(item: identifyingView, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: identifyingView, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0)
            ]

            let expectedIdentifyingViewConstraints = [
                NSLayoutConstraint(item: identifyingView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 37)
            ]

            #expect(hasSameElements(superview.constraints, expectedSuperViewConstraints, tags))
            #expect(subview.constraints.isEmpty)
            #expect(hasSameElements(identifyingView.constraints, expectedIdentifyingViewConstraints, tags))
        }

        @Test
        func layoutGuide() {
            @LayoutBuilder
            var layout: some Layout {
                superview.sl.sublayout {

                    subview.sl.anchors {
                        Anchors.cap.equalToSuper()
                        Anchors.bottom.equalTo(layoutGuied, attribute: .top)
                    }

                    layoutGuied.sl.anchors {
                        Anchors.width.equalTo(constant: 37)
                        Anchors.height.equalToSuper().multiplier(0.5)
                        Anchors.centerX.bottom
                    }

                    siblingview.sl.anchors {
                        Anchors.allSides.equalTo(layoutGuied)
                    }
                }
            }

            activation = layout.active()

            let expectedSuperViewConstraints = [
                NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: 0),

                NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: layoutGuied, attribute: .top, multiplier: 1, constant: 0),

                NSLayoutConstraint(item: layoutGuied, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0.5, constant: 0),
                NSLayoutConstraint(item: layoutGuied, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: layoutGuied, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: layoutGuied, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 37),

                NSLayoutConstraint(item: siblingview, attribute: .leading, relatedBy: .equal, toItem: layoutGuied, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .top, relatedBy: .equal, toItem: layoutGuied, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .trailing, relatedBy: .equal, toItem: layoutGuied, attribute: .trailing, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .bottom, relatedBy: .equal, toItem: layoutGuied, attribute: .bottom, multiplier: 1, constant: 0),
            ]

            #expect(hasSameElements(superview.constraints, expectedSuperViewConstraints, tags))
            #expect(subview.constraints.isEmpty)
        }

        @Test
        func duplicateAnchorExpression() {
            @LayoutBuilder
            var layout: some Layout {
                superview.sl.sublayout {
                    subview.sl.anchors {
                        Anchors.cap.equalToSuper()
                        Anchors.leading.trailing
                        Anchors.top
                        Anchors.bottom.equalTo(siblingview, attribute: .top)
                    }
                    siblingview.sl.anchors {
                        Anchors.width.equalTo(constant: 37)
                        Anchors.height.equalTo(constant: 37)
                        Anchors.size.equalTo(width: 37, height: 37)
                        Anchors.centerX
                        Anchors.bottom
                        Anchors.centerX
                        Anchors.bottom
                    }
                }
            }

            layout.finalActive()

            let expectedSuperViewConstraints = [
                NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0),

                NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: 0),

                NSLayoutConstraint(item: siblingview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0)
            ]

            let expectedSiblingviewViewConstraints = [
                NSLayoutConstraint(item: siblingview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 37),
                NSLayoutConstraint(item: siblingview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 37)
            ]

            #expect(hasSameElements(superview.constraints, expectedSuperViewConstraints, tags))
            #expect(subview.constraints.isEmpty)
            #expect(hasSameElements(siblingview.constraints, expectedSiblingviewViewConstraints, tags))
        }

        @Test
        func duplicateAnchorsBuilder() {
            @LayoutBuilder
            var layout: some Layout {
                superview.sl.sublayout {
                    subview.sl.anchors {
                        Anchors.cap.equalToSuper()
                    }.anchors {
                        Anchors.bottom.equalTo(siblingview, attribute: .top)
                    }
                    siblingview.sl.anchors {
                        Anchors.width.equalTo(constant: 37)
                    }.anchors {
                        Anchors.height.equalToSuper().multiplier(0.5)
                    }.anchors {
                        Anchors.centerX
                    }.anchors {
                        Anchors.bottom
                    }
                }
            }

            layout.finalActive()

            let expectedSuperViewConstraints = [
                NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0),

                NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: 0),

                NSLayoutConstraint(item: siblingview, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0.5, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0)
            ]

            let expectedSiblingviewConstraints = [
                NSLayoutConstraint(item: siblingview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 37)
            ]

            #expect(hasSameElements(superview.constraints, expectedSuperViewConstraints, tags))
            #expect(subview.constraints.isEmpty)
            #expect(hasSameElements(siblingview.constraints, expectedSiblingviewConstraints, tags))
        }

        @Test
        func multipleFirstLevelLayouts() {
            @LayoutBuilder
            var layout: some Layout {
                superview.sl.sublayout {
                    subview.sl.anchors {
                        Anchors.cap.equalToSuper()

                    }
                    siblingview.sl.anchors {
                        Anchors.height.equalToSuper().multiplier(0.5)
                        Anchors.centerX
                        Anchors.bottom
                    }
                }

                subview.sl.anchors {
                    Anchors.bottom.equalTo(siblingview, attribute: .top)
                }

                siblingview.sl.anchors {
                    Anchors.width.equalTo(constant: 37)
                }
            }

            layout.finalActive()

            let expectedSuperViewConstraints = [
                NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0),

                NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: 0),

                NSLayoutConstraint(item: siblingview, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0.5, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: siblingview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0)
            ]

            let expectedSiblingviewConstraints = [
                NSLayoutConstraint(item: siblingview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 37)
            ]

            #expect(hasSameElements(superview.constraints, expectedSuperViewConstraints, tags))
            #expect(subview.constraints.isEmpty)
            #expect(hasSameElements(siblingview.constraints, expectedSiblingviewConstraints, tags))
        }

        @Test
        func forceLayoutAndCheckFrame() {
            let width: CGFloat = 300
            let height: CGFloat = 300
            let siblingWidth: CGFloat = 38
            let siblingHeightMultiplier: CGFloat = 0.5

            let window = UIWindow(frame: .init(x: .zero, y: .zero, width: width, height: height))

            @LayoutBuilder
            var layout: some Layout {
                window.sl.sublayout {
                    superview.sl.sublayout {
                        subview.sl.anchors {
                            Anchors.cap.equalToSuper()
                            Anchors.bottom.equalTo(siblingview, attribute: .top)
                        }
                        siblingview.sl.anchors {
                            Anchors.width.equalTo(constant: siblingWidth)
                            Anchors.height.equalToSuper().multiplier(siblingHeightMultiplier)
                            Anchors.centerX
                            Anchors.bottom
                        }
                    }.anchors {
                        Anchors.allSides.equalToSuper()
                    }
                }
            }

            layout.finalActive(forceLayout: true)

            #expect(superview.frame == .init(x: .zero, y: .zero, width: width, height: height))
            #expect(subview.frame == .init(x: .zero, y: .zero, width: width, height: height * (1 - siblingHeightMultiplier)))
            #expect(siblingview.frame == .init(x: (width - siblingWidth) / 2, y: height * (1 - siblingHeightMultiplier), width: siblingWidth, height: height * siblingHeightMultiplier))
        }
    }
}
