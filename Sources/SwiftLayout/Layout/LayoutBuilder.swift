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
    public static func buildBlock<Layoutable>(_ layoutable: Layoutable) -> Layoutable where Layoutable: Layout {
        layoutable
    }
    
    public static func buildOptional<Layoutable>(_ component: Layoutable?) -> Layoutable? where Layoutable: LayoutAttachable {
        component
    }
    
    public static func buildEither<First, Second>(first component: First) -> EitherFirstLayout<First, Second> where First: LayoutAttachable, Second: LayoutAttachable {
        EitherFirstLayout<First, Second>(layout: component)
    }
    
    public static func buildEither<First, Second>(second component: Second) -> EitherSecondLayout<First, Second> where First: LayoutAttachable, Second: LayoutAttachable {
        EitherSecondLayout<First, Second>(layout: component)
    }
    
    public static func buildBlock<Left, Right>(_ left: Left, _ right: Right) -> PairLayout<Left, Right> where Left: Layout, Right: Layout {
        PairLayout(left: left, right: right)
    }
    
    public static func buildBlock<A, B, C>(_ a: A, _ b: B, _ c: C) -> TupleLayout<(A, B, C)> where A: Layout, B: Layout, C: Layout {
        TupleLayout(tuple: (a, b, c))
    }
    
    public static func buildBlock<A, B, C, D>(_ a: A, _ b: B, _ c: C, _ d: D) -> TupleLayout<(A, B, C, D)> where A: Layout, B: Layout, C: Layout, D: Layout {
        TupleLayout(tuple: (a, b, c, d))
    }
    
    public static func buildBlock<A, B, C, D, E>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E) -> TupleLayout<(A, B, C, D, E)> where A: Layout, B: Layout, C: Layout, D: Layout, E: Layout {
        TupleLayout(tuple: (a, b, c, d, e))
    }
}
