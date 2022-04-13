//
//  Layoutable.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

public protocol Layoutable: AnyObject {
    associatedtype LayoutBody: Layout
    var activation: Activation? { get set }
    @LayoutBuilder var layout: LayoutBody { get }
}

public extension Layoutable {
    
    var sl: LayoutableMethodWrapper<Self> { .init(self) }
}
