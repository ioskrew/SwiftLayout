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
    
    enum Parser {
        static func from(_ view: UIView, viewTags tags: ViewTags, options: ViewPrinter.PrintOptions) -> ViewToken? {
            let superviewTag = tags.tag(object: view.superview, options: options)
            if let viewTag = tags.tag(object: view, options: options) {
                return ViewToken(superviewTag: superviewTag,
                                 viewTag: viewTag,
                                 subviews: view.subviews.compactMap({ Parser.from($0, viewTags: tags, options: options) }))
            } else {
                return nil
            }
        }
    }
}
