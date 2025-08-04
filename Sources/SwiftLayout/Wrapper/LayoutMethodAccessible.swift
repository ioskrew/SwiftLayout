import Foundation
import UIKit

@MainActor
public protocol LayoutMethodAccessible {}
public extension LayoutMethodAccessible {
    var sl: LayoutMethodWrapper<Self> { .init(base: self) }
}

extension UIView: LayoutMethodAccessible {}
extension UILayoutGuide: LayoutMethodAccessible {}
