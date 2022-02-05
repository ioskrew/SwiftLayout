//
//  LayoutBuilder.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation

@resultBuilder
struct LayoutBuilder {
    static func buildBlock(_ components: Layout...) -> [Layout] {
        components
    }
    static func buildEither(first component: [Layout]) -> [Layout] {
        component
    }
    static func buildEither(second component: [Layout]) -> [Layout] {
        component
    }
    static func buildOptional(_ component: [Layout]?) -> [Layout] {
        component ?? []
    }
}
