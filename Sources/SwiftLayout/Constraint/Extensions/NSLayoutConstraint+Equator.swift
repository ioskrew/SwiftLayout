//
//  NSLayoutConstraint+Equator.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import Foundation
import UIKit

///
/// NSLayoutConstraint가 서로 같다고 판단할 수 있는 경우
///
/// - firstItem
/// - firstAttribute
/// - priority
/// - secondItem
/// - secondAttribute
///
extension NSLayoutConstraint: NoHashableImpl {
    
    var equator: Equator<NSLayoutConstraint> {
        Equator(self)
    }
    
    func isEqual(with object: NoHashableImpl) -> Bool {
        guard let constraint = object as? Self else { return false }
        if self.hashValue == constraint.hashValue {
            return true
        } else {
            return self.firstConstraintElement == constraint.firstConstraintElement
            && self.secondConstraintElement == constraint.secondConstraintElement
        }
    }
    
    func combineToHasher(_ hasher: inout Hasher) {
        hasher.combine(self.hashValue)
        hasher.combine(self.firstConstraintElement)
        hasher.combine(self.secondConstraintElement)
    }
    
}
