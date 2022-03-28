//
//  ViewToken.swift
//  
//
//  Created by oozoofrog on 2022/03/28.
//

import UIKit

struct ViewToken {
    private init(superviewTag: String?, viewTag: String, subviews: [ViewToken]) {
        self.superviewTag = superviewTag
        self.viewTag = viewTag
        self.subviews = subviews
    }
    
    let superviewTag: String?
    let viewTag: String
    let subviews: [ViewToken]
    
    struct Parser {
        static func from(_ view: UIView, viewTags tags: ViewTags, options: SwiftLayoutPrinter.PrintOptions) -> ViewToken? {
            if let superviewTag = tags[view.superview] {
                if let viewTag = tags[view] {
                    return ViewToken(superviewTag: superviewTag,
                                     viewTag: viewTag,
                                     subviews: view.subviews.compactMap({ Parser.from($0, viewTags: tags, options: options) }))
                } else {
                    return nil
                }
            } else if let viewTag = tags[view] {
                return ViewToken(superviewTag: nil,
                                 viewTag: viewTag,
                                 subviews: view.subviews.compactMap({ Parser.from($0, viewTags: tags, options: options) }))
            } else {
                return nil
            }
        }
    }
}
