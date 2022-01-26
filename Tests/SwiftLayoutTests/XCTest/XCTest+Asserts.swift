//
//  XCTest+Asserts.swift
//  
//
//  Created by oozoofrog on 2022/01/21.
//

import Foundation
import XCTest
import SwiftLayout

func XCTAssertLayoutEqual(_ expression1: Layoutable, _ expression2: Layoutable) {
    if expression1.debugDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        XCTFail("expression1 is empty")
    }
    if expression2.debugDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        XCTFail("expression2 is empty")
    }
    XCTAssertEqual(expression1.debugDescription, expression2.debugDescription)
}

func XCTAssertLayoutNotEqual(_ expression1: Layoutable, _ expression2: Layoutable) {
    if expression1.debugDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        XCTFail("expression1 is empty")
    }
    if expression2.debugDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        XCTFail("expression2 is empty")
    }
    XCTAssertNotEqual(expression1.debugDescription, expression2.debugDescription)
}
