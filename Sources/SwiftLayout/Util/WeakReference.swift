//
//  WeakReference.swift
//  
//
//  Created by oozoofrog on 2022/02/12.
//

import Foundation
import UIKit

protocol CustomHashable: AnyObject {
    func customHash(_ hasher: inout Hasher)
}

final class WeakReference<O>: Hashable where O: CustomHashable {
    static func == (lhs: WeakReference<O>, rhs: WeakReference<O>) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    internal init(o: O? = nil) {
        self.o = o
    }
    
    weak var o: O?
    
    func hash(into hasher: inout Hasher) {
        o?.customHash(&hasher)
    }
}

extension NSLayoutConstraint: CustomHashable {
    func customHash(_ hasher: inout Hasher) {
        hasher.combine(firstItem as? NSObject)
        hasher.combine(firstAttribute)
        hasher.combine(secondItem as? NSObject)
        hasher.combine(secondAttribute)
        hasher.combine(relation)
        hasher.combine(constant)
        hasher.combine(multiplier)
        hasher.combine(priority)
    }
}
