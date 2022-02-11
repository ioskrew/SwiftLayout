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
        
        let flattening = layout as? LayoutFlattening
        
        XCTAssertNotNil(flattening)
    }
    
    func testLayoutCompare() {
        let root = UIView()
        let child = UIView()
        let friend = UIView()
        
        let f1 = root {
            child
        }.flattening()
        
        let f2 = root {
           child
        }.flattening()
        
        let f3 = root {
            child.anchors { Anchors.boundary }
        }.flattening()
        
        let f4 = root {
            child.anchors { Anchors.boundary }
        }.flattening()
        
        let f5 = root {
            child.anchors { Anchors.cap }
        }.flattening()
        
        let f6 = root {
            friend.anchors { Anchors.boundary }
        }.flattening()
        
        XCTAssertEqual(f1?.viewReferences, f2?.viewReferences)
        XCTAssertEqual(f1?.constraintReferences, f2?.constraintReferences)
        
        XCTAssertEqual(f3?.viewReferences, f4?.viewReferences)
        XCTAssertEqual(f3?.constraintReferences, f4?.constraintReferences)
        
        XCTAssertEqual(f4?.viewReferences, f5?.viewReferences)
        XCTAssertNotEqual(f4?.constraintReferences, f5?.constraintReferences)
        
        XCTAssertNotEqual(f5?.viewReferences, f6?.viewReferences)
        XCTAssertNotEqual(f5?.constraintReferences, f6?.constraintReferences)
        
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
        let child = UIView()
        let friend = UIView()
        
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
        XCTAssertEqual(root.constraints.count, 4)
        XCTAssertEqual(view.child.superview, root)
        XCTAssertNil(view.friend.superview)
        
        view.flag.toggle()
        view.updateLayout()
        
        XCTAssertEqual(root.addSubviewCount, 2)
        XCTAssertEqual(root.constraints.count, 4)
        XCTAssertEqual(view.friend.superview, root)
        XCTAssertNil(view.child.superview)
    }
}
    
