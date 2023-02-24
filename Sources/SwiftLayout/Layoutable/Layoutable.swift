//
//  Layoutable.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

public protocol Layoutable: AnyObject, LayoutElement {
    associatedtype LayoutBody: Layout
    var activation: Activation? { get set }
    @LayoutBuilder var layout: LayoutBody { get }
}
