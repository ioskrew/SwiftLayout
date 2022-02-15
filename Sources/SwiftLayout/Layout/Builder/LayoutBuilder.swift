//
//  LayoutBuilder.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation

@resultBuilder
public struct LayoutBuilder {
    public static func buildBlock(_ components: Layout...) -> [Layout] {
        var layouts: [Layout] = []
        for layout in components {
            if let layoutArray = layout as? [Layout] {
                layouts.append(contentsOf: layoutArray)
            } else {
                layouts.append(layout)
            }
        }
        return layouts
    }
    public static func buildArray(_ components: [[Layout]]) -> [Layout] {
        components.flatMap({ $0 })
    }
    public static func buildEither(first component: [Layout]) -> [Layout] {
        component
    }
    public static func buildEither(second component: [Layout]) -> [Layout] {
        component
    }
    public static func buildOptional(_ component: [Layout]?) -> [Layout] {
        component ?? []
    }
}
