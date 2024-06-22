//import XCTest
//import SwiftLayout
//
///// test cases for constraint DSL syntax
//final class AnchorsDSLTests: XCTestCase {
//    var superview: UIView = UIView()
//    var subview: UIView = UIView()
//    var siblingview: UIView = UIView()
//    
//    var activation: Set<Activation> = []
//    
//    var tags: [UIView: String] {
//        [superview: "superview", subview: "subview", siblingview: "siblingview"]
//    }
//    
//    override func setUp() {
//        superview = UIView()
//        subview = UIView()
//        siblingview = UIView()
//        continueAfterFailure = false
//    }
//    
//    override func tearDown() {
//        activation = []
//    }
//}
//
//// MARK: - activation
//extension AnchorsDSLTests {
//    func testActive() {
//        @LayoutBuilder
//        var layout: some Layout {
//            superview.sl.sublayout {
//                subview.sl.anchors {
//                    Anchors.cap.equalToSuper()
//                    Anchors.bottom.equalTo(siblingview, attribute: .top)
//                }
//                siblingview.sl.anchors {
//                    Anchors.width.equalTo(constant: 37)
//                    Anchors.height.equalToSuper().multiplier(0.5)
//                    Anchors.centerX.bottom
//                }
//            }
//        }
//        
//        layout.active().store(&activation)
//        
//        SLTAssertConstraintsHasSameElements(superview.constraints, tags: tags) {
//            TestAnchors(first: subview, second: superview) {
//                Anchors.cap.equalToSuper()
//            }
//            TestAnchors(first: subview, second: siblingview) {
//                Anchors.bottom.equalTo(siblingview, attribute: .top)
//            }
//            TestAnchors(first: siblingview, second: superview) {
//                Anchors.height.equalToSuper().multiplier(0.5)
//                Anchors.centerX.bottom
//            }
//        }
//        SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
//        SLTAssertConstraintsHasSameElements(siblingview.constraints, tags: tags) {
//            TestAnchors(first: siblingview) {
//                Anchors.width.equalTo(constant: 37.0)
//            }
//        }
//    }
//    
//    func testDeactive() {
//        @LayoutBuilder
//        var layout: some Layout {
//            superview.sl.sublayout {
//                subview.sl.anchors {
//                    Anchors.cap.equalToSuper()
//                    Anchors.bottom.equalTo(siblingview, attribute: .top)
//                }
//                siblingview.sl.anchors {
//                    Anchors.width.equalTo(constant: 37)
//                    Anchors.height.equalToSuper().multiplier(0.5)
//                    Anchors.centerX.bottom
//                }
//            }
//        }
//        
//        layout.active().store(&activation)
//        
//        activation = []
//        
//        SLTAssertConstraintsIsEmpty(superview.constraints, tags: tags)
//        SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
//        SLTAssertConstraintsIsEmpty(siblingview.constraints, tags: tags)
//    }
//    
//    func testFinalActive() {
//        @LayoutBuilder
//        var layout: some Layout {
//            superview.sl.sublayout {
//                subview.sl.anchors {
//                    Anchors.cap.equalToSuper()
//                    Anchors.bottom.equalTo(siblingview, attribute: .top)
//                }
//                siblingview.sl.anchors {
//                    Anchors.width.equalTo(constant: 37)
//                    Anchors.height.equalToSuper().multiplier(0.5)
//                    Anchors.centerX.bottom
//                }
//            }
//        }
//        
//        layout.finalActive()
//        
//        SLTAssertConstraintsHasSameElements(superview.constraints, tags: tags) {
//            TestAnchors(first: subview, second: superview) {
//                Anchors.cap.equalToSuper()
//            }
//            TestAnchors(first: subview, second: siblingview) {
//                Anchors.bottom.equalToSuper(attribute: .top)
//            }
//            TestAnchors(first: siblingview, second: superview) {
//                Anchors.height.equalToSuper().multiplier(0.5)
//                Anchors.centerX.bottom
//            }
//        }
//        SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
//        SLTAssertConstraintsHasSameElements(siblingview.constraints, tags: tags) {
//            TestAnchors(first: siblingview) {
//                Anchors.width.equalTo(constant: 37.0)
//            }
//        }
//    }
//    
//    func testUpdateLayout() {
//        var flag = true
//        
//        var activation: Activation?
//        
//        @LayoutBuilder
//        var layout: some Layout {
//            superview.sl.sublayout {
//                subview.sl.anchors {
//                    if flag {
//                        Anchors.cap.equalToSuper()
//                        Anchors.bottom.equalTo(siblingview, attribute: .top)
//                    } else {
//                        Anchors.size.equalTo(width: 37, height: 19)
//                        Anchors.top.equalToSuper(constant: 10)
//                    }
//                }
//                siblingview.sl.anchors {
//                    Anchors.width.equalTo(constant: 37)
//                    Anchors.height.equalToSuper().multiplier(0.5)
//                    Anchors.centerX.bottom
//                }
//            }
//        }
//        
//        contextContinuous("active") {
//            activation = layout.active()
//            
//            SLTAssertConstraintsHasSameElements(superview.constraints, tags: tags) {
//                TestAnchors(first: subview, second: superview) {
//                    Anchors.cap.equalToSuper()
//                }
//                TestAnchors(first: subview, second: siblingview) {
//                    Anchors.bottom.equalToSuper(attribute: .top)
//                }
//                TestAnchors(first: siblingview, second: superview) {
//                    Anchors.height.equalToSuper().multiplier(0.5)
//                    Anchors.centerX.bottom
//                }
//            }
//            SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
//            SLTAssertConstraintsHasSameElements(siblingview.constraints, tags: tags) {
//                TestAnchors(first: siblingview) {
//                    Anchors.width.equalTo(constant: 37.0)
//                }
//            }
//        }
//        
//        contextContinuous("update without change") {
//            activation = layout.update(fromActivation: activation!)
//            
//            SLTAssertConstraintsHasSameElements(superview.constraints, tags: tags) {
//                TestAnchors(first: subview, second: superview) {
//                    Anchors.cap.equalToSuper()
//                }
//                TestAnchors(first: subview, second: siblingview) {
//                    Anchors.bottom.equalToSuper(attribute: .top)
//                }
//                TestAnchors(first: siblingview, second: superview) {
//                    Anchors.height.equalToSuper().multiplier(0.5)
//                    Anchors.centerX.bottom
//                }
//            }
//            SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
//            SLTAssertConstraintsHasSameElements(siblingview.constraints, tags: tags) {
//                TestAnchors(first: siblingview) {
//                    Anchors.width.equalTo(constant: 37)
//                }
//            }
//            SLTAssertConstraintsHasSameElements(siblingview.constraints, [
//                NSLayoutConstraint(item: siblingview, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 37.0),
//            ], tags: tags)
//        }
//        
//        contextContinuous("update with change") {
//            flag.toggle()
//            
//            activation = layout.update(fromActivation: activation!)
//            
//            SLTAssertConstraintsHasSameElements(superview.constraints, tags: tags) {
//                TestAnchors(first: subview, second: superview) {
//                    Anchors.top.equalToSuper(constant: 10)
//                }
//                TestAnchors(first: siblingview, second: superview) {
//                    Anchors.height.equalToSuper().multiplier(0.5)
//                    Anchors.centerX.bottom
//                }
//            }
//            SLTAssertConstraintsHasSameElements(subview.constraints, tags: tags) {
//                TestAnchors(first: subview) {
//                    Anchors.size.equalTo(width: 37, height: 19)
//                }
//            }
//            SLTAssertConstraintsHasSameElements(siblingview.constraints, tags: tags) {
//                TestAnchors(first: siblingview) {
//                    Anchors.width.equalTo(constant: 37)
//                }
//            }
//        }
//        
//        contextContinuous("deactive") {
//            activation?.deactive()
//            activation = nil
//            
//            SLTAssertConstraintsIsEmpty(superview.constraints, tags: tags)
//            SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
//            SLTAssertConstraintsIsEmpty(siblingview.constraints, tags: tags)
//        }
//    }
//}
//
//// MARK: - conditional syntax
//extension AnchorsDSLTests {
//    func testIf() {
//        var flag = true
//        
//        @LayoutBuilder
//        var layout: some Layout {
//            superview.sl.sublayout {
//                subview.sl.anchors {
//                    if flag {
//                        Anchors.cap.equalToSuper()
//                    } else {
//                        Anchors.shoe.equalToSuper()
//                    }
//                }
//            }
//        }
//        
//        context("if true") {
//            flag = true
//            layout.active().store(&activation)
//            
//            SLTAssertConstraintsHasSameElements(superview.constraints, tags: tags) {
//                TestAnchors(first: subview, second: superview) {
//                    Anchors.cap.equalToSuper()
//                }
//            }
//            SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
//        }
//        
//        context("if false") {
//            flag = false
//            layout.active().store(&activation)
//            
//            SLTAssertConstraintsHasSameElements(superview.constraints, tags: tags) {
//                TestAnchors(first: subview, second: superview) {
//                    Anchors.shoe.equalToSuper()
//                }
//            }
//            SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
//        }
//    }
//    
//    func testSwitchCase() {
//        enum Test: String, CaseIterable {
//            case first
//            case second
//            case third
//        }
//        
//        @LayoutBuilder
//        func layout(_ test: Test) -> some Layout {
//            superview.sl.sublayout {
//                subview.sl.anchors {
//                    switch test {
//                    case .first:
//                        Anchors.allSides.equalToSuper()
//                    case .second:
//                        Anchors.center.equalToSuper()
//                        Anchors.size.equalTo(width: 11, height: 37)
//                    case .third:
//                        Anchors.horizontal.equalToSuper()
//                        Anchors.vertical.equalToSuper(inwardOffset: 11)
//                    }
//                }
//            }
//        }
//        
//        context("enum test first") {
//            layout(.first).active().store(&activation)
//            
//            SLTAssertConstraintsHasSameElements(superview.constraints, [
//                NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0),
//                NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
//                NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
//                NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0.0),
//            ], tags: tags)
//            SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
//        }
//        
//        context("enum test second") {
//            layout(.second).active().store(&activation)
//            
//            SLTAssertConstraintsHasSameElements(superview.constraints, [
//                NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0),
//                NSLayoutConstraint(item: subview, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: 0.0),
//            ], tags: tags)
//            SLTAssertConstraintsHasSameElements(subview.constraints, [
//                NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 11.0),
//                NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 37.0),
//            ], tags: tags)
//        }
//        
//        context("enum test third") {
//            layout(.third).active().store(&activation)
//            
//            SLTAssertConstraintsHasSameElements(superview.constraints, [
//                NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 11.0),
//                NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
//                NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
//                NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: -11.0),
//            ], tags: tags)
//            SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
//        }
//    }
//    
//    func testOptional() {
//        var optionalAnchors: Anchors?
//        var optionalExpression: AnchorsExpression<AnchorsDimensionAttribute>?
//        var optionalMixedExpression: AnchorsMixedExpression?
//        
//        @LayoutBuilder
//        var layout: some Layout {
//            superview.sl.sublayout {
//                subview.sl.anchors {
//                    optionalAnchors
//                    optionalExpression
//                    optionalMixedExpression
//                }
//            }
//        }
//        
//        context("is nil") {
//            optionalAnchors = nil
//            optionalExpression = nil
//            optionalMixedExpression = nil
//            
//            layout.active().store(&activation)
//            
//            SLTAssertConstraintsIsEmpty(superview.constraints, tags: tags)
//            SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
//        }
//        
//        context("is optional") {
//            optionalAnchors = Anchors.center.equalToSuper()
//            optionalExpression = Anchors.width.height
//            optionalMixedExpression = Anchors.leading.top
//
//            layout.active().store(&activation)
//            
//            SLTAssertConstraintsHasSameElements(superview.constraints, tags: tags) {
//                TestAnchors(first: subview, second: superview) {
//                    Anchors.center
//                    Anchors.width.height
//                    Anchors.leading
//                    Anchors.top
//                }
//            }
//        }
//    }
//    
//    func testForIn() {
//        let xAxis = [
//            Anchors.leading,
//            Anchors.trailing
//        ]
//        let yAxis = [
//            Anchors.top,
//            Anchors.bottom
//        ]
//        
//        @LayoutBuilder
//        var layout: some Layout {
//            superview.sl.sublayout {
//                subview.sl.anchors {
//                    for anchors in xAxis {
//                        anchors
//                    }
//                    for anchors in yAxis {
//                        anchors
//                    }
//                }
//            }
//        }
//        
//        layout.active().store(&activation)
//
//        SLTAssertConstraintsHasSameElements(superview.constraints, firstView: subview, secondView: superview, tags: tags) {
//            Anchors.allSides.equalToSuper()
//        }
//        SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
//    }
//}
//
//// MARK: - complex usage
//extension AnchorsDSLTests {
//    func testOmitable() {
//        var layout: some Layout {
//            superview.sl.sublayout {
//                subview.sl.anchors {
//                    Anchors.top
//                    Anchors.bottom
//                    Anchors.horizontal
//                }
//                siblingview.sl.anchors {
//                    Anchors.center
//                    Anchors.size
//                    Anchors.allSides
//                }
//            }
//        }
//
//        layout.finalActive()
//
//        SLTAssertConstraintsHasSameElements(superview.constraints, tags: tags) {
//            TestAnchors(first: subview, second: superview) {
//                Anchors.top.equalToSuper()
//                Anchors.bottom.equalToSuper()
//                Anchors.horizontal.equalToSuper()
//            }
//            TestAnchors(first: siblingview, second: superview) {
//                Anchors.center.equalToSuper()
//                Anchors.size.equalToSuper()
//                Anchors.allSides.equalToSuper()
//            }
//        }
//        SLTAssertConstraintsIsEmpty(subview.constraints)
//        SLTAssertConstraintsIsEmpty(siblingview.constraints)
//    }
//
//    func testWithIdentifier() {
//        let identifyingView = UIView()
//        
//        @LayoutBuilder
//        var layout: some Layout {
//            superview.sl.sublayout {
//                subview.sl.anchors {
//                    Anchors.cap.equalToSuper()
//                    Anchors.bottom.equalTo("someIdentifier", attribute: .top)
//                }
//                identifyingView.sl.identifying("someIdentifier").sl.anchors {
//                    Anchors.width.equalTo(constant: 37)
//                    Anchors.height.equalToSuper().multiplier(0.5)
//                    Anchors.centerX
//                    Anchors.bottom
//                }
//            }
//        }
//        
//        layout.finalActive()
//        
//        SLTAssertConstraintsHasSameElements(superview.constraints, tags: tags) {
//            TestAnchors(first: subview, second: superview) {
//                Anchors.cap.equalToSuper()
//            }
//            TestAnchors(first: subview, second: identifyingView) {
//                Anchors.bottom.equalTo(identifyingView, attribute: .top)
//            }
//            TestAnchors(first: identifyingView, second: superview) {
//                Anchors.height.equalToSuper().multiplier(0.5)
//                Anchors.centerX
//                Anchors.bottom
//            }
//        }
//        SLTAssertConstraintsIsEmpty(subview.constraints)
//        SLTAssertConstraintsHasSameElements(identifyingView.constraints) {
//            TestAnchors(first: identifyingView) {
//                Anchors.width.equalTo(constant: 37)
//            }
//        }
//    }
//    
//    func testDuplicateAnchorExpression() {
//        @LayoutBuilder
//        var layout: some Layout {
//            superview.sl.sublayout {
//                subview.sl.anchors {
//                    Anchors.cap.equalToSuper()
//                    Anchors.leading.trailing
//                    Anchors.top
//                    Anchors.bottom.equalTo(siblingview, attribute: .top)
//                }
//                siblingview.sl.anchors {
//                    Anchors.width.equalTo(constant: 37)
//                    Anchors.height.equalTo(constant: 37)
//                    Anchors.size.equalTo(width: 37, height: 37)
//                    Anchors.centerX
//                    Anchors.bottom
//                    Anchors.centerX
//                    Anchors.bottom
//                }
//            }
//        }
//        
//        layout.finalActive()
//        
//        SLTAssertConstraintsHasSameElements(superview.constraints, tags: tags) {
//            TestAnchors(first: subview, second: superview) {
//                Anchors.cap.equalToSuper()
//            }
//            TestAnchors(first: subview, second: siblingview) {
//                Anchors.bottom.equalToSuper(attribute: .top)
//            }
//            TestAnchors(first: siblingview, second: superview) {
//                Anchors.centerX
//                Anchors.bottom
//            }
//        }
//        SLTAssertConstraintsIsEmpty(subview.constraints)
//        SLTAssertConstraintsHasSameElements(siblingview.constraints) {
//            TestAnchors(first: siblingview) {
//                Anchors.size.equalTo(width: 37, height: 37)
//            }
//        }
//    }
//    
//    func testDuplicateAnchorsBuilder() {
//        @LayoutBuilder
//        var layout: some Layout {
//            superview.sl.sublayout {
//                subview.sl.anchors {
//                    Anchors.cap.equalToSuper()
//                }.anchors {
//                    Anchors.bottom.equalTo(siblingview, attribute: .top)
//                }
//                siblingview.sl.anchors {
//                    Anchors.width.equalTo(constant: 37)
//                }.anchors {
//                    Anchors.height.equalToSuper().multiplier(0.5)
//                }.anchors {
//                    Anchors.centerX
//                }.anchors {
//                    Anchors.bottom
//                }
//            }
//        }
//        
//        layout.finalActive()
//        
//        SLTAssertConstraintsHasSameElements(superview.constraints, tags: tags) {
//            TestAnchors(first: subview, second: superview) {
//                Anchors.cap.equalToSuper()
//            }
//            TestAnchors(first: subview, second: siblingview) {
//                Anchors.bottom.equalToSuper(attribute: .top)
//            }
//            TestAnchors(first: siblingview, second: superview) {
//                Anchors.height.equalToSuper().multiplier(0.5)
//                Anchors.centerX
//                Anchors.bottom
//            }
//        }
//        SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
//        
//        SLTAssertConstraintsHasSameElements(siblingview.constraints, firstView: siblingview, tags: tags) {
//            Anchors.width.equalTo(constant: 37)
//        }
//    }
//    
//    func testMultipleFirstLevelLayouts() {
//        @LayoutBuilder
//        var layout: some Layout {
//            superview.sl.sublayout {
//                subview.sl.anchors {
//                    Anchors.cap.equalToSuper()
//                    
//                }
//                siblingview.sl.anchors {
//                    Anchors.height.equalToSuper().multiplier(0.5)
//                    Anchors.centerX
//                    Anchors.bottom
//                }
//            }
//            
//            subview.sl.anchors {
//                Anchors.bottom.equalTo(siblingview, attribute: .top)
//            }
//            
//            siblingview.sl.anchors {
//                Anchors.width.equalTo(constant: 37)
//            }
//        }
//        
//        layout.finalActive()
//        
//        SLTAssertConstraintsHasSameElements(superview.constraints, tags: tags) {
//            TestAnchors(first: subview, second: superview) {
//                Anchors.cap.equalToSuper()
//            }
//            TestAnchors(first: subview, second: siblingview) {
//                Anchors.bottom.equalToSuper(attribute: .top)
//            }
//            TestAnchors(first: siblingview, second: superview) {
//                Anchors.height.equalToSuper().multiplier(0.5)
//                Anchors.centerX
//                Anchors.bottom
//            }
//        }
//        SLTAssertConstraintsIsEmpty(subview.constraints, tags: tags)
//        SLTAssertConstraintsHasSameElements(siblingview.constraints, firstView: siblingview) {
//            Anchors.width.equalTo(constant: 37)
//        }
//    }
//}
//
//extension AnchorsDSLTests {
//    func testForceLayoutAndCheckFrame() {
//        let width: CGFloat = 300
//        let height: CGFloat = 300
//        let siblingWidth: CGFloat = 38
//        let siblingHeightMultiplier: CGFloat = 0.5
//        
//        
//        let window = UIWindow(frame: .init(x: .zero, y: .zero, width: width, height: height))
//        
//        @LayoutBuilder
//        var layout: some Layout {
//            window.sl.sublayout {
//                superview.sl.sublayout {
//                    subview.sl.anchors {
//                        Anchors.cap.equalToSuper()
//                        Anchors.bottom.equalTo(siblingview, attribute: .top)
//                    }
//                    siblingview.sl.anchors {
//                        Anchors.width.equalTo(constant: siblingWidth)
//                        Anchors.height.equalToSuper().multiplier(siblingHeightMultiplier)
//                        Anchors.centerX
//                        Anchors.bottom
//                    }
//                }.anchors {
//                    Anchors.allSides.equalToSuper()
//                }
//            }
//        }
//        
//        layout.finalActive(forceLayout: true)
//        
//        XCTAssertEqual(superview.frame, .init(x: .zero, y: .zero, width: width, height: height))
//        XCTAssertEqual(subview.frame, .init(x: .zero, y: .zero, width: width, height: height * (1 - siblingHeightMultiplier)))
//        XCTAssertEqual(siblingview.frame, .init(x: (width - siblingWidth) / 2, y: height * (1 - siblingHeightMultiplier), width: siblingWidth, height: height * siblingHeightMultiplier))
//    }
//}
