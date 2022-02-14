//
//  ImplementationTest.swift
//  
//
//  Created by aiden_h on 2022/02/11.
//

import XCTest
@testable import SwiftLayout

var deinitCount: Int = 0
final class ImplementationTest: XCTestCase {
   
    func testViewStrongReferenceCycle() {
                
        class DeinitView: UIView {
            deinit {
                deinitCount += 1
            }
        }
        
        // given
        class SelfReferenceView: UIView, LayoutBuilding {
            var layout: some Layout {
                self {
                    DeinitView().anchors {
                        Anchors.boundary
                    }.subviews {
                        DeinitView()
                    }
                }
            }
            
            var deactivatable: Deactivable?
        }
        
        var view: SelfReferenceView? = SelfReferenceView()
        weak var weakView: UIView? = view
        
        // when
        view?.updateLayout()
        view = nil
        
        // then
        XCTAssertNil(weakView)
        XCTAssertEqual(deinitCount, 2)
    }
    
    func testLayoutFlattening() {
        let root = UIView()
        let child = UIView()
        let friend = UIView()
        let layout: some Layout = root {
            child.anchors {
                Anchors.boundary
            }.subviews {
                friend.anchors {
                    Anchors.boundary
                }
            }
        }
        
        XCTAssertNotNil(layout)
        XCTAssertEqual(layout.layoutViews.map(\.view), [root, child, friend])
    }
    
    func testLayoutCompare() {
        let root = UIView()
        let child = UIView()
        let friend = UIView()
        
        let f1 = root {
            child
        }.prepare()
        
        let f2 = root {
           child
        }.prepare()
        
        let f3 = root {
            child.anchors { Anchors.boundary }
        }.prepare()
        
        let f4 = root {
            child.anchors { Anchors.boundary }
        }.prepare()
        
        let f5 = root {
            child.anchors { Anchors.cap }
        }.prepare()
        
        let f6 = root {
            friend.anchors { Anchors.boundary }
        }.prepare()
        
        XCTAssertEqual(f1.layoutViews, f2.layoutViews)
        XCTAssertEqual(f1.constraintReferences, f2.constraintReferences)
        
        XCTAssertEqual(f3.layoutViews, f4.layoutViews)
        XCTAssertEqual(f3.constraintReferences, f4.constraintReferences)
        
        XCTAssertEqual(f4.layoutViews, f5.layoutViews)
        XCTAssertNotEqual(f4.constraintReferences, f5.constraintReferences)
        
        XCTAssertNotEqual(f5.layoutViews, f6.layoutViews)
        XCTAssertNotEqual(f5.constraintReferences, f6.constraintReferences)
        
    }
    
    class MockView: UIView {
        var addSubviewCount = 0
        override func addSubview(_ view: UIView) {
            addSubviewCount += 1
            super.addSubview(view)
        }
    }
    
    class LayoutView: UIView, LayoutBuilding {
        
        var flag = true
        
        let root = MockView()
        let child = UIView().viewTag.child
        let friend = UIView().viewTag.friend
        
        var deactivatable: Deactivable?
        
        var layout: some Layout {
            root {
                if flag {
                    child.anchors {
                        Anchors.boundary
                    }
                } else {
                    friend.anchors {
                        Anchors.boundary
                    }
                }
            }
        }
    }
    
    func testUpdateLayout() {

        let view = LayoutView()
        let root = view.root
        view.updateLayout()
        
        XCTAssertEqual(root.addSubviewCount, 1)
        
        view.updateLayout()
        
        XCTAssertEqual(root.addSubviewCount, 1)
        XCTAssertEqual(root.findConstraints(items: (view.child, root)).count, 4)
        XCTAssertEqual(view.child.superview, root)
        XCTAssertNil(view.friend.superview)
        
        view.flag.toggle()
        view.updateLayout()
        
        XCTAssertEqual(root.addSubviewCount, 2)
        XCTAssertEqual(root.findConstraints(items: (view.friend, root)).count, 4)
        XCTAssertEqual(view.friend.superview, root)
        XCTAssertNil(view.child.superview)
    }
    
    func testIdentifier() {
        let root = UIView().viewTag.root
        let deactivation = root {
            UILabel().identifying("label").anchors {
                Anchors.boundary
            }
        }.active() as? Deactivation
        
        XCTAssertNotNil(deactivation?.viewForIdentifier("label"))
    }
}
    
