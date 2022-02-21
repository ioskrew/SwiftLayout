import XCTest
import UIKit
import SwiftLayout

final class LayoutDSLTest: XCTestCase {
        
    var root: UIView = UIView().viewTag.root
    var button: UIButton = UIButton().viewTag.button
    var label: UILabel = UILabel().viewTag.label
    var red: UIView = UIView().viewTag.red
    var blue: UIView = UIView().viewTag.blue
    var image: UIImageView = UIImageView().viewTag.image
    
    var deactivable: Deactivable?
    
    override func setUp() {
        root = UIView().viewTag.root
        button = UIButton().viewTag.button
        label = UILabel().viewTag.label
        red = UIView().viewTag.red
        blue = UIView().viewTag.red
        image = UIImageView().viewTag.image
    }
    
    override func tearDown() {
        deactivable = nil
    }
}

extension LayoutDSLTest {
    func testActive() {
        deactivable = root {
            red {
                button
                label
                blue {
                    image
                }
            }
        }.active()
        
        XCTAssertEqual(image.superview, blue)
        XCTAssertEqual(blue.superview, red)
        XCTAssertEqual(label.superview, red)
        XCTAssertEqual(button.superview, red)
        XCTAssertEqual(red.superview, root)
    }
    
    func testDeactive() {
        deactivable = root {
            red {
                button
                label
                blue {
                    image
                }
            }
        }.active()
        
        deactivable?.deactive()
        
        XCTAssertEqual(image.superview, nil)
        XCTAssertEqual(blue.superview, nil)
        XCTAssertEqual(label.superview, nil)
        XCTAssertEqual(button.superview, nil)
        XCTAssertEqual(red.superview, nil)
    }
    
    func testDontTouchRootViewByDeactive() {
        let old = UIView().viewTag.old
        old.addSubview(root)
        root.translatesAutoresizingMaskIntoConstraints = true
        
        deactivable = root {
            red.anchors {
                Anchors.boundary
            }
        }.active()
        
        XCTAssertTrue(root.translatesAutoresizingMaskIntoConstraints)
        
        deactivable?.deactive()
        
        XCTAssertEqual(root.superview, old)
    }
    
    func testLayoutWithTrueFlag() {
        let flag = true

        deactivable = root {
            red {
                button
            }
            
            if flag {
                label
            } else {
                image
            }
        }.active()
        
        XCTAssertEqual(root.subviews.count, 2)
        
        XCTAssertEqual(red.superview, root)
        XCTAssertEqual(button.superview, red)
        
        XCTAssertEqual(label.superview, root)
        XCTAssertEqual(image.superview, nil)
    }
    
    func testLayoutWithFalseFlag() {
        let flag = false

        deactivable = root {
            red {
                button
            }
            
            if flag {
                label
                UILabel()
            } else {
                image
            }
        }.active()
        
        XCTAssertEqual(root.subviews.count, 2)
        
        XCTAssertEqual(red.superview, root)
        XCTAssertEqual(button.superview, red)
        
        XCTAssertEqual(label.superview, nil)
        XCTAssertEqual(image.superview, root)
    }
    
    func testLayoutWithOptionalViews() {
        let optionalView: UIView? = UIView().viewTag.optionalView
        let nilView: UIView? = nil

        deactivable = root {
            red {
                button
            }
            
            optionalView
            nilView
        }.active()
        
        XCTAssertEqual(root.subviews.count, 2)
        
        XCTAssertEqual(red.superview, root)
        XCTAssertEqual(button.superview, red)
        
        XCTAssertEqual(optionalView?.superview, root)
        XCTAssertEqual(nilView?.superview, nil)
    }
    
    func testLayoutWithForIn() {
        let views: [UILabel] = (0..<10).map(\.description).map {
            let label = UILabel()
            label.text = $0.description
            return label
        }
        
        deactivable = root {
            for view in views {
                view
            }
        }.active()
        
        XCTAssertEqual(root.subviews.count, views.count)
        XCTAssertEqual(root.subviews, views)
    }
    
    func testLayoutWithInstantView() {
        deactivable = root {
            UILabel()
            UIImageView()
        }.active()
        
        XCTAssertEqual(root.subviews.count, 2)
    }
}