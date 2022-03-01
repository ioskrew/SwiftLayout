import Foundation
import UIKit

public struct EmptyLayout: Layout {
    public var debugDescription: String {
        "EmptyLayout"
    }
    
    public func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler) {}
    public func traverse(_ superview: UIView?, constraintHndler handler: ConstraintHandler) {}
}
