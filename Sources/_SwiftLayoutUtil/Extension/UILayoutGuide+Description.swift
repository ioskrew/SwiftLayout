//
//  UILayoutGuide+Description.swift
//  
//
//  Created by oozoofrog on 2022/03/14.
//

import UIKit

extension UILayoutGuide {
    public var propertyDescription: String {
        guard let description = owningView?.tagDescription else { return "unknown" }
        switch identifier {
        case "UIViewLayoutMarginsGuide":
            return description.appending(".layoutMarginsGuide")
        case "UIViewSafeAreaLayoutGuide":
            return description.appending(".safeAreaLayoutGuide")
        case "UIViewKeyboardLayoutGuide":
            return description.appending(".keyboardLayoutGuide")
        case "UIViewReadableContentGuide":
            return description.appending(".readableContentGuide")
        default:
            return description.appending(":").appending(identifier)
        }
    }
}
