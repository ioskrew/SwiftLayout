//
//  File.swift
//  
//
//  Created by aiden_h on 2022/02/18.
//

import SwiftLayout

protocol SLViewTaggable: AnyObject {
    var slIdentifier: String? { get set }
}

@dynamicMemberLookup
struct Tag<Taggable: SLViewTaggable> {
    let taggable: Taggable
    
    subscript(dynamicMember tag: String) -> Taggable {
        taggable.slIdentifier = tag
        return taggable
    }
}

extension SLView: SLViewTaggable {}

extension SLViewTaggable {
    var viewTag: Tag<Self> {
        Tag(taggable: self)
    }
}
