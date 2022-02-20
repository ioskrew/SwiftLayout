import Foundation
import UIKit

final class ViewRelation: Hashable {
    static func == (lhs: ViewRelation, rhs: ViewRelation) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    internal init(superview: UIView?, subview: UIView) {
        self.superview = superview
        self.subview = subview
    }
    
    weak var superview: UIView?
    var subview: UIView
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(superview)
        hasher.combine(subview)
    }
}
