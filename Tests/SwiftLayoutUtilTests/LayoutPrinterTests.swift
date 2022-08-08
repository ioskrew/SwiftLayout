//
//  LayoutPrinterTests.swift
//  
//
//  Created by aiden_h on 2022/04/01.
//

import XCTest
import SwiftLayout
import SwiftLayoutUtil

class LayoutPrinterTests: XCTestCase {
    
    let root: UIView = UIView().identifying("root")
    let contentView: UIView = UIView().identifying("contentView")
    let image: UIImageView = UIImageView().identifying("image")
    let title: UILabel = UILabel().identifying("title")
    let descriptionLabel: UILabel = UILabel().identifying("descriptionLabel")
    
    var layout: some Layout {
        root.sublayout {
            contentView.anchors {
                Anchors.leading.equalTo(root.safeAreaLayoutGuide, constant: 16.0)
                Anchors.trailing.equalTo(root.safeAreaLayoutGuide, constant: -16.0)
                Anchors.centerY.equalTo(root)
                Anchors.height.equalTo(constant: 80.0)
            }.sublayout {
                image.anchors {
                    Anchors.leading.equalToSuper(constant: 10.0)
                    Anchors.centerY
                    Anchors.size(width: 70, height: 70)
                }
                
                title.anchors {
                    Anchors.top.equalToSuper(constant: 8.0)
                    Anchors.leading.equalTo(image, attribute: .trailing, constant: 10.0)
                    Anchors.height.equalTo(constant: 24.0)
                }.anyLayout
                
                descriptionLabel.anchors {
                    Anchors.top.equalTo(title, attribute: .bottom, constant: 5.0)
                    Anchors.leading.equalTo(image, attribute: .trailing, constant: 10.0)
                    Anchors.bottom.equalToSuper(constant: -8.0)
                    Anchors.trailing.equalToSuper(constant: -10.0)
                }
            }
        }
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }
}

extension LayoutPrinterTests {
    func testLayoutPrinterPrint() {
        
        let expectedResult = """
        ViewLayout - view: root
        └─ ViewLayout - view: contentView
           └─ TupleLayout
              ├─ ViewLayout - view: image
              ├─ AnyLayout
              │  └─ ViewLayout - view: title
              └─ ViewLayout - view: descriptionLabel
        """
        
        XCTAssertEqual(LayoutPrinter(layout).description, expectedResult)
    }
    
    func testLayoutPrinterPrintWithAnchors() {

        let expectedResult = """
        ViewLayout - view: root
        └─ ViewLayout - view: contentView
           │     .leading == root.safeAreaLayoutGuide.leading + 16.0
           │     .trailing == root.safeAreaLayoutGuide.trailing - 16.0
           │     .centerY == root.centerY
           │     .height == + 80.0
           └─ TupleLayout
              ├─ ViewLayout - view: image
              │        .leading == superview.leading + 10.0
              │        .centerY == superview.centerY
              │        .width == + 70.0
              │        .height == + 70.0
              ├─ AnyLayout
              │  └─ ViewLayout - view: title
              │           .top == superview.top + 8.0
              │           .leading == image.trailing + 10.0
              │           .height == + 24.0
              └─ ViewLayout - view: descriptionLabel
                       .top == title.bottom + 5.0
                       .leading == image.trailing + 10.0
                       .bottom == superview.bottom - 8.0
                       .trailing == superview.trailing - 10.0
        """
        
        XCTAssertEqual(LayoutPrinter(layout, withAnchors: true).description, expectedResult)
    }
}
