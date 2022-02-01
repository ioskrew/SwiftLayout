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
    
    func testGroupLayoutActive() {
        
        let a = UIView().viewTag.a
        let b = UIView().viewTag.b
        let c = UIView().viewTag.c
        layout = root {
            GroupLayout {
                button
                redView
            }
            GroupLayout {
                label
                image
                a
                b
                c
            }
        }.active()
        
        XCTAssertEqual(Set(root.subviews), Set([a, b, c, button, redView, label, image]))
    }
    
    func testOptionalLayoutIsExist() {
        
        let optionalView: UIView? = UIView()
        
        let layout: some Layout = root {
            optionalView
        }
        
        XCTAssertEqual(typeString(of: layout), "SuperSubLayout<UIView, Optional<UIView>>")
        
        self.layout = root {
            optionalView
            button
        }.active()
        
        XCTAssertEqual(optionalView?.superview, root)
        XCTAssertEqual(button.superview, root)
    }
   
    func testOptionalTrueLayout() {
        let flag = true
        let layout: some Layout = root {
            if flag {
                button
            }
        }
        
        XCTAssertEqual(typeString(of: layout), "SuperSubLayout<UIView, Optional<UIButton>>")
        
        self.layout = layout.active()
        
        XCTAssertEqual(button.superview, root)
    }
    
    func testOptionalFalseLayoutSubviewsOfRootViewIsEmpty() {
        let flag = false
        let layout: some Layout = root {
            if flag {
                button
            }
        }
        
        XCTAssertEqual(typeString(of: layout), "SuperSubLayout<UIView, Optional<UIButton>>")
        
        self.layout = layout.active()
        
        XCTAssertEqual(root.subviews, [])
    }
    
    func testEitherTrue() {
        let flag = true
        
        @LayoutBuilder
        func build() -> some Layout {
            root {
                if flag {
                    button
                } else {
                    label
                }
            }
        }
        
        let layout: some Layout = build()
        XCTAssertEqual(typeString(of: layout), "SuperSubLayout<UIView, EitherLayout<UIButton, UILabel>>")
        self.layout = layout.active()
        XCTAssertEqual(button.superview, root)
        XCTAssertNil(label.superview)
    }
    
    func testEitherFalse() {
        let flag = false
        
        @LayoutBuilder
        func build() -> some Layout {
            root {
                if flag {
                    button
                } else {
                    label
                }
            }
        }
        
        let layout: some Layout = build()
        XCTAssertEqual(typeString(of: layout), "SuperSubLayout<UIView, EitherLayout<UIButton, UILabel>>")
        self.layout = layout.active()
        XCTAssertEqual(label.superview, root)
        XCTAssertNil(button.superview)
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
