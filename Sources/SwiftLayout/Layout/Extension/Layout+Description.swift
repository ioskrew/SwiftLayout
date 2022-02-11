//
//  Layout+Description.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation

extension CustomDebugStringConvertible where Self: Layout {
    public var debugDescription: String {
        "Layout"
    }
}

extension CustomDebugStringConvertible where Self: ContainableLayout {
    public var debugDescription: String {
        "LayoutContains: [\(layouts.map(\.debugDescription).joined(separator: ", "))]"
    }
}

extension CustomDebugStringConvertible where Self: ViewContainableLayout {
    public var debugDescription: String {
        guard let view = view else { return "" }
        if layouts.isEmpty {
            return view.tagDescription
        } else {
            return view.tagDescription + ": [\(layouts.map(\.debugDescription).joined(separator: ", "))]"
        }
    }
}

