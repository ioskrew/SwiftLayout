//
//  UILayoutGuide+Description.swift
//  
//
//  Created by oozoofrog on 2022/03/14.
//

import Foundation

extension SLLayoutGuide {
    var propertyDescription: String? {
        #if canImport(UIKit)
        switch identifier {
        case "UIViewLayoutMarginsGuide":
            return "layoutMarginsGuide"
        case "UIViewSafeAreaLayoutGuide":
            return "safeAreaLayoutGuide"
        case "UIViewKeyboardLayoutGuide":
            return "keyboardLayoutGuide"
        case "UIViewReadableContentGuide":
            return "readableContentGuide"
        default:
            return nil
        }
        #elseif canImport(AppKit)
        switch identifier.rawValue {
        case "NSViewSafeAreaLayoutGuide":
            return "safeAreaLayoutGuide"
        case "NSViewLayoutMarginsGuide":
            return "layoutMarginsGuide"
        default:
            return nil
        }
        #endif
    }
    var detailDescription: String? {
        guard let view = owningView else { return nil }
        let description = view.tagDescription
        if let propertyDescription = propertyDescription {
            return description + ".\(propertyDescription)"
        } else {
            return description + ":\(identifier)"
        }
    }
}
