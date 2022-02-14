//
//  ConstraintItem.swift
//  
//
//  Created by oozoofrog on 2022/02/14.
//

import Foundation
import UIKit

public protocol ConstraintItem {
    
    var item: Anchors.Item { get }
    
}

extension UIView: ConstraintItem {
    public var item: Anchors.Item {
        .init(self)
    }
}

extension UILayoutGuide: ConstraintItem {
    public var item: Anchors.Item {
        .init(self)
    }
}

extension String: ConstraintItem {
    public var item: Anchors.Item {
        .init(self)
    }
}

extension Optional: ConstraintItem where Wrapped: ConstraintItem {
    public var item: Anchors.Item {
        switch self {
        case let .some(item):
            return .init(item)
        case .none:
            return .none
        }
    }
}
