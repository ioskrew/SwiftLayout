import XCTest
import SwiftLayout
import SwiftLayoutPrinter

final class LayoutBuildingTests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testUpdateLayout() {
        let view = LayoutView().viewTag.view
        view.frame = .init(x: 0, y: 0, width: 90, height: 90)
        view.layoutIfNeeded()

        XCTAssertEqual(view.child.bounds.size, CGSize(width: 90, height: 90))
        XCTAssertEqual(SwiftLayoutPrinter(view).print(), """
        view {
            root.anchors {
                Anchors.top.bottom
                Anchors.leading.trailing
            }.sublayout {
                child.anchors {
                    Anchors.top.bottom
                    Anchors.leading.trailing
                }
            }
        }
        """.tabbed)

        view.sl.updateLayout(forceLayout: true)

        XCTAssertEqual(view.root.count(view.child), 1)
        XCTAssertEqual(view.root.count(view.friend), 0)
        XCTAssertEqual(SwiftLayoutPrinter(view).print(), """
        view {
            root.anchors {
                Anchors.top.bottom
                Anchors.leading.trailing
            }.sublayout {
                child.anchors {
                    Anchors.top.bottom
                    Anchors.leading.trailing
                }
            }
        }
        """.tabbed)

        view.flag.toggle()

        XCTAssertEqual(view.root.count(view.child), 1)
        XCTAssertEqual(view.root.count(view.friend), 1)
        XCTAssertEqual(view.friend.superview, view.root)
        XCTAssertEqual(view.root.bounds.size, .init(width: 90, height: 90))
        view.friend.setNeedsLayout()
        view.friend.layoutIfNeeded()
        XCTAssertEqual(view.friend.bounds.size, .init(width: 90, height: 90))
        XCTAssertEqual(SwiftLayoutPrinter(view).print(), """
        view {
            root.anchors {
                Anchors.top.bottom
                Anchors.leading.trailing
            }.sublayout {
                friend.anchors {
                    Anchors.top.bottom
                    Anchors.leading.trailing
                }
            }
        }
        """.tabbed)
    }
}

extension LayoutBuildingTests {
    class MockView: UIView {
        var addSubviewCounts: [UIView: Int] = [:]
        
        func count(_ view: UIView) -> Int {
            addSubviewCounts[view] ?? 0
        }
        
        override func addSubview(_ view: UIView) {
            if let count = addSubviewCounts[view] {
                addSubviewCounts[view] = count + 1
            } else {
                addSubviewCounts[view] = 1
            }
            super.addSubview(view)
        }
    }
    
    class LayoutView: UIView, Layoutable {
        @LayoutProperty var flag = true
        
        let root = MockView().viewTag.root
        let child = UIView().viewTag.child
        let friend = UILabel().viewTag.friend
        
        var activation: Activation? 
        
        var layout: some Layout {
            self {
                root.anchors({
                    Anchors.allSides()
                }).sublayout {
                    if flag {
                        child.anchors {
                            Anchors.allSides()
                        }
                    } else {
                        friend.anchors {
                            Anchors.allSides()
                        }
                    }
                }
            }
        }
        
        convenience init(flag _flag: Bool) {
            self.init(frame: .zero)
            flag = _flag
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            sl.updateLayout()
        }
        
        required init?(coder: NSCoder) {
            fatalError()
        }
    }
}
