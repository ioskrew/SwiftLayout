//
//  Layout+Description.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation

extension CustomDebugStringConvertible where Self: Layout {
    public var debugDescription: String {
        "Layout: [\(sublayouts.map(\.debugDescription).joined(separator: ", "))]"
    }
}

extension CustomDebugStringConvertible where Self: ViewContainable, Self: Layout {
    public var debugDescription: String {
        if sublayouts.isEmpty {
            return view.tagDescription
        } else {
            return view.tagDescription + ": [\(sublayouts.map(\.debugDescription).joined(separator: ", "))]"
        }
    }
}

