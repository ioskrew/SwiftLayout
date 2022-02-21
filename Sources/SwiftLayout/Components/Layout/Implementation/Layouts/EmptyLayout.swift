import Foundation
import UIKit

public struct EmptyLayout: Layout {
    public var debugDescription: String {
        "EmptyLayout"
    }
    
    public func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: (UIView?, UIView, String?, Bool) -> Void) {}
    public func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: (UIView?, UIView, [Constraint], ViewInformationSet) -> Void) {}
}
