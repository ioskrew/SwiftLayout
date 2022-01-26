//
//  NSLayoutConstraint+Equator.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import Foundation
import UIKit

/// NSLayoutConstraint의 Equator는 attribute와 item간의 관계
/// 만 바라봅니다.
extension NSLayoutConstraint: NoHashableImpl {
    
    var equator: Equator<NSLayoutConstraint> {
        Equator(from: self)
    }
    
    func combineToHasher(_ hasher: inout Hasher) {
        hasher.combine(self.firstItem as? NSObject)
        hasher.combine(self.firstAttribute)
        hasher.combine(self.secondItem as? NSObject)
        hasher.combine(self.secondAttribute)
    }
    
}
