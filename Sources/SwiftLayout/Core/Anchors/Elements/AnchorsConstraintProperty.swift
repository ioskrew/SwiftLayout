//
//  AnchorsConstraintProperty.swift
//  
//
//  Created by aiden_h on 2022/03/31.
//

import UIKit

@MainActor
public struct AnchorsConstraintProperty {
    public let attribute: NSLayoutConstraint.Attribute
    public let relation: NSLayoutConstraint.Relation
    public let toItem: AnchorsItem
    public let toAttribute: NSLayoutConstraint.Attribute?
    public let constant: CGFloat
    public internal(set) var multiplier: CGFloat = 1.0
    public internal(set) var priority: UILayoutPriority = .required
    
    public var isDimension: Bool {
        attribute == .height || attribute == .width
    }
    
    func nsLayoutConstraint(item fromItem: NSObject, toItem: NSObject?, viewDic: [String: UIView]) -> NSLayoutConstraint {
        let to = self.toItem(toItem, viewDic: viewDic)
        assert(to is UIView || to is UILayoutGuide || to == nil, "to: \(to.debugDescription) is not item")
        
        let constrint = NSLayoutConstraint(
            item: fromItem,
            attribute: attribute,
            relatedBy: relation,
            toItem: to,
            attribute: toAttribute ?? attribute,
            multiplier: multiplier,
            constant: constant
        )
        constrint.priority = priority

        return constrint
    }
    
    private func toItem(_ toItem: NSObject?, viewDic: [String: UIView]) -> NSObject? {
        switch self.toItem {
        case let .object(object):
            return object
        case let .identifier(identifier):
            return viewDic[identifier] ?? toItem
        case .transparent:
            return toItem
        case .deny:
            if isDimension {
                return nil
            } else {
                return toItem
            }
        }
    }
}
