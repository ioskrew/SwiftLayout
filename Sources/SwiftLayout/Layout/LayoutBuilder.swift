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
    
    public static func buildOptional(_ component: Layoutable?) -> Layoutable {
        component ?? EmptyLayout()
    }
    
    public static func buildEither(first component: Layoutable) -> Layoutable {
        buildArray([component])
    }
    
    public static func buildArray(_ components: [Layoutable]) -> Layoutable {
        LayoutableComponents(components)
    }
    
    internal struct EmptyLayout: Layoutable {
        func moveToSuperlayoutable(_ layoutable: Layoutable) -> Layoutable {
            layoutable
        }
    }
    
}
