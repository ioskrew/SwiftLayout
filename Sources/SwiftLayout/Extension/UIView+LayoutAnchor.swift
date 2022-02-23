//
//  UIView+LayoutAnchor.swift
//  
//
//  Created by oozoofrog on 2022/02/22.
//

import Foundation
import UIKit

extension LayoutAnchor where Self: NSObject {
    private func targetFromConstraint(_ constraint: NSLayoutConstraint, constant: CGFloat) -> Anchors.ConstraintTarget? {
        if let object = constraint.secondItem as? NSObject {
            return .init(item: .object(object), attribute: constraint.secondAttribute, constant: constant)
        } else {
            return .init(item: .transparent, attribute: constraint.secondAttribute, constant: constant)
        }
    }
    func constraintTargetWithConstant(_ constant: CGFloat) -> Anchors.ConstraintTarget? {
        let dummy = UIView()
        if let x = self as? NSLayoutXAxisAnchor {
            return targetFromConstraint(dummy.leadingAnchor.constraint(equalTo: x, constant: constant), constant: constant)
        } else if let y = self as? NSLayoutYAxisAnchor {
            return targetFromConstraint(dummy.topAnchor.constraint(equalTo: y, constant: constant), constant: constant)
        } else if let size = self as? NSLayoutDimension {
            return targetFromConstraint(dummy.widthAnchor.constraint(equalTo: size, constant: constant), constant: constant)
        } else {
            return nil
        }
    }
}
