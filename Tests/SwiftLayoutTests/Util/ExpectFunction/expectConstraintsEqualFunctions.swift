//
//  expectConstraintsEqualFunctions.swift
//

import Foundation
@testable import SwiftLayout
import Testing
import UIKit

@MainActor
func hasSameElements(
    _ constraints1: [NSLayoutConstraint],
    _ constraints2: [NSLayoutConstraint],
    _ tags: [UIView: String] = [:]
) -> Bool {
    let descriptions1: [String] = constraints1.map(testDescriptionFromConstraint(tags)).sorted()
    let descriptions2: [String] = constraints2.map(testDescriptionFromConstraint(tags)).sorted()

    return descriptions1.elementsEqual(descriptions2)
}

@MainActor
func isEqual(
    _ constraints1: [NSLayoutConstraint],
    _ constraints2: [NSLayoutConstraint],
    _ tags: [UIView: String] = [:]
) -> Bool {
    let descriptions1: [String] = constraints1.map(testDescriptionFromConstraint(tags))
    let descriptions2: [String] = constraints2.map(testDescriptionFromConstraint(tags))

    return descriptions1.elementsEqual(descriptions2)
}

@MainActor
func isNotEqual(
    _ constraints1: [NSLayoutConstraint],
    _ constraints2: [NSLayoutConstraint],
    _ tags: [UIView: String] = [:]
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

extension Sequence where Element == NSLayoutConstraint {
    @MainActor
    func testDescriptions(_ tags: [UIView: String]) -> [String] {
        map(testDescriptionFromConstraint(tags))
    }
}
