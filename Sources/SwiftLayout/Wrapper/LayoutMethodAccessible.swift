import Foundation
import UIKit

public protocol LayoutMethodAccessible {}
public extension LayoutMethodAccessible {
    var sl: LayoutMethodWrapper<Self> { .init(base: self) }
}

extension UIView: LayoutMethodAccessible {}
