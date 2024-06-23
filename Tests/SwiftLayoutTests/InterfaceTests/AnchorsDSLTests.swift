import Testing
@testable import SwiftLayout
import UIKit

extension Tag {
    @Tag
    static var deactivation: Self
}

/// test cases for constraint DSL syntax
struct AnchorsDSLTests {
    
    @MainActor
    class AnchorsDSLTestsBase {
        var superview: UIView = UIView()
        var subview: UIView = UIView()
        var siblingview: UIView = UIView()
        
        
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
        
        var activation: Set<Activation> = []
        
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
            
            layout.active().store(&activation)
            
            let expected = TestAnchors(first: subview, second: superview) {
                Anchors.cap.equalToSuper()
            }.constraints
            + TestAnchors(first: subview, second: siblingview) {
                Anchors.bottom.equalTo(siblingview, attribute: .top)
            }.constraints
            + TestAnchors(first: siblingview, second: superview) {
                Anchors.height.equalToSuper().multiplier(0.5)
                Anchors.centerX.bottom
            }.constraints
            #expect(isEqual(superview.constraints, expected, tags))
            #expect(subview.constraints.testDescriptions(tags).isEmpty)
            #expect(isEqual(siblingview.constraints, TestAnchors(first: siblingview) {
                Anchors.width.equalTo(constant: 37.0)
            }.constraints, tags))
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
            
            layout.active().store(&activation)
            
            activation = []
            
            // TODO: deinit of Activation using Task for removeSubviews and removeConstraints, so check need to be update after Task of deinit
            await MainActor.run {
                #expect(superview.constraints.testDescriptions(tags).isEmpty)
                #expect(subview.constraints.testDescriptions(tags).isEmpty)
                #expect(siblingview.constraints.testDescriptions(tags).isEmpty)
            }
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
            
            let expected = TestAnchors(first: subview, second: superview) {
                Anchors.cap.equalToSuper()
            }.constraints
            + TestAnchors(first: subview, second: siblingview) {
                Anchors.bottom.equalToSuper(attribute: .top)
            }.constraints
            + TestAnchors(first: siblingview, second: superview) {
                Anchors.height.equalToSuper().multiplier(0.5)
                Anchors.centerX.bottom
            }.constraints
            #expect(isEqual(superview.constraints, expected, tags))
            #expect(subview.constraints.testDescriptions(tags).isEmpty)
            #expect(isEqual(siblingview.constraints, TestAnchors(first: siblingview, anchors: {
                Anchors.width.equalTo(constant: 37.0)
            }).constraints, tags))
        }
        
    }
    
    final class UpdateLayoutTests: AnchorsDSLTestsBase, Layoutable {
        
        var flag = true
        
        var activation: Activation?
        
        var layout: some Layout {
            superview.sl.sublayout {
                subview.sl.anchors {
                    if flag {
                        Anchors.cap.equalToSuper()
                        Anchors.bottom.equalTo(siblingview, attribute: .top)
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
           
            #expect(isEqual(superview.constraints, tags) {
                TestAnchors(first: subview, second: superview) {
                    Anchors.cap.equalToSuper()
                }
                TestAnchors(first: subview, second: siblingview) {
                    Anchors.bottom.equalToSuper(attribute: .top)
                }
                TestAnchors(first: siblingview, second: superview) {
                    Anchors.height.equalToSuper().multiplier(0.5)
                    Anchors.centerX.bottom
                }
            })
            #expect(subview.constraints.testDescriptions(tags).isEmpty)
            #expect(isEqual(siblingview.constraints, tags) {
                TestAnchors(first: siblingview) {
                    Anchors.width.equalTo(constant: 37.0)
                }
            })
        }
        
        @Test
        func updateWithoutChange() {
            active()
            activation = layout.update(fromActivation: activation!)
            
            #expect(isEqual(superview.constraints, tags) {
                TestAnchors(first: subview, second: superview) {
                    Anchors.cap.equalToSuper()
                }
                TestAnchors(first: subview, second: siblingview) {
                    Anchors.bottom.equalToSuper(attribute: .top)
                }
                TestAnchors(first: siblingview, second: superview) {
                    Anchors.height.equalToSuper().multiplier(0.5)
                    Anchors.centerX.bottom
                }
            })
            #expect(subview.constraints.testDescriptions(tags).isEmpty)
            #expect(isEqual(siblingview.constraints, tags) {
                TestAnchors(first: siblingview) {
                    Anchors.width.equalTo(constant: 37)
                }
            })
            #expect(isEqual(siblingview.constraints, [
                NSLayoutConstraint(item: siblingview, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 37.0),
            ], tags))
        }
        
        @Test
        func updateWithChange() {
            updateWithoutChange()
            flag.toggle()
            
            activation = layout.update(fromActivation: activation!)
            
            #expect(isEqual(superview.constraints, tags) {
                TestAnchors(first: subview, second: superview) {
                    Anchors.top.equalToSuper(constant: 10)
                }
                TestAnchors(first: siblingview, second: superview) {
                    Anchors.height.equalToSuper().multiplier(0.5)
                    Anchors.centerX.bottom
                }
            })
            #expect(isEqual(subview.constraints, tags) {
                TestAnchors(first: subview) {
                    Anchors.size.equalTo(width: 37, height: 19)
                }
            })
            #expect(isEqual(siblingview.constraints, tags) {
                TestAnchors(first: siblingview) {
                    Anchors.width.equalTo(constant: 37)
                }
            })
        }
        
        @Test(.tags(.deactivation))
        func deactive() {
            updateWithChange()
            activation?.deactive()
            activation = nil
            
            #expect(superview.constraints.testDescriptions(tags).isEmpty)
            #expect(subview.constraints.testDescriptions(tags).isEmpty)
            #expect(siblingview.constraints.testDescriptions(tags).isEmpty)
        }
    }
    
    final class ConditionalSyntaxTests {
        final class IFTests: AnchorsDSLTestsBase {
            
            var flag = true
            
            var activation: Set<Activation> = []
            
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
            func `true`() {
                flag = true
                
                layout.active().store(&activation)
                
                #expect(isEqual(superview.constraints, tags) {
                    TestAnchors(first: subview, second: superview) {
                        Anchors.cap.equalToSuper()
                    }
                })
                #expect(subview.constraints.testDescriptions(tags).isEmpty)
            }
            
            @Test
            func `false`() {
                flag = false
                layout.active().store(&activation)
                
                #expect(isEqual(superview.constraints, tags) {
                    TestAnchors(first: subview, second: superview) {
                        Anchors.shoe.equalToSuper()
                    }
                })
                #expect(subview.constraints.testDescriptions(tags).isEmpty)
            }
        }
        
        final class SwitchCaseTests: AnchorsDSLTestsBase {
            enum LayoutCase: Sendable {
                case allSides
                case centerAndSize
                case horizontalAndSize
            }
            
            var testCase: LayoutCase = .allSides
            
            var activation: Set<Activation> = []
            
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
            
            @Test("layout case", arguments: [LayoutCase.allSides, .centerAndSize, .horizontalAndSize])
            func switchCase(_ testCase: LayoutCase) {
                self.testCase = testCase
                switch testCase {
                case .allSides:
                    layout.active().store(&activation)
                    
                    #expect(isEqual(superview.constraints, [
                        NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0),
                        NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
                        NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
                        NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0.0),
                    ], tags))
                    #expect(subview.constraints.testDescriptions(tags).isEmpty)
                case .centerAndSize:
                    layout.active().store(&activation)
                    
                    #expect(isEqual(superview.constraints, [
                        NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0),
                        NSLayoutConstraint(item: subview, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: 0.0),
                    ], tags))
                    #expect(isEqual(subview.constraints, [
                        NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 11.0),
                        NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 37.0),
                    ], tags))
                case .horizontalAndSize:
                    layout.active().store(&activation)
                    
                    #expect(isEqual(superview.constraints, [
                        NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 11.0),
                        NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
                        NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
                        NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: -11.0),
                    ], tags))
                    #expect(subview.constraints.testDescriptions(tags).isEmpty)
                }
            }
            
        }
        
        final class OptionalTests: AnchorsDSLTestsBase {
            var optionalAnchors: Anchors?
            var optionalExpression: AnchorsExpression<AnchorsDimensionAttribute>?
            var optionalMixedExpression: AnchorsMixedExpression?
            
            var activation: Set<Activation> = []
            
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
            
            @Test("is nil")
            func isNil() {
                optionalAnchors = nil
                optionalExpression = nil
                optionalMixedExpression = nil
                
                layout.active().store(&activation)
                
                #expect(superview.constraints.testDescriptions(tags).isEmpty)
                #expect(subview.constraints.testDescriptions(tags).isEmpty)
            }
            
            @Test("is optional")
            func isOptional() {
                optionalAnchors = Anchors.center.equalToSuper()
                optionalExpression = Anchors.width.height
                optionalMixedExpression = Anchors.leading.top

                layout.active().store(&activation)
                
                #expect(isEqual(superview.constraints, tags) {
                    TestAnchors(first: subview, second: superview) {
                        Anchors.center
                        Anchors.width.height
                        Anchors.leading
                        Anchors.top
                    }
                })
            }
            
            @Test("for in")
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
                
                layout.active().store(&activation)

                #expect(isEqual(superview.constraints, tags) {
                    TestAnchors(first: subview, second: superview) {
                        Anchors.allSides.equalToSuper()
                    }
                })
                #expect(subview.constraints.testDescriptions(tags).isEmpty)
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

            #expect(isEqual(superview.constraints, tags) {
                TestAnchors(first: subview, second: superview) {
                    Anchors.top.equalToSuper()
                    Anchors.bottom.equalToSuper()
                    Anchors.horizontal.equalToSuper()
                }
                TestAnchors(first: siblingview, second: superview) {
                    Anchors.center.equalToSuper()
                    Anchors.size.equalToSuper()
                    Anchors.allSides.equalToSuper()
                }
            })
            #expect(subview.constraints.testDescriptions(tags).isEmpty)
            #expect(siblingview.constraints.testDescriptions(tags).isEmpty)
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
            
            #expect(isEqual(superview.constraints, tags) {
                TestAnchors(first: subview, second: superview) {
                    Anchors.cap.equalToSuper()
                }
                TestAnchors(first: subview, second: identifyingView) {
                    Anchors.bottom.equalTo(identifyingView, attribute: .top)
                }
                TestAnchors(first: identifyingView, second: superview) {
                    Anchors.height.equalToSuper().multiplier(0.5)
                    Anchors.centerX
                    Anchors.bottom
                }
            })
            #expect(subview.constraints.testDescriptions(tags).isEmpty)
            #expect(isEqual(identifyingView.constraints, tags) {
                TestAnchors(first: identifyingView) {
                    Anchors.width.equalTo(constant: 37)
                }
            })
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
            
            #expect(isEqual(superview.constraints, tags) {
                TestAnchors(first: subview, second: superview) {
                    Anchors.cap.equalToSuper()
                }
                TestAnchors(first: subview, second: siblingview) {
                    Anchors.bottom.equalToSuper(attribute: .top)
                }
                TestAnchors(first: siblingview, second: superview) {
                    Anchors.centerX
                    Anchors.bottom
                }
            })
            #expect(subview.constraints.testDescriptions(tags).isEmpty)
            #expect(isEqual(siblingview.constraints, tags) {
                TestAnchors(first: siblingview) {
                    Anchors.size.equalTo(width: 37, height: 37)
                }
            })
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
            
            #expect(isEqual(superview.constraints, tags) {
                TestAnchors(first: subview, second: superview) {
                    Anchors.cap.equalToSuper()
                }
                TestAnchors(first: subview, second: siblingview) {
                    Anchors.bottom.equalToSuper(attribute: .top)
                }
                TestAnchors(first: siblingview, second: superview) {
                    Anchors.height.equalToSuper().multiplier(0.5)
                    Anchors.centerX
                    Anchors.bottom
                }
            })
            #expect(subview.constraints.testDescriptions(tags).isEmpty)
            
            #expect(isEqual(siblingview.constraints, tags) {
                TestAnchors(first: siblingview) {
                    Anchors.width.equalTo(constant: 37)
                }
            })
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
            
            #expect(isEqual(superview.constraints, tags) {
                TestAnchors(first: subview, second: superview) {
                    Anchors.cap.equalToSuper()
                }
                TestAnchors(first: subview, second: siblingview) {
                    Anchors.bottom.equalToSuper(attribute: .top)
                }
                TestAnchors(first: siblingview, second: superview) {
                    Anchors.height.equalToSuper().multiplier(0.5)
                    Anchors.centerX
                    Anchors.bottom
                }
            })
            #expect(subview.constraints.testDescriptions(tags).isEmpty)
            #expect(isEqual(siblingview.constraints, tags) {
                TestAnchors(first: siblingview) {
                    Anchors.width.equalTo(constant: 37)
                }
            })
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
