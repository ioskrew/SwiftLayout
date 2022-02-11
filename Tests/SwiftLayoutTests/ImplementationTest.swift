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
}
    
