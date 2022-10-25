//
//  SLTAssertConstraintsFunctions.swift
//

import Foundation
import UIKit
import XCTest
@testable import SwiftLayout

func SLTAssertConstraintsHasSameElements(_ constraints: [NSLayoutConstraint],
                                         firstView: UIView, secondView: UIView, tags: [UIView: String] = [:],
                                         @AnchorsBuilder anchors: () -> Anchors,
                                         file: StaticString = #filePath, line: UInt = #line) {
    SLTAssertConstraintsHasSameElements(constraints, anchors().constraints(item: firstView, toItem: secondView), tags: tags, file, line)
}

func SLTAssertConstraintsHasSameElements(_ constraints: [NSLayoutConstraint],
                                         firstView: UIView, tags: [UIView: String] = [:],
                                         @AnchorsBuilder anchors: () -> Anchors,
                                         file: StaticString = #filePath, line: UInt = #line) {
    SLTAssertConstraintsHasSameElements(constraints, anchors().constraints(item: firstView, toItem: nil), tags: tags, file, line)
}

func SLTAssertConstraintsHasSameElements(_ constraints: [NSLayoutConstraint],
                                         tags: [UIView: String] = [:],
                                         @TestAnchorsBuilder anchors: () -> [NSLayoutConstraint],
                                         file: StaticString = #filePath, line: UInt = #line) {
    SLTAssertConstraintsHasSameElements(constraints, anchors(), tags: tags, file, line)
}

func SLTAssertConstraintsIsEmpty(_ constraints: [NSLayoutConstraint], tags: [UIView: String] = [:], file: StaticString = #filePath, line: UInt = #line) {
    SLTAssertConstraintsHasSameElements(constraints, [], tags: tags, file, line)
}

func SLTAssertConstraintsHasSameElements(_ constraints1: [NSLayoutConstraint],
                                         _ constraints2: [NSLayoutConstraint],
                                         tags: [UIView: String] = [:],
                                         _ file: StaticString = #filePath, _ line: UInt = #line) {
    let descriptions1: [String] = constraints1.map(testDescriptionFromConstraint(tags)).sorted()
    let descriptions2: [String] = constraints2.map(testDescriptionFromConstraint(tags)).sorted()

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
    XCTFail(
        "+\(failInsertDescriptions.count), -\(failRemoveDescriptions.count) constraints\n"
            .appending(failInsertDescriptions.joined(separator: "\n"))
            .appending("\n")
            .appending(failRemoveDescriptions.joined(separator: "\n")),
        file: file,
        line: line
    )
}

func SLTAssertConstraintsEqual(_ constraints1: [NSLayoutConstraint], _ constraints2: [NSLayoutConstraint], _ tags: [UIView : String] = [:], _ file: StaticString = #file, _ line: UInt = #line) {
    let descriptions1: [String] = constraints1.map(testDescriptionFromConstraint(tags))
    let descriptions2: [String] = constraints2.map(testDescriptionFromConstraint(tags))

    if descriptions1.elementsEqual(descriptions2) {
        return
    }
    
    func middle(_ count: Int, _ lcount: Int, _ rcount: Int, _ state: String) -> String {
        let count = count - 2
        let middleCount = count / 2 + count % 2
        let leftCount = middleCount - lcount
        let rightCount = middleCount - rcount
        let leftMiddle = " ".appending([String](repeating: "-", count: leftCount).joined())
        let rightMiddle = [String](repeating: "-", count: rightCount).joined().appending(" ")
        return leftMiddle.appending(state).appending(rightMiddle)
    }
    
    let lineLength = (descriptions1.map(\.count).max() ?? 0) + (descriptions2.map(\.count).max() ?? 0) + 5
    var failInformations: [String] = []
    let totalCount = max(descriptions1.count, descriptions2.count)
    let indexFormat = "%\(totalCount / 10 + 1)d"
    for offset in 0..<totalCount {
        if offset < descriptions1.count, offset < descriptions2.count {
            let left = descriptions1[offset]
            let right = descriptions2[offset]
            let state = left == right ? "O" : "X"
            failInformations.append("\(String(format: indexFormat, offset + 1)) \(left)\(middle(lineLength, left.count, right.count, state))\(right)")
        } else if offset < descriptions1.count {
            failInformations.append(String(format: indexFormat, offset + 1).appending(descriptions1[offset]).appending(" ").appending([String](repeating: "-", count: lineLength - descriptions1[offset].count).joined()))
        } else if offset < descriptions2.count {
            failInformations.append("\(String(format: indexFormat, offset + 1)) ".appending([String](repeating: "-", count: lineLength - descriptions2[offset].count).joined()).appending(" ").appending(descriptions2[offset]))
        }
    }

    XCTFail(
        "\(descriptions2.count - descriptions1.count) constraints\n"
            .appending(failInformations.joined(separator: "\n")),
        file: file,
        line: line
    )
}

func SLTAssertConstraintsNotEqual(_ constraints1: [NSLayoutConstraint], _ constraints2: [NSLayoutConstraint], _ tags: [UIView : String] = [:], _ file: StaticString = #file, _ line: UInt = #line) {
    let descriptions1: [String] = constraints1.map(testDescriptionFromConstraint(tags))
    let descriptions2: [String] = constraints2.map(testDescriptionFromConstraint(tags))

    if descriptions1.elementsEqual(descriptions2) == false {
        return
    }

    XCTFail(
        "\(descriptions1) is equal to \(descriptions2)",
        file: file,
        line: line
    )
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
