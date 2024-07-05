//
//  Attribute+CaseIterable.swift
//  

import SwiftLayout
import UIKit

extension NSLayoutConstraint.Attribute: CaseIterable {
    public static var allCases: [NSLayoutConstraint.Attribute] {
        (0...20).compactMap {
            NSLayoutConstraint.Attribute(rawValue: $0)
        }
    }
}

extension AnchorsXAxisAttribute: CaseIterable {
    public static var allCases: [AnchorsXAxisAttribute] {
        NSLayoutConstraint.Attribute.allCases.compactMap { AnchorsXAxisAttribute(attribute: $0) }
    }
}

extension AnchorsYAxisAttribute: CaseIterable {
    public static var allCases: [AnchorsYAxisAttribute] {
        NSLayoutConstraint.Attribute.allCases.compactMap { AnchorsYAxisAttribute(attribute: $0) }
    }
}

extension AnchorsDimensionAttribute: CaseIterable {
    public static var allCases: [AnchorsDimensionAttribute] {
        NSLayoutConstraint.Attribute.allCases.compactMap { AnchorsDimensionAttribute(attribute: $0) }
    }
}
