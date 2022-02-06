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
        components
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
