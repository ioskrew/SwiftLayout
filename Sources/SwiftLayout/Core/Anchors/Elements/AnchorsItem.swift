//
//  AnchorsItem.swift
//  
//
//  Created by aiden_h on 2022/03/30.
//

import SwiftLayoutPlatform

public protocol AnchorsItemable {}
extension SLView: AnchorsItemable {}
extension SLLayoutGuide: AnchorsItemable {}
extension String: AnchorsItemable {}

public enum AnchorsItem: Hashable {
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
}
