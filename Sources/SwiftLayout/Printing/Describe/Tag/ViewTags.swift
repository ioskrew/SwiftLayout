//
//  ViewTags.swift
//  
//
//  Created by oozoofrog on 2022/03/28.
//

import Foundation
import UIKit

struct ViewTags {
    
    static func viewTagsFromView(_ view: UIView, customTags: [AddressDescriptor: String]) -> ViewTags {
        let views = viewsFromView(view)
        let viewTags = [AddressDescriptor: String](uniqueKeysWithValues: views.map({ (AddressDescriptor($0), $0.tagDescription) }))
        return ViewTags(customTags: customTags, viewTags: viewTags)
    }
    
    private static func viewsFromView(_ view: UIView) -> [UIView] {
        var views: [UIView] = [view]
        views.append(contentsOf: view.subviews.flatMap(viewsFromView))
        return views
    }
    
    let customTags: [AddressDescriptor: String]
    let viewTags: [AddressDescriptor: String]
    
    subscript(address: AddressDescriptor) -> String? {
        if let tag = customTags[address] {
            return tag
        } else if let tag = viewTags[address] {
            return tag
        } else {
            return nil
        }
    }
    
    subscript(object: AnyObject?) -> String? {
        guard let object = object else {
            return nil
        }
        return self[AddressDescriptor(object)]
    }
}
