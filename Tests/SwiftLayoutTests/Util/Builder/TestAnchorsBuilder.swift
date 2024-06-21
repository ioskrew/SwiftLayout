//
//  XCTViewAssert.swift
//  

import Foundation
import UIKit
@testable import SwiftLayout

@MainActor
struct TestAnchors {
    let constraints: [NSLayoutConstraint]
    init(first: NSObject, second: NSObject? = nil, @AnchorsBuilder anchors: () -> Anchors) {
        self.constraints = anchors().constraints(item: first, toItem: second)
    }
}

@resultBuilder
struct TestAnchorsBuilder {
    static func buildBlock(_ components: TestAnchors...) -> [NSLayoutConstraint] {
        components.flatMap(\.constraints)
    }
}
