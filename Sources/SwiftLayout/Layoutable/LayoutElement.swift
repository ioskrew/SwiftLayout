import Foundation
import UIKit

public protocol LayoutElement {}

public extension LayoutElement {
    var sl: LayoutableMethodWrapper<Self> { .init(self) }
}

extension UIView: LayoutElement {}
