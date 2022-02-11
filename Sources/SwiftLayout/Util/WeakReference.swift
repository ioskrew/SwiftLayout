//
//  WeakReference.swift
//  
//
//  Created by oozoofrog on 2022/02/12.
//

import Foundation
import UIKit

final class WeakReference<O> where O: AnyObject {
    internal init(o: O? = nil) {
        self.o = o
    }
    
    weak var o: O?
}

extension WeakReference: Equatable where O: Equatable {
    static func == (lhs: WeakReference<O>, rhs: WeakReference<O>) -> Bool {
        lhs.o == rhs.o
    }
}

extension WeakReference: Hashable where O: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(o)
    }
}

extension WeakReference where O == NSLayoutConstraint {
    func hash(into hasher: inout Hasher) {
        hasher.combine(o?.firstItem as? NSObject)
        hasher.combine(o?.firstAttribute)
        hasher.combine(o?.secondItem as? NSObject)
        hasher.combine(o?.secondAttribute)
        hasher.combine(o?.relation)
        hasher.combine(o?.constant)
        hasher.combine(o?.multiplier)
        hasher.combine(o?.priority)
    }
}
