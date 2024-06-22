//
//  expectConstraintsEqualFunctions.swift
//

import Foundation
import UIKit
import Testing
@testable import SwiftLayout

//@MainActor
//func SLTAssertConstraintsHasSameElements(
//    _ constraints: [NSLayoutConstraint],
//    firstView: UIView, secondView: UIView, tags: [UIView: String] = [:],
//    @AnchorsBuilder anchors: () -> Anchors,
//    _ fileID: String = #fileID,
//    _ filePath: String = #filePath,
//    _ line: Int = #line,
//    _ column: Int = #column
//) {
//    SLTAssertConstraintsHasSameElements(constraints, anchors().constraints(item: firstView, toItem: secondView), tags: tags, fileID, filePath, line, column)
//}
//
//@MainActor
//func SLTAssertConstraintsHasSameElements(
//    _ constraints: [NSLayoutConstraint],
//    firstView: UIView, tags: [UIView: String] = [:],
//    @AnchorsBuilder anchors: () -> Anchors,
//    _ fileID: String = #fileID,
//    _ filePath: String = #filePath,
//    _ line: Int = #line,
//    _ column: Int = #column
//) {
//    SLTAssertConstraintsHasSameElements(constraints, anchors().constraints(item: firstView, toItem: nil), fileID, filePath, line, column)
//}
//
//@MainActor
//func SLTAssertConstraintsHasSameElements(
//    _ constraints: [NSLayoutConstraint],
//    tags: [UIView: String] = [:],
//    @TestAnchorsBuilder anchors: () -> [NSLayoutConstraint],
//    _ fileID: String = #fileID,
//    _ filePath: String = #filePath,
//    _ line: Int = #line,
//    _ column: Int = #column
//) {
//    SLTAssertConstraintsHasSameElements(constraints, anchors(), fileID, filePath, line, column)
//}
//
//@MainActor
//func SLTAssertConstraintsIsEmpty(
//    _ constraints: [NSLayoutConstraint],
//    tags: [UIView: String] = [:],
//    _ fileID: String = #fileID,
//    _ filePath: String = #filePath,
//    _ line: Int = #line,
//    _ column: Int = #column
//) {
//    SLTAssertConstraintsHasSameElements(constraints, [], fileID, filePath, line, column)
//}
//
//@MainActor
//func SLTAssertConstraintsHasSameElements(
//    _ constraints1: [NSLayoutConstraint],
//    _ constraints2: [NSLayoutConstraint],
//    tags: [UIView: String] = [:],
//    _ fileID: String = #fileID,
//    _ filePath: String = #filePath,
//    _ line: Int = #line,
//    _ column: Int = #column
//) {
//    let descriptions1: [String] = constraints1.map(testDescriptionFromConstraint(tags)).sorted()
//    let descriptions2: [String] = constraints2.map(testDescriptionFromConstraint(tags)).sorted()
//
//    let diffs = descriptions2.difference(from: descriptions1)
//    var failInsertDescriptions: [String] = []
//    var failRemoveDescriptions: [String] = []
//    for diff in diffs {
//        switch diff {
//        case let .insert(_, element: description, _):
//            failInsertDescriptions.append("[\(description)] should be inserted")
//        case let .remove(_, element: description, _):
//            failRemoveDescriptions.append("[\(description)] should be removed")
//        }
//    }
//    if failInsertDescriptions.isEmpty && failRemoveDescriptions.isEmpty {
//        return
//    }
//
//    Issue.record(
//        Comment(
//            rawValue:
//                "+\(failInsertDescriptions.count), -\(failRemoveDescriptions.count) constraints\n"
//                    .appending(failInsertDescriptions.joined(separator: "\n"))
//                    .appending("\n")
//                    .appending(failRemoveDescriptions.joined(separator: "\n"))
//        ),
//        fileID: fileID,
//        filePath: filePath,
//        line: line,
//        column: column
//    )
//}

@MainActor
func isEqual(
    _ constraints1: [NSLayoutConstraint],
    _ constraints2: [NSLayoutConstraint],
    _ tags: [UIView : String] = [:]
) -> Bool {
    let descriptions1: [String] = constraints1.map(testDescriptionFromConstraint(tags)).sorted()
    let descriptions2: [String] = constraints2.map(testDescriptionFromConstraint(tags)).sorted()

    return descriptions1.elementsEqual(descriptions2)
}

@MainActor
func isNotEqual(
    _ constraints1: [NSLayoutConstraint],
    _ constraints2: [NSLayoutConstraint],
    _ tags: [UIView : String] = [:]
) -> Bool {
    let descriptions1: [String] = constraints1.map(testDescriptionFromConstraint(tags))
    let descriptions2: [String] = constraints2.map(testDescriptionFromConstraint(tags))

    return !descriptions1.elementsEqual(descriptions2)
}


@MainActor
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

@MainActor
private func typeAndAddressFromView(_ view: UIView) -> String {
    view.debugDescription.dropFirst().description.replacingRegex(of: ";[:print:]+").replacingOccurrences(of: " ", with: "")
}

private extension String {
    @MainActor
    func replacingRegex(of: String, with: String = "") -> String {
        replacingOccurrences(of: of, with: with, options: .regularExpression, range: startIndex..<endIndex)
    }
}
