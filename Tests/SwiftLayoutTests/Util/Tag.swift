//
//  File.swift
//  
//
//  Created by aiden_h on 2022/02/18.
//

import SwiftLayout
import UIKit

protocol UIViewTaggable: AnyObject {
    var accessibilityIdentifier: String? { get set }
}

@dynamicMemberLookup
struct Tag<Taggable: UIViewTaggable> {
    let taggable: Taggable
    
    subscript(dynamicMember tag: String) -> Taggable {
        taggable.accessibilityIdentifier = tag
        return taggable
    }
}

extension UIView: UIViewTaggable {}

extension UIViewTaggable {
    var viewTag: Tag<Self> {
        Tag(taggable: self)
    }
}
