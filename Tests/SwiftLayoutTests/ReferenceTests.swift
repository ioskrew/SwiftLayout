//
//  ReferenceTests.swift
//  
//
//  Created by oozoofrog on 2022/03/05.
//

import XCTest
import SwiftLayout

class ReferenceTests: XCTestCase {
    
    var view: SelfReferenceView?
    weak var weakView: SLView?
    
    func testReferenceReleasing() {
        context("prepare") { [weak self] in
            guard let self = self else { return }
            DeinitView.deinitCount = 0
            self.view = SelfReferenceView()
            self.weakView = view
            
            self.view?.sl.layout()
            self.view = nil
        }
        context("check release reference") {
            XCTAssertNil(weakView)
            XCTAssertEqual(DeinitView.deinitCount, 2)
        }
    }
    
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}
    
    class DeinitView: SLView {
        static var deinitCount: Int = 0
        
        deinit {
            Self.deinitCount += 1
        }
    }
    
    class SelfReferenceView: SLView, Layoutable {
        var layout: some Layout {
            self {
                DeinitView().anchors {
                    Anchors.allSides()
                }.sublayout {
                    DeinitView()
                }
            }
        }
        
        var activation: Activation? 
    }
}
