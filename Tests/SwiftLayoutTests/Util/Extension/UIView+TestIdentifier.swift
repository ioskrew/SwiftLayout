//
//  UIView+TestIdentifier.swift
//  SwiftLayoutTests
//

import UIKit

extension UIView {
    func withIdentifier(_ id: String) -> Self {
        accessibilityIdentifier = id
        return self
    }
}

extension UILayoutGuide {
    func withIdentifier(_ id: String) -> Self {
        identifier = id
        return self
    }
}
