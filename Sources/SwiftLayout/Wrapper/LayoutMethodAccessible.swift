import Foundation
import UIKit

/// A protocol that provides access to SwiftLayout methods through the `.sl` namespace.
///
/// Types conforming to this protocol gain access to layout-related methods via the `sl` property.
/// UIView and UILayoutGuide conform to this protocol by default.
@MainActor
public protocol LayoutMethodAccessible {}

public extension LayoutMethodAccessible {
    /// Provides access to SwiftLayout methods.
    var sl: LayoutMethodWrapper<Self> { .init(base: self) }
}

extension UIView: LayoutMethodAccessible {}
extension UILayoutGuide: LayoutMethodAccessible {}
