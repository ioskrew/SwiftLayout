//
//  XCTViewAssert.swift
//  
//
//  Created by oozoofrog on 2022/04/04.
//

import Foundation
@testable import SwiftLayout
import XCTest

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
