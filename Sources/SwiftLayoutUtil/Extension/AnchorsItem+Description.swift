//
//  AnchorsItem+Description.swift
//  
//
//  Created by aiden_h on 2022/03/30.
//

import UIKit
import SwiftLayout

extension AnchorsItem {
    var description: String? {
        switch self {
        case .object(let object):
            if let view = object as? UIView {
                return view.tagDescription
            } else if let guide = object as? UILayoutGuide {
                return guide.propertyDescription
            } else {
                return "unknown"
            }
        case .identifier(let string):
            return string
        case .transparent:
            return "superview"
        case .deny:
            return nil
        }
    }
}
