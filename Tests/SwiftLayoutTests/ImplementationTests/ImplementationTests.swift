import XCTest
@testable import SwiftLayout

/// test cases for api rules except DSL syntax
final class ImplementationTests: XCTestCase {
        
    var root = UIView().identifying("root")
    var child = UIView().identifying("child")
    var friend = UIView().identifying("friend")
    
    var activation: Activation?
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        root = UIView().identifying("root")
        child = UIView().identifying("child")
        friend = UIView().identifying("friend")
    }
    
    override func tearDownWithError() throws {
        activation = nil
    }
}

extension ImplementationTests {
    func testLayoutTraversal() {
        let root: UIView = UIView().identifying("root")
        let button: UIButton = UIButton().identifying("button")
        let label: UILabel = UILabel().identifying("label")
        let redView: UIView = UIView().identifying("redView")
        let image: UIImageView = UIImageView().identifying("image")
        
        let layout = root {
            redView
            label {
                button
                image
            }
        }
        
        var result: [String] = []
        LayoutExplorer.traversal(layout: layout, superview: nil) { layout, superview in
            guard let view = layout.view else {
                return
            }
            
            let superDescription = superview?.accessibilityIdentifier ?? "nil"
            let currentDescription = view.accessibilityIdentifier ?? "nil"
            let description = "\(superDescription), \(currentDescription)"
            result.append(description)
        }
        
        let expectedResult = [
            "nil, root",
            "root, redView",
            "root, label",
            "label, button",
            "label, image",
        ]
        
        XCTAssertEqual(expectedResult, result)
    }
    
    func testLayoutFlattening() {
        let layout = root {
            child.anchors {
                Anchors.allSides()
            }.sublayout {
                friend.anchors {
                    Anchors.allSides()
                }
            }
        }
        
        XCTAssertNotNil(layout)
        XCTAssertEqual(LayoutElements(layout: layout).viewInformations.map(\.view), [root, child, friend])
    }
    
    func testLayoutCompare() {
        let f1 = root {
            child
        }
        let e1 = LayoutElements(layout: f1)
        
        let f2 = root {
            child
        }
        let e2 = LayoutElements(layout: f2)
        
        let f3 = root {
            child.anchors { Anchors.allSides() }
        }
        let e3 = LayoutElements(layout: f3)
        
        let f4 = root {
            child.anchors { Anchors.allSides() }
        }
        let e4 = LayoutElements(layout: f4)
        
        let f5 = root {
            child.anchors { Anchors.cap() }
        }
        let e5 = LayoutElements(layout: f5)
        
        let f6 = root {
            friend.anchors { Anchors.allSides() }
        }
        let e6 = LayoutElements(layout: f6)
        
        XCTAssertEqual(e1.viewInformations, e2.viewInformations)
        XCTAssertEqual(e1.viewConstraints.weakens, e2.viewConstraints.weakens)
        
        XCTAssertEqual(e3.viewInformations, e4.viewInformations)
        XCTAssertEqual(e3.viewConstraints.weakens, e4.viewConstraints.weakens)
        
        XCTAssertEqual(e4.viewInformations, e5.viewInformations)
        XCTAssertNotEqual(e4.viewConstraints.weakens, e5.viewConstraints.weakens)
        
        XCTAssertNotEqual(e5.viewInformations, e6.viewInformations)
        XCTAssertNotEqual(e5.viewConstraints.weakens, e6.viewConstraints.weakens)
    }
    
    func testDontTouchRootViewByDeactive() {
        let root = UIView().identifying("root")
        let red = UIView().identifying("red")
        let old = UIView().identifying("old")
        old.addSubview(root)
        root.translatesAutoresizingMaskIntoConstraints = true
        
        activation = root {
            red.anchors {
                Anchors.allSides()
            }
        }.active()
        
        XCTAssertTrue(root.translatesAutoresizingMaskIntoConstraints)
        
        activation?.deactive()
        activation = nil
        
        XCTAssertEqual(root.superview, old)
    }
}

extension ImplementationTests {
    func testIdentifier() {
        let activation = root {
            UILabel().identifying("label").anchors {
                Anchors.cap()
            }
            UIView().identifying("secondView").anchors {
                Anchors.top.equalTo("label", attribute: .bottom)
                Anchors.shoe()
            }
        }.active()
        
        let label = activation.viewForIdentifier("label")
        XCTAssertNotNil(label)
        XCTAssertEqual(label?.accessibilityIdentifier, "label")
        
        let secondView = activation.viewForIdentifier("secondView")
        XCTAssertEqual(secondView?.accessibilityIdentifier, "secondView")
        
        let currents = activation.constraints
        let labelConstraints = Set(Anchors.cap().constraints(item: label!, toItem: root).weakens)
        XCTAssertEqual(currents.intersection(labelConstraints), labelConstraints)
        
        let secondViewConstraints = Set(Anchors.cap().constraints(item: label!, toItem: root).weakens)
        XCTAssertEqual(currents.intersection(secondViewConstraints), secondViewConstraints)
        
        let constraintsBetweebViews = Set(AnchorsContainer(Anchors.top.equalTo(label!, attribute: .bottom)).constraints(item: secondView!, toItem: label).weakens)
        XCTAssertEqual(currents.intersection(constraintsBetweebViews), constraintsBetweebViews)
    }
}

extension ImplementationTests {
    
    func testStackViewMaintainOrderingOfArrangedSubviews() {
        let stack = StackView(frame: .init(x: 0, y: 0, width: 40, height: 80)).identifying("view")
        var a: UIView {
            stack.a
        }
        var b: UIView {
            stack.b
        }
        stack.sl.updateLayout(forceLayout: true)
        XCTAssertEqual(a.frame.debugDescription, "(20.0, 0.0, 0.0, 40.0)")
        XCTAssertEqual(b.frame.debugDescription, "(20.0, 40.0, 0.0, 40.0)")
        
        stack.isA = false
        stack.sl.updateLayout(forceLayout: true)
        
        XCTAssertEqual(b.frame.debugDescription, "(20.0, 0.0, 0.0, 80.0)")
        
        stack.isA = true
        stack.sl.updateLayout(forceLayout: true)
        
        XCTAssertEqual(stack.stack.arrangedSubviews.compactMap(\.accessibilityIdentifier), [a, b].compactMap(\.accessibilityIdentifier))
        XCTAssertEqual(a.frame.debugDescription, "(20.0, 0.0, 0.0, 40.0)")
        XCTAssertEqual(b.frame.debugDescription, "(20.0, 40.0, 0.0, 40.0)")
    }
    
    final class StackView: UIView, Layoutable {
        var activation: Activation?
        var layout: some Layout {
            self {
                stack.anchors {
                    Anchors.allSides()
                }.sublayout {
                    if isA {
                        a
                    }
                    b
                }
            }
        }
        
        let stack = UIStackView().config { stack in
            stack.axis = .vertical
            stack.distribution = .fillEqually
            stack.alignment = .center
            stack.spacing = 0.0
        }.identifying("stack")
        
        let a = UIView().identifying("a")
        let b = UIView().identifying("b")
        
        var isA: Bool = true
    }
}
