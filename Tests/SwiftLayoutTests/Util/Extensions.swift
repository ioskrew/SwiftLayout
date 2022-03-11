import SwiftLayout
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
typealias UILabel = NSTextView
typealias UIImageView = NSImageView
typealias UIButton = NSButton
#endif

extension UIView {
    func findConstraints(items: (NSObject?, NSObject?), attributes: (NSLayoutConstraint.Attribute, NSLayoutConstraint.Attribute)? = nil, relation: NSLayoutConstraint.Relation = .equal, constant: CGFloat = .zero, multiplier: CGFloat = 1.0) -> [NSLayoutConstraint] {
        var constraints = self.constraints.filter { constraint in
            constraint.isFit(items: items, attributes: attributes, relation: relation, constant: constant, multiplier: multiplier)
        }
        for subview in subviews {
            constraints.append(contentsOf: subview.findConstraints(items: items, attributes: attributes, relation: relation, constant: constant, multiplier: multiplier))
        }
        return constraints
    }
}

extension NSLayoutConstraint {
    func isFit(items: (NSObject?, NSObject?), attributes: (NSLayoutConstraint.Attribute, NSLayoutConstraint.Attribute)? = nil, relation: NSLayoutConstraint.Relation = .equal, constant: CGFloat = .zero, multiplier: CGFloat = 1.0) -> Bool {
        let item = firstItem as? NSObject
        let toItem = secondItem as? NSObject
        return (item, toItem) == items
        && attributes.flatMap({ $0 == (firstAttribute, secondAttribute) }) ?? true
        && self.relation == relation && self.constant == constant && self.multiplier == multiplier
    }
}

extension String {
    var tabbed: String { replacingOccurrences(of: "    ", with: "\t") }
}

#if canImport(AppKit)
extension NSView {
    func systemLayoutSizeFitting(_ size: CGSize) -> CGSize {
        fittingSize
    }
    var backgroundColor: NSColor? {
        get { layer?.backgroundColor.flatMap(NSColor.init) }
        set { layer?.backgroundColor = newValue?.cgColor }
    }
}
extension NSTextView {
    var text: String? {
        get { string }
        set { string = newValue ?? "" }
    }
}
#endif
