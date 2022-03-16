//
//  UILayoutGuide+Description.swift
//  
//
//  Created by oozoofrog on 2022/03/14.
//

import Foundation

extension SLLayoutGuide {
    var detailDescription: String? {
        guard let view = owningView else { return nil }
        let description = view.tagDescription
        #if canImport(UIKit)
        switch identifier {
        case "UIViewLayoutMarginsGuide":
            return description + ".layoutMarginsGuide"
        case "UIViewLayoutSafeAreaGuide":
            return description + ".safeAreaLayoutGuide"
        case "UIViewKeyboardLayoutGuide":
            return description + ".keyboardLayoutGuide"
        case "UIViewReadableContentGuide":
            return description + ".readableContentGuide"
        default:
            return description + ":\(identifier)"
        }
        #elseif canImport(AppKit)
        switch identifier.rawValue {
        case "NSViewSafeAreaLayoutGuide":
            return description + ".safeAreaLayoutGuide"
        case "NSViewLayoutMarginsGuide":
            return description + ".layoutMarginsGuide"
        default:
            return description + ":\(identifier.rawValue)"
        }
        #endif
    }
}
