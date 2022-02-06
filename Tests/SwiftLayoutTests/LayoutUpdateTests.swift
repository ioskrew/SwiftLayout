//
//  LayoutUpdateTests 2.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import XCTest
@testable import SwiftLayout

class LayoutUpdateTests: XCTestCase {

    var deactivatable = AnyDeactivatable()
    
    var root = UIView().viewTag.root
    var flagged = UIView().viewTag.flagged
    var noflagged = UIView().viewTag.noflagged
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSimpleUpdating() throws {
        var flag = true
        
        let holder = ViewHolder { [weak self] in
            self?.root { [weak self] in
                if flag {
                    self?.flagged
                } else {
                    self?.noflagged
                }
            }
        }
        
        deactivatable = holder.update()
        XCTAssertEqual(flagged.superview, root)
        XCTAssertNil(noflagged.superview)
        
        flag.toggle()
        deactivatable = holder.update()
        XCTAssertEqual(noflagged.superview, root)
        XCTAssertNil(flagged.superview)
    }

}

struct ViewHolder {
    
    @LayoutBuilder
    let content: () -> Layout
    
    init(@LayoutBuilder _ content: @escaping () -> Layout) {
        self.content = content
    }
    
    func update() -> AnyDeactivatable {
        self.content().active()
    }
    
}
