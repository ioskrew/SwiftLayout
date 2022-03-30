//
//  AnchorsItem.swift
//  
//
//  Created by aiden_h on 2022/03/30.
//

import UIKit
import _SwiftLayoutUtil

public protocol AnchorsItemable {}
extension UIView: AnchorsItemable {}
extension UILayoutGuide: AnchorsItemable {}
extension String: AnchorsItemable {}

enum AnchorsItem: Hashable {
    case object(NSObject)
    case identifier(String)
    case transparent
    case deny
    
    init(_ item: AnchorsItemable?) {
        if let string = item as? String {
            self = .identifier(string)
        } else if let object = item as? NSObject {
            self = .object(object)
        } else {
            self = .transparent
        }
    }
    
    var shortDescription: String? {
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
