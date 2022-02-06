//
//  LayoutBuildingTests.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import XCTest
import UIKit
@testable import SwiftLayout

class LayoutBuildingTests: XCTestCase {
    
    var vc: ViewController!
    
    override func setUpWithError() throws {
        vc = ViewController(nibName: nil, bundle: nil)
        vc.preferredContentSize = CGSize(width: 1284, height: 2778)
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewControllerWithLayoutBuilding() throws {
        
        vc.flag = true
        XCTAssertEqual(vc.root.superview, vc.view)
        XCTAssertEqual(vc.flagged.superview, vc.root)
        XCTAssertNil(vc.noflagged.superview)
        
        vc.flag = true
        XCTAssertEqual(vc.root.superview, vc.view)
        XCTAssertEqual(vc.flagged.superview, vc.root)
        XCTAssertNil(vc.noflagged.superview)
        
        vc.flag = false
        XCTAssertEqual(vc.root.superview, vc.view)
        XCTAssertEqual(vc.noflagged.superview, vc.root)
        XCTAssertNil(vc.flagged.superview)
        
        vc.flag = true
        let flaggedHashable = vc.layout.hashable
        let flaggedHashable2 = vc.layout.hashable
        XCTAssertEqual(flaggedHashable, flaggedHashable2)
        vc.flag = false
        let noFlaggedHashable = vc.layout.hashable
        XCTAssertNotEqual(flaggedHashable, noFlaggedHashable)
    }

}

final class ViewController: UIViewController, LayoutBuilding {
    
    var root = UIView().viewTag.root
    var flagged = UIButton().viewTag.flagged
    var noflagged: UILabel = {
        let label = UILabel()
        label.text = "no flagged"
        return label.viewTag.noflagged
    }()
    
    var flag: Bool = true {
        didSet { update() }
    }
    
    var updateCount = 0
    var deactivatable: AnyDeactivatable? {
        didSet {
            
        }
    }
    
    var layout: some Layout {
        self.view {
            root.constraint(.top, .leading, .trailing, .bottom).layout {
                if self.flag {
                    flagged.constraint(.top, .leading, .trailing, .bottom)
                } else {
                    noflagged.constraint(.top, .leading, .trailing, .bottom)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = view.viewTag.viewController
        
        update()
    }
    
}
