import XCTest
import SwiftLayout

/// test cases for constraint DSL syntax
final class AnchorsDSLTests: XCTestCase {
    var superview: UIView = UIView()
    var subview: UIView = UIView()
    var siblingview: UIView = UIView()
    
    var activation: Set<Activation> = []
    
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
        
        assertConstrints(superview.constraints, [
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: 0.0),
            
            NSLayoutConstraint(item: siblingview, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0.5, constant: 0.0),
            NSLayoutConstraint(item: siblingview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: siblingview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0.0),
        ])
        assertConstrints(subview.constraints, [])
        assertConstrints(siblingview.constraints, [
            NSLayoutConstraint(item: siblingview, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 37.0),
        ])
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
        
        assertConstrints(superview.constraints, [])
        assertConstrints(subview.constraints, [])
        assertConstrints(siblingview.constraints, [])
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
        
        assertConstrints(superview.constraints, [
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: 0.0),
            
            NSLayoutConstraint(item: siblingview, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0.5, constant: 0.0),
            NSLayoutConstraint(item: siblingview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: siblingview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0.0),
        ])
        assertConstrints(subview.constraints, [])
        assertConstrints(siblingview.constraints, [
            NSLayoutConstraint(item: siblingview, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 37.0),
        ])
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
        
        context("active") {
            activation = layout.active()
            
            assertConstrints(superview.constraints, [
                NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: 0.0),
                
                NSLayoutConstraint(item: siblingview, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0.5, constant: 0.0),
                NSLayoutConstraint(item: siblingview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: siblingview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            ])
            assertConstrints(subview.constraints, [])
            assertConstrints(siblingview.constraints, [
                NSLayoutConstraint(item: siblingview, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 37.0),
            ])
        }
        
        context("update without change") {
            activation = layout.update(fromActivation: activation!)
            
            assertConstrints(superview.constraints, [
                NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: 0.0),
                
                NSLayoutConstraint(item: siblingview, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0.5, constant: 0.0),
                NSLayoutConstraint(item: siblingview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: siblingview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            ])
            assertConstrints(subview.constraints, [])
            assertConstrints(siblingview.constraints, [
                NSLayoutConstraint(item: siblingview, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 37.0),
            ])
        }
        
        context("update without change") {
            flag.toggle()
            
            activation = layout.update(fromActivation: activation!)
            
            assertConstrints(superview.constraints, [
                NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 10.0),
                
                NSLayoutConstraint(item: siblingview, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0.5, constant: 0.0),
                NSLayoutConstraint(item: siblingview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: siblingview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            ])
            assertConstrints(subview.constraints, [
                NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 37.0),
                NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 19.0),
            ])
            assertConstrints(siblingview.constraints, [
                NSLayoutConstraint(item: siblingview, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 37.0),
            ])
        }
        
        context("deactive") {
            activation?.deactive()
            activation = nil
            
            assertConstrints(superview.constraints, [])
            assertConstrints(subview.constraints, [])
            assertConstrints(siblingview.constraints, [])
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
            
            assertConstrints(superview.constraints, [
                NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            ])
            assertConstrints(subview.constraints, [])
        }
        
        context("if false") {
            flag = false
            layout.active().store(&activation)
            
            assertConstrints(superview.constraints, [
                NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            ])
            assertConstrints(subview.constraints, [])
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
            
            assertConstrints(superview.constraints, [])
            assertConstrints(subview.constraints, [])
        }
        
        context("is optional") {
            optionalContainer = Anchors.center()
            optionalExpression = Anchors.width.height.equalTo(constant: 11)
            layout.active().store(&activation)
            
            assertConstrints(superview.constraints, [
                NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            ])
            assertConstrints(subview.constraints, [
                NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 11.0),
                NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 11.0),
            ])
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

        assertConstrints(superview.constraints, [
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0.0),
        ])
        assertConstrints(subview.constraints, [])
    }
}

// MARK: - complex usage
extension AnchorsDSLTests {
    func testWithIdentifier() {
        let identifiingView = UIView()
        
        @LayoutBuilder
        var layout: some Layout {
            superview {
                subview.anchors {
                    Anchors.cap()
                    Anchors.bottom.equalTo("someIdentifier", attribute: .top)
                }
                identifiingView.identifying("someIdentifier").anchors {
                    Anchors.width.equalTo(constant: 37)
                    Anchors.height.equalToSuper().multiplier(0.5)
                    Anchors.centerX
                    Anchors.bottom
                }
            }
        }
        
        layout.finalActive()
        
        assertConstrints(superview.constraints, [
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: identifiingView, attribute: .top, multiplier: 1.0, constant: 0.0),
            
            NSLayoutConstraint(item: identifiingView, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0.5, constant: 0.0),
            NSLayoutConstraint(item: identifiingView, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: identifiingView, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0.0),
        ])
        assertConstrints(subview.constraints, [])
        assertConstrints(identifiingView.constraints, [
            NSLayoutConstraint(item: identifiingView, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 37.0),
        ])
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
        
        assertConstrints(superview.constraints, [
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: 0.0),
            
            NSLayoutConstraint(item: siblingview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: siblingview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0.0),
        ])
        assertConstrints(subview.constraints, [])
        assertConstrints(siblingview.constraints, [
            NSLayoutConstraint(item: siblingview, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 37.0),
            NSLayoutConstraint(item: siblingview, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 37.0),
        ])
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
        
        assertConstrints(superview.constraints, [
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: 0.0),
            
            NSLayoutConstraint(item: siblingview, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0.5, constant: 0.0),
            NSLayoutConstraint(item: siblingview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: siblingview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0.0),
        ])
        assertConstrints(subview.constraints, [])
        assertConstrints(siblingview.constraints, [
            NSLayoutConstraint(item: siblingview, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 37.0),
        ])
    }
    
    func testSeparatedFromFirstLevel() {
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
        
        assertConstrints(superview.constraints, [
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: 0.0),
            
            NSLayoutConstraint(item: siblingview, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 0.5, constant: 0.0),
            NSLayoutConstraint(item: siblingview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: siblingview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0.0),
        ])
        assertConstrints(subview.constraints, [])
        assertConstrints(siblingview.constraints, [
            NSLayoutConstraint(item: siblingview, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 37.0),
        ])
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
