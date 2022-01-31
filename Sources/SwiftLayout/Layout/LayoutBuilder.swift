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
    
    public static func buildBlock<Left, Right>(_ left: Left, _ right: Right) -> PairLayout<Left, Right> where Left: Layout, Right: Layout {
        PairLayout(left: left, right: right)
    }
    
    public static func buildBlock<A, B, C>(_ a: A, _ b: B, _ c: C) -> TupleLayout<(A, B, C)> where A: Layout, B: Layout, C: Layout {
        TupleLayout(tuple: (a, b, c))
    }
}
