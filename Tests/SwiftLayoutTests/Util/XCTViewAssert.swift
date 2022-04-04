//
//  XCTViewAssert.swift
//  
//
//  Created by oozoofrog on 2022/04/04.
//

import Foundation
import SwiftLayout
import XCTest

public func SLTAssertView(view: UIView, superview: UIView?, subviews: UIView..., file: StaticString = #filePath, line: UInt = #line) {
    if view.superview != superview {
        if let superviewForView = view.superview, let superview = superview {
            XCTFail("view.superview(\(superviewForView.testDescription)) is not equal to superview(\(superview.testDescription))", file: file, line: line)
            return
        } else if let superviewForView = view.superview {
            XCTFail("view.superview(\(superviewForView.testDescription)) is not equal to superview(nil)", file: file, line: line)
            return
        } else if let superview = superview {
            XCTFail("view.superview(nil) is not equal to superview(\(superview.testDescription))", file: file, line: line)
            return
        }
    }
    let subviewsInView = view.subviews.map(\.testDescription)
    let subviewsForTest = subviews.map(\.testDescription)
    if !subviewsInView.elementsEqual(subviewsForTest) {
        XCTFail("view.subviews(\(subviewsInView.count))[\(subviewsInView.joined(separator: ", "))] is not equal to subviews(\(subviewsForTest.count))[\(subviewsForTest.joined(separator: ", "))]", file: file, line: line)
    }
}

private extension UIAccessibilityIdentification {
    var testDescription: String {
        if let identifier = accessibilityIdentifier {
            return "<\(type(of: self)): \(identifier)>"
        } else {
            return "<\(type(of: self)): \(Unmanaged.passUnretained(self).toOpaque())>"
        }
    }
}
