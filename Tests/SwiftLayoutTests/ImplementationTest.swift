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
}
    
