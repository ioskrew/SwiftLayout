import XCTest
import UIKit
import SwiftLayout

final class SwiftLayoutTests: XCTestCase {
    
    var superview: UIView!
    
    var root: UIView = UIView().viewTag.root
    var button: UIButton = UIButton().viewTag.button
    var label: UIView = UILabel().viewTag.label
    var redView: UIView = UIView().viewTag.redView
    var image: UIImageView = UIImageView().viewTag.image
    
    var layoutable: AnyLayout?
    
    override func setUp() {
        
        superview = UIView().viewTag.superview
       
        root.removeFromSuperview()
        button.removeFromSuperview()
        label.removeFromSuperview()
        redView.removeFromSuperview()
        image.removeFromSuperview()
    }
    
    func testSuperSubLayoutTypeCheck() {
        
        let layout: some Layout = root {
            button
        }
        
        XCTAssertTrue(layout is SuperSubLayout<UIView, UIButton>, "\(type(of: layout))")
        
    }
    
    func testSuperSubLayoutActive() {
        layoutable = root {
            button
        }.active()
        
        XCTAssertEqual(button.superview, root)
    }
    
    func testPairLayoutTypeCheck() {
        let layout: some Layout = root {
            button
            label
        }
        
        XCTAssertTrue(layout is SuperSubLayout<UIView, PairLayout<UIButton, UIView>>, "\(layout)")
    }
    
    func testPairLayoutActive() {
        layoutable = root {
            button
            label
        }.active()
        
        XCTAssertEqual(button.superview, root)
        XCTAssertEqual(label.superview, root)
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
