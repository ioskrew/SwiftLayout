import XCTest
import UIKit
@testable import SwiftLayout

final class LayoutViewTreeTests: XCTestCase {
        
    var root: UIView = UIView().viewTag.root
    var child: UIView = UIView().viewTag.child
    var button: UIButton = UIButton().viewTag.button
    var label: UILabel = UILabel().viewTag.label
    var redView: UIView = UIView().viewTag.redView
    var image: UIImageView = UIImageView().viewTag.image
    
    var deactivable: Deactivable?
    
    override func setUp() {
        root = UIView().viewTag.root
        child = UIView().viewTag.child
        button = UIButton().viewTag.button
        label = UILabel().viewTag.label
        redView = UIView().viewTag.redView
        image = UIImageView().viewTag.image
    }
    
    override func tearDown() {
        deactivable = nil
    }
    
    func testActive() {
        // given
        let grand = UIView().viewTag.grand
        
        // when
        deactivable = root {
            redView {
                button
                label
                grand {
                    image
                }
            }
        }.active()
        
        // then
        XCTAssertEqual(image.superview, grand)
        XCTAssertEqual(grand.superview, redView)
        XCTAssertEqual(label.superview, redView)
        XCTAssertEqual(button.superview, redView)
        XCTAssertEqual(redView.superview, root)
    }
    
    func testDeactive() {
        // given
        let grand = UIView().viewTag.grand
        
        // when
        deactivable = root {
            redView {
                button
                label
                grand {
                    image
                }
            }
        }.active()
        
        deactivable?.deactive()
        
        // then
        XCTAssertEqual(image.superview, nil)
        XCTAssertEqual(grand.superview, nil)
        XCTAssertEqual(label.superview, nil)
        XCTAssertEqual(button.superview, nil)
        XCTAssertEqual(redView.superview, nil)
    }
    
    func testActiveWithTrueFlag() {
        // given
        let flag = true

        // when
        deactivable = root {
            redView {
                button
            }
            
            if flag {
                label
            } else {
                image
            }
        }.active()
        
        // then
        XCTAssertEqual(root.subviews.count, 2)
        
        XCTAssertEqual(redView.superview, root)
        XCTAssertEqual(button.superview, redView)
        
        XCTAssertEqual(label.superview, root)
        XCTAssertEqual(image.superview, nil)
    }
    
    func testActiveWithFalseFlag() {
        // given
        let flag = false

        // when
        deactivable = root {
            redView {
                button
            }
            
            if flag {
                label
                UILabel()
            } else {
                image
            }
        }.active()
        
        // then
        XCTAssertEqual(root.subviews.count, 2)
        
        XCTAssertEqual(redView.superview, root)
        XCTAssertEqual(button.superview, redView)
        
        XCTAssertEqual(label.superview, nil)
        XCTAssertEqual(image.superview, root)
    }
    
    func testActiveWithOptionalViews() {
        // given
        let optionalView: UIView? = UIView().viewTag.optionalView
        let nilView: UIView? = nil

        // when
        deactivable = root {
            redView {
                button
            }
            
            optionalView
            nilView
        }.active()
        
        // then
        XCTAssertEqual(root.subviews.count, 2)
        
        XCTAssertEqual(redView.superview, root)
        XCTAssertEqual(button.superview, redView)
        
        XCTAssertEqual(optionalView?.superview, root)
        XCTAssertEqual(nilView?.superview, nil)
    }
}

@dynamicMemberLookup
struct Tag<Taggable> where Taggable: UIAccessibilityIdentification {
    let taggable: Taggable
    
    subscript(dynamicMember tag: String) -> Taggable {
        taggable.accessibilityIdentifier = tag
        return taggable
    }
}

extension UIAccessibilityIdentification {
    var viewTag: Tag<Self> {
        Tag(taggable: self)
    }
}
