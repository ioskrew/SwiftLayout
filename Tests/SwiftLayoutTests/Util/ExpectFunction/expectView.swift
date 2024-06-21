//
//  expeactView.swift
//  

import Foundation
import UIKit
import Testing

@MainActor
func expeactView(
    _ view: @autoclosure () throws -> UIView,
    superview: @autoclosure () throws -> UIView?,
    subviews: @autoclosure () throws -> [UIView]?,
    _ fileID: String = #fileID,
    _ filePath: String = #filePath,
    _ line: Int = #line,
    _ column: Int = #column
) throws {
    let view = try view()
    let superview = try superview()
    let subviews = try subviews() ?? []
    if view.superview != superview {
        if let superviewForView = view.superview, let superview = superview {
            Issue.record(
                Comment(rawValue: "view<\(view.testDescription)>.superview(\(superviewForView.testDescription)) is not equal with superview<\(superview.testDescription)>"),
                fileID: fileID,
                filePath: filePath,
                line: line,
                column: column
            )
            return
        } else if let superviewForView = view.superview {
            Issue.record(
                Comment(rawValue: "view<\(view.testDescription)>.superview<\(superviewForView.testDescription)> is not equal with superview<nil>"),
                fileID: fileID,
                filePath: filePath,
                line: line,
                column: column
            )
            return
        } else if let superview = superview {
            Issue.record(
                Comment(rawValue: "view<\(view.testDescription)>.superview<nil> is not equal with superview<\(superview.testDescription)>"),
                fileID: fileID,
                filePath: filePath,
                line: line,
                column: column
            )
            return
        }
    }
    let subviewsInView = view.subviews.map(\.testDescription)
    let subviewsForTest = subviews.map(\.testDescription)
    if !subviewsInView.elementsEqual(subviewsForTest) {
        Issue.record(
            Comment(rawValue: "view<\(view.testDescription)>.subviews(\(subviewsInView.count))[\(subviewsInView.joined(separator: ", "))] is not equal with subviews(\(subviewsForTest.count))[\(subviewsForTest.joined(separator: ", "))]"),
            fileID: fileID,
            filePath: filePath,
            line: line,
            column: column
        )
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
