//
//  ReferenceTests.swift
//  
//
//  Created by maylee on 2022/03/05.
//

import XCTest
import SwiftLayout

class ReferenceTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
    }
    
    var view: SelfReferenceView?
    weak var weakView: UIView?
    
    func test1JustForPrepare() {
        DeinitView.deinitCount = 0
        view = SelfReferenceView()
        weakView = view
        
        view?.updateLayout()
        view?.layoutIfNeeded()
        view = nil
    }
    
    func test2ForReferenceReleasing() {
        XCTAssertNil(weakView)
        XCTAssertEqual(DeinitView.deinitCount, 2)
    }
    
    class DeinitView: UIView {
        static var deinitCount: Int = 0
        
        deinit {
            Self.deinitCount += 1
        }
    }
    
    class SelfReferenceView: UIView, LayoutBuilding {
        var layout: some Layout {
            self {
                DeinitView().anchors {
                    Anchors.allSides()
                }.sublayout {
                    DeinitView()
                }
            }
        }
        
        var deactivable: Deactivable?
    }
}
