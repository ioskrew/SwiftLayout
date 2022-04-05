//
//  XCTViewAssert.swift
//  
//
//  Created by oozoofrog on 2022/04/04.
//

import Foundation
@testable import SwiftLayout
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

func SLTAssertConstraintsEqual(_ constraints: [NSLayoutConstraint],
                               firstView: UIView, secondView: UIView, tags: [UIView: String] = [:],
                               sorted: Bool = true,
                               @AnchorsBuilder anchors: () -> AnchorsContainer,
                               file: StaticString = #filePath, line: UInt = #line) {
    SLTAssertConstraintsEqual(constraints, anchors().constraints(item: firstView, toItem: secondView), tags: tags, sorted: sorted, file: file, line: line)
}

func SLTAssertConstraintsEqual(_ constraints: [NSLayoutConstraint],
                               firstView: UIView, tags: [UIView: String] = [:],
                               sorted: Bool = true,
                               @AnchorsBuilder anchors: () -> AnchorsContainer,
                               file: StaticString = #filePath, line: UInt = #line) {
    SLTAssertConstraintsEqual(constraints, anchors().constraints(item: firstView, toItem: nil), tags: tags, sorted: sorted, file: file, line: line)
}

func SLTAssertConstraintsEqual(_ constraints: [NSLayoutConstraint],
                               tags: [UIView: String] = [:],
                               sorted: Bool = true,
                               @TestAnchorsBuilder anchors: () -> [NSLayoutConstraint],
                               file: StaticString = #filePath, line: UInt = #line) {
    SLTAssertConstraintsEqual(constraints, anchors(), tags: tags, sorted: sorted, file: file, line: line)
}

func SLTAssertConstraintsIsEmpty(_ constraints: [NSLayoutConstraint], tags: [UIView: String] = [:], sorted: Bool = true, file: StaticString = #filePath, line: UInt = #line) {
    SLTAssertConstraintsEqual(constraints, [], tags: tags, sorted: sorted, file: file, line: line)
}

func SLTAssertConstraintsEqual(_ constraints1: [NSLayoutConstraint],
                               _ constraints2: [NSLayoutConstraint],
                               tags: [UIView: String] = [:],
                               sorted: Bool = true,
                               file: StaticString = #filePath, line: UInt = #line) {
    let descriptions1: [String]
    let descriptions2: [String]
    if sorted {
        descriptions1 = constraints1.map(testDescriptionFromConstraint(tags)).sorted()
        descriptions2 = constraints2.map(testDescriptionFromConstraint(tags)).sorted()
    } else {
        descriptions1 = constraints1.map(testDescriptionFromConstraint(tags))
        descriptions2 = constraints2.map(testDescriptionFromConstraint(tags))
    }
    let diffs = descriptions2.difference(from: descriptions1)
    var failInsertDescriptions: [String] = []
    var failRemoveDescriptions: [String] = []
    for diff in diffs {
        switch diff {
        case let .insert(_, element: description, _):
            failInsertDescriptions.append("[\(description)] should be inserted")
        case let .remove(_, element: description, _):
            failRemoveDescriptions.append("[\(description)] should be removed")
        }
    }
    if failInsertDescriptions.isEmpty && failRemoveDescriptions.isEmpty {
        return
    }
    XCTFail("+\(failInsertDescriptions.count), -\(failRemoveDescriptions.count) constraints\n"
                .appending(failInsertDescriptions.joined(separator: "\n"))
                .appending("\n")
                .appending(failRemoveDescriptions.joined(separator: "\n")),
            file: file,
            line: line)
}

private func testDescriptionFromConstraint(_ tags: [UIView: String] = [:]) -> (_ constraint: NSLayoutConstraint) -> String {
    { constraint in
        var description = constraint.debugDescription
        for tag in tags {
            let typeAndAddress = typeAndAddressFromView(tag.key)
            description = description.replacingOccurrences(of: typeAndAddress, with: tag.value)
        }
        let typeErased = description.replacingRegex(of: "NSLayoutConstraint:0x[0-9a-f]+ ")
        let stateErased = typeErased.replacingRegex(of: "(inactive|active)").dropFirst().description
        let namesErased = stateErased.replacingRegex(of: "[:space:]+\\([:print:]+")
        return namesErased
    }
}

private func typeAndAddressFromView(_ view: UIView) -> String {
    view.debugDescription.dropFirst().description.replacingRegex(of: ";[:print:]+").replacingOccurrences(of: " ", with: "")
}

private extension String {
    func replacingRegex(of: String, with: String = "") -> String {
        replacingOccurrences(of: of, with: with, options: .regularExpression, range: startIndex..<endIndex)
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

struct TestAnchors {
    let constraints: [NSLayoutConstraint]
    init(first: NSObject, second: NSObject? = nil, @AnchorsBuilder anchors: () -> AnchorsContainer) {
        self.constraints = anchors().constraints(item: first, toItem: second)
    }
}

@resultBuilder
struct TestAnchorsBuilder {
    static func buildBlock(_ components: TestAnchors...) -> [NSLayoutConstraint] {
        components.flatMap(\.constraints)
    }
}
