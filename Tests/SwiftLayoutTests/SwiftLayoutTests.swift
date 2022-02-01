import XCTest
import UIKit
@testable import SwiftLayout

final class SwiftLayoutTests: XCTestCase {
    
    var superview: UIView = UIView().viewTag.superview
    
    var root: UIView = UIView().viewTag.root
    var button: UIButton = UIButton().viewTag.button
    var label: UILabel = UILabel().viewTag.label
    var redView: UIView = {
        let view = UIView().viewTag.redView
        view.backgroundColor = .red
        return view
    }()
    var image: UIImageView = UIImageView().viewTag.image
    
    var deactivable: AnyDeactivatable?
    
    override func setUp() {
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
        deactivable = root {
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
        deactivable = root {
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
        deactivable = root {
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
        deactivable = root {
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
        
        self.deactivable = root {
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
        
        self.deactivable = layout.active()
        
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
        
        self.deactivable = layout.active()
        
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
        self.deactivable = layout.active()
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
        self.deactivable = layout.active()
        XCTAssertEqual(label.superview, root)
        XCTAssertNil(button.superview)
    }
    
    func testActiveDeactiveAndExludes() {
        context("layout hierarchy에 속하지 않는 subviews는") {
            root.addSubview(redView)
            context("root layout의 deactive 시에도") {
                self.deactivable = root { button }.active()
                XCTAssertEqual(button.superview, root)
                self.deactivable?.deactive()
                XCTAssertNil(button.superview)
                context("남아있다") {
                    XCTAssertEqual(redView.superview, root)
                }
            }
        }
    }
    
    func testLayoutTree() {
        let green = UIView().viewTag.green
        green.backgroundColor = .green
        let blue = UIView().viewTag.blue
        blue.backgroundColor = .blue
        let layout: some Layout = root {
            redView {
                green {
                    blue
                }
                button
            }
        }
        deactivable = layout.active()
        XCTAssertEqual(button.superview, redView, button.superview!.tagDescription)
        XCTAssertEqual(green.superview, redView)
        XCTAssertEqual(blue.superview, green)
        XCTAssertEqual(redView.superview, root, redView.superview!.tagDescription)
    }
    
    func testDeactivable() {
        superview.addSubview(root)
        deactivable = root {
            redView {
                button
            }
        }.active()
        XCTAssertEqual(button.superview, redView, button.superview!.tagDescription)
        XCTAssertEqual(redView.superview, root)
        XCTAssertEqual(root.superview, superview)
        
        deactivable?.deactive()
        XCTAssertNil(button.superview)
        XCTAssertNil(redView.superview)
        XCTAssertEqual(root.superview, superview)
        
        deactivable?.active()
        XCTAssertEqual(button.superview, redView, button.superview!.tagDescription)
        XCTAssertEqual(redView.superview, root)
        XCTAssertEqual(root.superview, superview)
    }
    
    func testMultipleLayoutActive() {
        let first = root {
            button
        }
        
        let second = root {
            label
        }
        
        deactivable = first.active()
        
        deactivable?.bind(second)
        XCTAssertEqual(button.superview, root)
        XCTAssertNil(label.superview)
        
        deactivable?.active(second)
        XCTAssertNil(button.superview)
        XCTAssertEqual(label.superview, root)
        
        deactivable?.active(first)
        XCTAssertEqual(button.superview, root)
        XCTAssertNil(label.superview)
        
        deactivable = second.active()
        XCTAssertNil(button.superview)
        XCTAssertEqual(label.superview, root)
        
        deactivable = first.active()
        XCTAssertEqual(button.superview, root)
        XCTAssertNil(label.superview)
        
        XCTAssertTrue(deactivable!.layoutIsActivating(first))
        XCTAssertFalse(deactivable!.layoutIsActivating(second))
                      
        XCTAssertTrue(first.isActivating)
        XCTAssertFalse(second.isActivating)
        
//        deactivable?.deactive()
        deactivable = nil
        XCTAssertNil(button.superview)
        XCTAssertNil(label.superview)
    }
    
    func testHashable() {
        let first = root {
            button
        }
        
        let first2 = root {
            button
        }
        
        let first3 = root {
            UIButton().viewTag.button2
        }
        
        XCTAssertEqual(first, first2)
        XCTAssertNotEqual(first, first3)
        
        let second = root {
            if true {
                button
            }
        }
        
        XCTAssertNotEqual(first.hashable, second.hashable)
        
        deactivable = first.active()
        deactivable?.bind(second)
        XCTAssertEqual(button.superview, root)
        
        deactivable?.active(second)
        XCTAssertEqual(button.superview, root)
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
