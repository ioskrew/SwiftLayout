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
    
    public static func buildEither(first component: Layoutable) -> Layoutable {
        buildArray([component])
    }
    
    public static func buildArray(_ components: [Layoutable]) -> Layoutable {
        LayoutComponents(layoutables: components)
    }
    
    internal struct LayoutComponents: Layoutable {
        let layoutables: [Layoutable]
        
        var view: [UIView] {
            layoutables.compactMap(cast(UIView.self))
        }
    }
}
