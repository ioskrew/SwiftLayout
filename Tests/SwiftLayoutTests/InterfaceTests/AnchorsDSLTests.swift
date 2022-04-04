import XCTest
import SwiftLayout

/// test cases for constraint DSL syntax
final class AnchorsDSLTests: XCTestCase {
    var superview: UIView = UIView()
    var subview: UIView = UIView()
    var siblingview: UIView = UIView()
    
    var activation: Set<Activation> = []
    
    var tags: [UIView: String] {
        [superview: "superview", subview: "subview", siblingview: "siblingview"]
    }
    
    override func setUp() {
        superview = UIView()
        subview = UIView()
        siblingview = UIView()
        continueAfterFailure = false
    }
    
    override func tearDown() {
        activation = []
    }
}

// MARK: - activation
extension AnchorsDSLTests {
    func testActive() {
        @LayoutBuilder
        var layout: some Layout {
            superview {
                subview.anchors {
                    Anchors.cap()
                    Anchors.bottom.equalTo(siblingview, attribute: .top)
                }
                siblingview.anchors {
                    Anchors.width.equalTo(constant: 37)
                    Anchors.height.equalToSuper().multiplier(0.5)
                    Anchors.centerX
                    Anchors.bottom
                }
            }
        }
        
        layout.active().store(&activation)
        
        SLTAssertConstraintsEqual(superview.constraints, tags: tags) {
            TestAnchors(first: subview, second: superview) {
                Anchors.cap()
            }
            TestAnchors(first: subview, second: siblingview) {
                Anchors.bottom.equalTo(siblingview, attribute: .top)
            }
            TestAnchors(first: siblingview, second: superview) {
                Anchors.height.equalToSuper().multiplier(0.5)
                Anchors.centerX
                Anchors.bottom
            }
        }
        SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
        SLTAssertConstraintsEqual(siblingview.constraints, tags: tags) {
            TestAnchors(first: siblingview) {
                Anchors.width.equalTo(constant: 37.0)
            }
        }
    }
    
    func testDeactive() {
        @LayoutBuilder
        var layout: some Layout {
            superview {
                subview.anchors {
                    Anchors.cap()
                    Anchors.bottom.equalTo(siblingview, attribute: .top)
                }
                siblingview.anchors {
                    Anchors.width.equalTo(constant: 37)
                    Anchors.height.equalToSuper().multiplier(0.5)
                    Anchors.centerX
                    Anchors.bottom
                }
            }
        }
        
        layout.active().store(&activation)
        
        activation = []
        
        SLTAssertConstraintsIsEmpty(superview.constraints, tags: tags)
        SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
        SLTAssertConstraintsIsEmpty(siblingview.constraints, tags: tags)
    }
    
    func testFinalActive() {
        @LayoutBuilder
        var layout: some Layout {
            superview {
                subview.anchors {
                    Anchors.cap()
                    Anchors.bottom.equalTo(siblingview, attribute: .top)
                }
                siblingview.anchors {
                    Anchors.width.equalTo(constant: 37)
                    Anchors.height.equalToSuper().multiplier(0.5)
                    Anchors.centerX
                    Anchors.bottom
                }
            }
        }
        
        layout.finalActive()
        
        SLTAssertConstraintsEqual(superview.constraints, tags: tags) {
            TestAnchors(first: subview, second: superview) {
                Anchors.cap()
            }
            TestAnchors(first: subview, second: siblingview) {
                Anchors.bottom.equalToSuper(attribute: .top)
            }
            TestAnchors(first: siblingview, second: superview) {
                Anchors.height.equalToSuper().multiplier(0.5)
                Anchors.centerX
                Anchors.bottom
            }
        }
        SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
        SLTAssertConstraintsEqual(siblingview.constraints, tags: tags) {
            TestAnchors(first: siblingview) {
                Anchors.width.equalTo(constant: 37.0)
            }
        }
    }
    
    func testUpdateLayout() {
        var flag = true
        
        var activation: Activation?
        
        @LayoutBuilder
        var layout: some Layout {
            superview {
                subview.anchors {
                    if flag {
                        Anchors.cap()
                        Anchors.bottom.equalTo(siblingview, attribute: .top)
                    } else {
                        Anchors.size(width: 37, height: 19)
                        Anchors.top.equalToSuper(constant: 10)
                    }
                }
                siblingview.anchors {
                    Anchors.width.equalTo(constant: 37)
                    Anchors.height.equalToSuper().multiplier(0.5)
                    Anchors.centerX
                    Anchors.bottom
                }
            }
        }
        
        contextContinuous("active") {
            activation = layout.active()
            
            SLTAssertConstraintsEqual(superview.constraints, tags: tags) {
                TestAnchors(first: subview, second: superview) {
                    Anchors.cap()
                }
                TestAnchors(first: subview, second: siblingview) {
                    Anchors.bottom.equalToSuper(attribute: .top)
                }
                TestAnchors(first: siblingview, second: superview) {
                    Anchors.height.equalToSuper().multiplier(0.5)
                    Anchors.centerX
                    Anchors.bottom
                }
            }
            SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
            SLTAssertConstraintsEqual(siblingview.constraints, tags: tags) {
                TestAnchors(first: siblingview) {
                    Anchors.width.equalTo(constant: 37.0)
                }
            }
        }
        
        contextContinuous("update without change") {
            activation = layout.update(fromActivation: activation!)
            
            SLTAssertConstraintsEqual(superview.constraints, tags: tags) {
                TestAnchors(first: subview, second: superview) {
                    Anchors.cap()
                }
                TestAnchors(first: subview, second: siblingview) {
                    Anchors.bottom.equalToSuper(attribute: .top)
                }
                TestAnchors(first: siblingview, second: superview) {
                    Anchors.height.equalToSuper().multiplier(0.5)
                    Anchors.centerX
                    Anchors.bottom
                }
            }
            SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
            SLTAssertConstraintsEqual(siblingview.constraints, tags: tags) {
                TestAnchors(first: siblingview) {
                    Anchors.width.constant(37)
                }
            }
            assertConstrints(siblingview.constraints, [
                NSLayoutConstraint(item: siblingview, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 37.0),
            ])
        }
        
        contextContinuous("update with change") {
            flag.toggle()
            
            activation = layout.update(fromActivation: activation!)
            
            SLTAssertConstraintsEqual(superview.constraints, tags: tags) {
                TestAnchors(first: subview, second: superview) {
                    Anchors.top.constant(10)
                }
                TestAnchors(first: siblingview, second: superview) {
                    Anchors.height.multiplier(0.5)
                    Anchors.centerX
                    Anchors.bottom
                }
            }
            SLTAssertConstraintsEqual(subview.constraints, tags: tags) {
                TestAnchors(first: subview) {
                    Anchors.size(width: 37, height: 19)
                }
            }
            SLTAssertConstraintsEqual(siblingview.constraints, tags: tags) {
                TestAnchors(first: siblingview) {
                    Anchors.width.constant(37)
                }
            }
        }
        
        contextContinuous("deactive") {
            activation?.deactive()
            activation = nil
            
            SLTAssertConstraintsIsEmpty(superview.constraints, tags: tags)
            SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
            SLTAssertConstraintsIsEmpty(siblingview.constraints, tags: tags)
        }
    }
}

// MARK: - conditional syntax
extension AnchorsDSLTests {
    func testIf() {
        var flag = true
        
        @LayoutBuilder
        var layout: some Layout {
            superview {
                subview.anchors {
                    if flag {
                        Anchors.cap()
                    } else {
                        Anchors.shoe()
                    }
                }
            }
        }
        
        context("if true") {
            flag = true
            layout.active().store(&activation)
            
            SLTAssertConstraintsEqual(superview.constraints, tags: tags) {
                TestAnchors(first: subview, second: superview) {
                    Anchors.cap()
                }
            }
            SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
        }
        
        context("if false") {
            flag = false
            layout.active().store(&activation)
            
            SLTAssertConstraintsEqual(superview.constraints, tags: tags) {
                TestAnchors(first: subview, second: superview) {
                    Anchors.shoe()
                }
            }
            SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
        }
    }
    
    func testSwitchCase() {
        enum Test: String, CaseIterable {
            case first
            case second
            case third
        }
        
        @LayoutBuilder
        func layout(_ test: Test) -> some Layout {
            superview {
                subview.anchors {
                    switch test {
                    case .first:
                        Anchors.allSides()
                    case .second:
                        Anchors.center()
                        Anchors.size(width: 11, height: 37)
                    case .third:
                        Anchors.horizontal()
                        Anchors.vertical(offset: 11)
                    }
                }
            }
        }
        
        context("enum test first") {
            layout(.first).active().store(&activation)
            
            assertConstrints(superview.constraints, [
                NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            ])
            assertConstrints(subview.constraints, [])
        }
        
        context("enum test second") {
            layout(.second).active().store(&activation)
            
            assertConstrints(superview.constraints, [
                NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            ])
            assertConstrints(subview.constraints, [
                NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 11.0),
                NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 37.0),
            ])
        }
        
        context("enum test third") {
            layout(.third).active().store(&activation)
            
            assertConstrints(superview.constraints, [
                NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 11.0),
                NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: -11.0),
            ])
            assertConstrints(subview.constraints, [])
        }
    }
    
    func testOptional() {
        var optionalContainer: AnchorsContainer?
        var optionalExpression: AnchorsExpression<AnchorsDimensionAttribute>?
        
        @LayoutBuilder
        var layout: some Layout {
            superview {
                subview.anchors {
                    optionalContainer
                    optionalExpression
                }
            }
        }
        
        context("is nil") {
            optionalContainer = nil
            optionalExpression = nil
            
            layout.active().store(&activation)
            
            SLTAssertConstraintsIsEmpty(superview.constraints, tags: tags)
            SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
        }
        
        context("is optional") {
            optionalContainer = Anchors.center()
            optionalExpression = Anchors.width.height.equalTo(constant: 11)
            layout.active().store(&activation)
            
            SLTAssertConstraintsEqual(superview.constraints, tags: tags) {
                TestAnchors(first: subview, second: superview) {
                    Anchors.center()
                }
            }
            SLTAssertConstraintsEqual(subview.constraints, tags: tags) {
                TestAnchors(first: subview) {
                    Anchors.size(width: 11, height: 11)
                }
            }
        }
    }
    
    func testForIn() {
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
            superview {
                subview.anchors {
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

        SLTAssertConstraintsEqual(superview.constraints, firstView: subview, secondView: superview, tags: tags) {
            Anchors.allSides()
        }
        SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
    }
}

// MARK: - complex usage
extension AnchorsDSLTests {
    func testWithIdentifier() {
        let identifyingView = UIView()
        
        @LayoutBuilder
        var layout: some Layout {
            superview {
                subview.anchors {
                    Anchors.cap()
                    Anchors.bottom.equalTo("someIdentifier", attribute: .top)
                }
                identifyingView.identifying("someIdentifier").anchors {
                    Anchors.width.equalTo(constant: 37)
                    Anchors.height.equalToSuper().multiplier(0.5)
                    Anchors.centerX
                    Anchors.bottom
                }
            }
        }
        
        layout.finalActive()
        
        SLTAssertConstraintsEqual(superview.constraints, tags: tags) {
            TestAnchors(first: subview, second: superview) {
                Anchors.cap()
            }
            TestAnchors(first: subview, second: identifyingView) {
                Anchors.bottom.equalTo(identifyingView, attribute: .top)
            }
            TestAnchors(first: identifyingView, second: superview) {
                Anchors.height.equalToSuper().multiplier(0.5)
                Anchors.centerX
                Anchors.bottom
            }
        }
        SLTAssertConstraintsIsEmpty(subview.constraints)
        SLTAssertConstraintsEqual(identifyingView.constraints) {
            TestAnchors(first: identifyingView) {
                Anchors.width.constant(37.0)
            }
        }
    }
    
    func testDuplicateAnchorExpression() {
        @LayoutBuilder
        var layout: some Layout {
            superview {
                subview.anchors {
                    Anchors.cap()
                    Anchors.leading.trailing
                    Anchors.top
                    Anchors.bottom.equalTo(siblingview, attribute: .top)
                }
                siblingview.anchors {
                    Anchors.width.equalTo(constant: 37)
                    Anchors.height.equalTo(constant: 37)
                    Anchors.size(width: 37, height: 37)
                    Anchors.centerX
                    Anchors.bottom
                    Anchors.centerX
                    Anchors.bottom
                }
            }
        }
        
        layout.finalActive()
        
        SLTAssertConstraintsEqual(superview.constraints, tags: tags) {
            TestAnchors(first: subview, second: superview) {
                Anchors.cap()
            }
            TestAnchors(first: subview, second: siblingview) {
                Anchors.bottom.equalToSuper(attribute: .top)
            }
            TestAnchors(first: siblingview, second: superview) {
                Anchors.centerX
                Anchors.bottom
            }
        }
        SLTAssertConstraintsIsEmpty(subview.constraints)
        SLTAssertConstraintsEqual(siblingview.constraints) {
            TestAnchors(first: siblingview) {
                Anchors.size(width: 37, height: 37)
            }
        }
    }
    
    func testDuplicateAnchorsBuilder() {
        @LayoutBuilder
        var layout: some Layout {
            superview {
                subview.anchors {
                    Anchors.cap()
                }.anchors {
                    Anchors.bottom.equalTo(siblingview, attribute: .top)
                }
                siblingview.anchors {
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
        
        SLTAssertConstraintsEqual(superview.constraints, tags: tags) {
            TestAnchors(first: subview, second: superview) {
                Anchors.cap()
            }
            TestAnchors(first: subview, second: siblingview) {
                Anchors.bottom.equalToSuper(attribute: .top)
            }
            TestAnchors(first: siblingview, second: superview) {
                Anchors.height.equalToSuper().multiplier(0.5)
                Anchors.centerX
                Anchors.bottom
            }
        }
        SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
        
        SLTAssertConstraintsEqual(siblingview.constraints, firstView: siblingview, tags: tags) {
            Anchors.width.constant(37.0)
        }
    }
    
    func testMultipleFirstLevelLayouts() {
        @LayoutBuilder
        var layout: some Layout {
            superview {
                subview.anchors {
                    Anchors.cap()
                    
                }
                siblingview.anchors {
                    Anchors.height.equalToSuper().multiplier(0.5)
                    Anchors.centerX
                    Anchors.bottom
                }
            }
            
            subview.anchors {
                Anchors.bottom.equalTo(siblingview, attribute: .top)
            }
            
            siblingview.anchors {
                Anchors.width.equalTo(constant: 37)
            }
        }
        
        layout.finalActive()
        
        SLTAssertConstraintsEqual(superview.constraints, tags: tags) {
            TestAnchors(first: subview, second: superview) {
                Anchors.cap()
            }
            TestAnchors(first: subview, second: siblingview) {
                Anchors.bottom.equalToSuper(attribute: .top)
            }
            TestAnchors(first: siblingview, second: superview) {
                Anchors.height.equalToSuper().multiplier(0.5)
                Anchors.centerX
                Anchors.bottom
            }
        }
        SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
        SLTAssertConstraintsEqual(siblingview.constraints, firstView: siblingview) {
            Anchors.width.constant(37)
        }
    }
}

extension AnchorsDSLTests {
    func testForceLayoutAndCheckFrame() {
        let width: CGFloat = 300
        let height: CGFloat = 300
        let siblingWidth: CGFloat = 38
        let siblingHeightMultiplier: CGFloat = 0.5
        
        
        let window = UIWindow(frame: .init(x: .zero, y: .zero, width: width, height: height))
        
        @LayoutBuilder
        var layout: some Layout {
            window {
                superview {
                    subview.anchors {
                        Anchors.cap()
                        Anchors.bottom.equalTo(siblingview, attribute: .top)
                    }
                    siblingview.anchors {
                        Anchors.width.equalTo(constant: siblingWidth)
                        Anchors.height.equalToSuper().multiplier(siblingHeightMultiplier)
                        Anchors.centerX
                        Anchors.bottom
                    }
                }.anchors {
                    Anchors.allSides()
                }
            }
        }
        
        layout.finalActive(forceLayout: true)
        
        XCTAssertEqual(superview.frame, .init(x: .zero, y: .zero, width: width, height: height))
        XCTAssertEqual(subview.frame, .init(x: .zero, y: .zero, width: width, height: height * (1 - siblingHeightMultiplier)))
        XCTAssertEqual(siblingview.frame, .init(x: (width - siblingWidth) / 2, y: height * (1 - siblingHeightMultiplier), width: siblingWidth, height: height * siblingHeightMultiplier))
    }
}
