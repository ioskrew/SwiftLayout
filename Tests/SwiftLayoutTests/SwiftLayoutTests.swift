import XCTest
import UIKit
import SwiftLayout

final class SwiftLayoutTests: XCTestCase {
    
    var superview: UIView!
    
    var root: UIView = UIView().viewTag.root
    var button: UIButton = UIButton().viewTag.button
    var label: UILabel = UILabel().viewTag.label
    var redView: UIView = {
        let view = UIView().viewTag.redView
        view.backgroundColor = .red
        return view
    }()
    var image: UIImageView = UIImageView().viewTag.image
    
    var layout: AnyLayout?
    
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
        layout = root {
            button
        }.active()
        
        XCTAssertEqual(button.superview, root)
    }
    
    func testPairLayoutTypeCheck() {
        let layout: some Layout = root {
            button
            label
        }
        
        XCTAssertTrue(layout is SuperSubLayout<UIView, PairLayout<UIButton, UILabel>>, "\(layout)")
    }
    
    func testPairLayoutActive() {
        layout = root {
            button
            label
        }.active()
        
        XCTAssertEqual(button.superview, root)
        XCTAssertEqual(label.superview, root)
    }
    
    func testTupleLayoutTypeCheck() {
        let layout: some Layout = root {
            button
            label
            redView
        }
        
        XCTAssertTrue(layout is SuperSubLayout<UIView, TupleLayout<(UIButton, UILabel, UIView)>>, String(describing: type(of: layout)))
    }
    
    func testTupleLayoutTypeActive() {
        layout = root {
            button
            label
            redView
        }.active()
        
        XCTAssertEqual(Set(root.subviews), Set([button, label, redView]))
    }
    
    func testGroupLayoutTypeCheck() {
        let layout: some Layout = root {
            GroupLayout { button }
            GroupLayout { label }
        }
        
        XCTAssertEqual(typeString(of: layout), "SuperSubLayout<UIView, PairLayout<GroupLayout<UIButton>, GroupLayout<UILabel>>>")
    }
    
}

func typeString<T>(of value: T) -> String {
    String(describing: type(of: value))
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
