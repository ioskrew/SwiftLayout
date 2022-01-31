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
    public static func buildBlock<Component>(_ component: Component) -> Component where Component: Layout {
        component
    }
    
    public static func buildArray(_ components: [Layout]) -> Layout {
        LayoutableComponents(components)
    }
    
    public static func buildOptional(_ component: Layout?) -> Layout {
        component ?? EmptyLayout()
    }
    
    public static func buildEither(first component: Layout) -> Layout {
        component
    }
    
    public static func buildEither(second component: Layout) -> Layout {
        component
    }
    
}
