//
//  Attribute+CaseIterable.swift
//

import SwiftLayout
import Testing
import SwiftLayoutPlatform

extension NSLayoutConstraint.Attribute: @retroactive CaseIterable {
    public static var allCases: [NSLayoutConstraint.Attribute] {
        #if canImport(UIKit)
        (0...20).compactMap {
            NSLayoutConstraint.Attribute(rawValue: $0)
        }
        #else
        // AppKit doesn't have margin attributes (rawValues 13-20)
        (0...12).compactMap {
            NSLayoutConstraint.Attribute(rawValue: $0)
        }
        #endif
    }

    static var allCasesForXAis: [NSLayoutConstraint.Attribute] {
        return allCases.filter { $0.axisType == .xAxis }
    }

    static var allCasesForYAis: [NSLayoutConstraint.Attribute] {
        return allCases.filter { $0.axisType == .yAxis }
    }

    static var allCasesForDimension: [NSLayoutConstraint.Attribute] {
        return allCases.filter { $0.axisType == .dimension }
    }

    private var axisType: AxisType {
        switch self {
        case .left: return .xAxis
        case .right: return .xAxis
        case .top: return .yAxis
        case .bottom: return .yAxis
        case .leading: return .xAxis
        case .trailing: return .xAxis
        case .width: return .dimension
        case .height: return .dimension
        case .centerX: return .xAxis
        case .centerY: return .yAxis
        case .lastBaseline: return .yAxis
        case .firstBaseline: return .yAxis
        #if canImport(UIKit)
        case .leftMargin: return .xAxis
        case .rightMargin: return .xAxis
        case .topMargin: return .yAxis
        case .bottomMargin: return .yAxis
        case .leadingMargin: return .xAxis
        case .trailingMargin: return .xAxis
        case .centerXWithinMargins: return .xAxis
        case .centerYWithinMargins: return .yAxis
        #endif
        case .notAnAttribute: return .unknown
        @unknown default: return .unknown
        }
    }

    private enum AxisType {
        case xAxis
        case yAxis
        case dimension
        case unknown
    }
}

extension NSLayoutConstraint.Attribute: @retroactive CustomTestStringConvertible {
    public var testDescription: String {
        switch self {
        case .left: return "left"
        case .right: return "right"
        case .top: return "top"
        case .bottom: return "bottom"
        case .leading: return "leading"
        case .trailing: return "trailing"
        case .width: return "width"
        case .height: return "height"
        case .centerX: return "centerX"
        case .centerY: return "centerY"
        case .lastBaseline: return "lastBaseline"
        case .firstBaseline: return "firstBaseline"
        #if canImport(UIKit)
        case .leftMargin: return "leftMargin"
        case .rightMargin: return "rightMargin"
        case .topMargin: return "topMargin"
        case .bottomMargin: return "bottomMargin"
        case .leadingMargin: return "leadingMargin"
        case .trailingMargin: return "trailingMargin"
        case .centerXWithinMargins: return "centerXWithinMargins"
        case .centerYWithinMargins: return "centerYWithinMargins"
        #endif
        case .notAnAttribute: return "notAnAttribute"
        @unknown default: return "unknown"
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
