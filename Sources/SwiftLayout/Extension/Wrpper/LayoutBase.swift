import Foundation
import UIKit

public protocol LayoutBase {}
public extension LayoutBase {
    var sl: LayoutMethodWrapper<Self> { .init(base: self) }
}

extension UIView: LayoutBase {}
