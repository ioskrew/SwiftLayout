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
}
