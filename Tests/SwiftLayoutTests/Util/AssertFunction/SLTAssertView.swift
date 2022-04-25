//
//  File.swift
//  
//
//  Created by oozoofrog on 2022/04/25.
//

import Foundation
import UIKit
import XCTest

func SLTAssertView(_ view: @autoclosure () throws -> UIView,
                   superview: @autoclosure () throws -> UIView?,
                   subviews: @autoclosure () throws -> [UIView]?,
                   file: StaticString = #filePath, line: UInt = #line) {
    do {
        let view = try view()
        let superview = try superview()
        let subviews = try subviews() ?? []
        if view.superview != superview {
            if let superviewForView = view.superview, let superview = superview {
                XCTFail("view<\(view.testDescription)>.superview(\(superviewForView.testDescription)) is not equal with superview<\(superview.testDescription)>", file: file, line: line)
                return
            } else if let superviewForView = view.superview {
                XCTFail("view<\(view.testDescription)>.superview<\(superviewForView.testDescription)> is not equal with superview<nil>", file: file, line: line)
                return
            } else if let superview = superview {
                XCTFail("view<\(view.testDescription)>.superview<nil> is not equal with superview<\(superview.testDescription)>", file: file, line: line)
                return
            }
        }
        let subviewsInView = view.subviews.map(\.testDescription)
        let subviewsForTest = subviews.map(\.testDescription)
        if !subviewsInView.elementsEqual(subviewsForTest) {
            XCTFail("view<\(view.testDescription)>.subviews(\(subviewsInView.count))[\(subviewsInView.joined(separator: ", "))] is not equal with subviews(\(subviewsForTest.count))[\(subviewsForTest.joined(separator: ", "))]", file: file, line: line)
        }
    } catch {
        XCTFail(error.localizedDescription, file: file, line: line)
    }
}

private extension UIAccessibilityIdentification {
    var testDescription: String {
        if let identifier = accessibilityIdentifier {
            return "\(type(of: self)): \(identifier)"
        } else {
            return "\(type(of: self)): \(Unmanaged.passUnretained(self).toOpaque())"
        }
    }
}
