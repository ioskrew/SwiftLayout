//
//  IdentifierUpdaterTests.swift
//  
//
//  Created by aiden_h on 2022/04/01.
//

import XCTest
import SwiftLayoutUtil

class IdentifierUpdaterTests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }
}

extension IdentifierUpdaterTests {
    func testNameOnly() {
        let id = ID()
        IdentifierUpdater.nameOnly.update(id)
        XCTAssertEqual(id.name.accessibilityIdentifier, "name")
        XCTAssertEqual(id.name.label.accessibilityIdentifier ?? "", "")
    }
    
    func testWithTypeOfView() {
        let id = ID()
        IdentifierUpdater.withTypeOfView.update(id)
        XCTAssertEqual(id.name.accessibilityIdentifier, "name:Name")
        XCTAssertEqual(id.name.label.accessibilityIdentifier ?? "", "")
    }
    
    func testReferenceAndName() {
        let id = ID()
        IdentifierUpdater.referenceAndName.update(id)
        XCTAssertEqual(id.name.accessibilityIdentifier, "name")
        XCTAssertEqual(id.name.label.accessibilityIdentifier, "name.label")
    }
    
    func testReferenceAndNameWithTypeOfView() {
        let id = ID()
        IdentifierUpdater.referenceAndNameWithTypeOfView.update(id)
        XCTAssertEqual(id.name.accessibilityIdentifier, "name:Name")
        XCTAssertEqual(id.name.label.accessibilityIdentifier, "name.label:\(UILabel.self)")
    }

    class Name: UIView {
        let label = UILabel()
    }
    
    class ID: UIView {
        let name = Name()
    }
    
    func testSetAccessibilityIdentifier() {
        class TestView: UIView {
            let contentView = UIView()
            let nameLabel = UILabel()
        }
        
        let view = TestView()
        IdentifierUpdater.withTypeOfView.update(view)
        
        XCTAssertEqual(view.contentView.accessibilityIdentifier, "contentView:\(UIView.self)")
        XCTAssertEqual(view.nameLabel.accessibilityIdentifier, "nameLabel:\(UILabel.self)")
        
        class Test2View: TestView {}
        
        let view2 = Test2View()
        IdentifierUpdater.withTypeOfView.update(view2)
        
        XCTAssertEqual(view2.contentView.accessibilityIdentifier, "contentView:\(UIView.self)")
        XCTAssertEqual(view2.nameLabel.accessibilityIdentifier, "nameLabel:\(UILabel.self)")
    }
}
