//
//  ImplementationTest.swift
//  
//
//  Created by aiden_h on 2022/02/11.
//

import XCTest
@testable import SwiftLayout

final class ImplementationTest: XCTestCase {
 
    func testReeraseToAnyDeactivatable() {
        // given
        let view = UIView()
        let anyDeactivatable: AnyDeactivatable = view.active()
        
        // when
        let reerased: AnyDeactivatable = anyDeactivatable.eraseToAnyDeactivatable()
        
        // then
        XCTAssertTrue(anyDeactivatable === reerased)
    }
    
    func testViewStrongReferenceCycle() {
        // given
        class SelfReferenceView: UIView, LayoutBuilding {
            var layout: some Layout {
                self {
                    UIView()
                }
            }
            
            var deactivatable: AnyDeactivatable?
        }
        
        var view: SelfReferenceView? = SelfReferenceView()
        weak var weakView: UIView? = view
        
        // when
        view?.updateLayout()
        view = nil
        
        // then
        XCTAssertNil(weakView)
    }
}
    
