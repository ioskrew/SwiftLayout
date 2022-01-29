//
//  File.swift
//  
//
//  Created by maylee on 2022/01/29.
//

import Foundation
import UIKit

@resultBuilder
public struct LayoutBuilder {
    public static func buildBlock(_ components: Layoutable...) -> Layoutable {
        buildArray(components)
    }
    
    public static func buildArray(_ components: [Layoutable]) -> Layoutable {
        if components.count == 1 {
            return components[0]
        } else {
            return LayoutableComponents(components)
        }
    }
    
    public static func buildOptional(_ component: Layoutable?) -> Layoutable {
        component ?? EmptyLayout()
    }
    
    public static func buildEither(first component: Layoutable) -> Layoutable {
        component
    }
    
    public static func buildEither(second component: Layoutable) -> Layoutable {
        component
    }
    
    internal struct EmptyLayout: Layoutable {
        func moveToSuperlayoutable(_ layoutable: Layoutable) -> Layoutable {
            layoutable
        }
    }
    
}
