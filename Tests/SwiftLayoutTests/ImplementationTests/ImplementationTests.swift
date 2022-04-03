import XCTest
@testable import SwiftLayoutUtil
@testable import SwiftLayout


/// test cases for api rules except DSL syntax
final class ImplementationTests: XCTestCase {
    
    var window: UIView!
    
    var root = UIView().identifying("root")
    var child = UIView().identifying("child")
    var friend = UIView().identifying("friend")
    
    var activation: Activation?
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        window = UIView(frame: .init(x: 0, y: 0, width: 150, height: 150))
        root = UIView().identifying("root")
        child = UIView().identifying("child")
        friend = UIView().identifying("friend")
        window.addSubview(root)
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
        for viewInformation in LayoutElements(layout: layout).viewInformations {
            let superDescription = viewInformation.superview?.accessibilityIdentifier ?? "nil"
            let currentDescription = viewInformation.view?.accessibilityIdentifier ?? "nil"
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
    
    func testSetAccessibilityIdentifier() {
        class TestView: UIView {
            let contentView = UIView()
            let nameLabel = UILabel()
        }
        
        let view = TestView()
        IdentifierUpdater.withTypeOfView.update(view)
        
        XCTAssertEqual(view.contentView.accessibilityIdentifier, "contentView:\(UIView.self)")
        XCTAssertEqual(view.nameLabel.accessibilityIdentifier, "nameLabel:\(UILabel.self)")
        
        class Test2View: TestView {}
        
        let view2 = Test2View()
        IdentifierUpdater.withTypeOfView.update(view2)
        
        XCTAssertEqual(view2.contentView.accessibilityIdentifier, "contentView:\(UIView.self)")
        XCTAssertEqual(view2.nameLabel.accessibilityIdentifier, "nameLabel:\(UILabel.self)")
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
    final class IdentifiedView: UIView, Layoutable {
        
        lazy var contentView: UIView = UIView()
        lazy var nameLabel: UILabel = UILabel()
        
        var activation: Activation?
        
        var layout: some Layout {
            contentView {
                nameLabel
            }
        }
        
        init() {
            super.init(frame: .zero)
            sl.updateLayout()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    func testNoAccessibilityIdentifierOption() {
        let view = IdentifiedView()
        XCTAssertEqual(view.contentView.accessibilityIdentifier ?? "", "")
        XCTAssertEqual(view.nameLabel.accessibilityIdentifier ?? "", "")
    }
    
    func testAccessibilityIdentifierOption() {
        let view = IdentifiedView()
        ViewPrinter(view).updateIdentifiers()
        XCTAssertEqual(view.contentView.accessibilityIdentifier, "contentView")
        XCTAssertEqual(view.nameLabel.accessibilityIdentifier, "nameLabel")
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
    func testIgnoreAnchorsDuplication() {
        root {
            child.anchors {
                Anchors.allSides()
                Anchors.cap()
                Anchors.shoe()
                Anchors.height
                Anchors.width
                Anchors.width.equalTo(constant: 24.0)
            }
        }.finalActive()

        
        XCTAssertEqual(root.constraints.shortDescription, """
        child.top == root.top
        child.leading == root.leading
        child.height == root.height
        child.width == root.width
        child.trailing == root.trailing
        child.bottom == root.bottom
        """.descriptions)
        XCTAssertEqual(child.constraints.shortDescription, """
        child.width == + 24.0
        """.descriptions)
        
        XCTAssertEqual(ViewPrinter(root).description, """
        root {
            child.anchors {
                Anchors.top.bottom
                Anchors.leading.trailing
                Anchors.width.equalTo(constant: 24.0)
                Anchors.width.height.equalToSuper()
            }
        }
        """.tabbed)
    }

    func testIgnoreAnchorsDuplication2() {
        root {
            child.anchors {
                Anchors.cap()
                Anchors.height.equalTo(constant: 44)
                Anchors.height.equalTo(constant: 44)
            }
        }.finalActive()

        let expect = """
        root {
            child.anchors {
                Anchors.top
                Anchors.leading.trailing
                Anchors.height.equalTo(constant: 44.0)
            }
        }
        """

        XCTAssertEqual(ViewPrinter(root).description, expect.tabbed)
    }
}

extension ImplementationTests {
    func testFinalActive() {
        let root = UIView().identifying("root")
        let cap = UIView().identifying("cap")
        let shoe = UIView().identifying("shoe")

        root {
            cap.anchors {
                Anchors.cap()
            }
            shoe.anchors {
                Anchors.shoe()
            }
        }.finalActive()

        let expect = """
        root {
            cap.anchors {
                Anchors.top
                Anchors.leading.trailing
            }
            shoe.anchors {
                Anchors.bottom
                Anchors.leading.trailing
            }
        }
        """.tabbed

        XCTAssertEqual(ViewPrinter(root).description, expect)
    }
}

// MARK: - Decorations
extension ImplementationTests {

    func testFeatureCompose() {
        activation = root.config({ root in
            root.backgroundColor = .yellow
        }).identifying("root").anchors({ }).sublayout {
            UILabel().config({ label in
                label.text = "hello"
            }).identifying("child").anchors {
                Anchors.allSides()
            }
        }.active()

        let expect = """
        root {
            child.anchors {
                Anchors.top.bottom
                Anchors.leading.trailing
            }
        }
        """.tabbed

        XCTAssertEqual(ViewPrinter(root).description, expect)
    }

    func testFeatureComposeComplex() {
        activation = root.config({ root in
            root.backgroundColor = .yellow
        }).sublayout {
            UILabel().config { label in
                label.text = "HELLO"
            }.identifying("hellolabel").anchors {
                Anchors.cap()
            }.sublayout {
                UIView().identifying("lastview").anchors {
                    Anchors.allSides()
                }
            }
            UIButton().identifying("button").anchors {
                Anchors.shoe()
            }
        }.active()

        let expect = """
        root {
            hellolabel.anchors {
                Anchors.top
                Anchors.leading.trailing
            }.sublayout {
                lastview.anchors {
                    Anchors.top.bottom
                    Anchors.leading.trailing
                }
            }
            button.anchors {
                Anchors.bottom
                Anchors.leading.trailing
            }
        }
        """.tabbed

        XCTAssertEqual(ViewPrinter(root, options: .onlyIdentifier).description, expect)
    }

    func testFeatureComposeComplexWithAnimationHandling() {
        activation = root.config({ root in
            root.backgroundColor = .yellow
        }).sublayout {
            UILabel().config { label in
                label.text = "HELLO"
            }.identifying("hellolabel").anchors {
                Anchors.cap()
            }.sublayout {
                UIView().identifying("lastview").anchors {
                    Anchors.allSides()
                }
            }
            UIButton().identifying("button").anchors {
                Anchors.shoe()
            }
        }.active()

        let expect = """
        root {
            hellolabel.anchors {
                Anchors.top
                Anchors.leading.trailing
            }.sublayout {
                lastview.anchors {
                    Anchors.top.bottom
                    Anchors.leading.trailing
                }
            }
            button.anchors {
                Anchors.bottom
                Anchors.leading.trailing
            }
        }
        """.tabbed

        XCTAssertEqual(ViewPrinter(root, options: .onlyIdentifier).description, expect)
    }

}

// MARK: - LayoutProperty
extension ImplementationTests {
    
    func testLayoutProperty() {
        let test = TestView().identifying("test")
        
        XCTAssertEqual(test.trueView.superview, test)
        XCTAssertNil(test.falseView.superview)
        
        test.flag = false
        XCTAssertEqual(test.falseView.superview, test)
        XCTAssertNil(test.trueView.superview)
    }
    
    private class TestView: UIView, Layoutable {
        
        @LayoutProperty var flag = true
        
        var trueView = UIView().identifying("true")
        var falseView = UIView().identifying("false")
        
        var activation: Activation?
        
        var layout: some Layout {
            self {
                if flag {
                    trueView
                } else {
                    falseView
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
}
