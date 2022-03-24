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
    
    @available(*, deprecated, renamed: "self.sl.layout()", message: "updateLayout of Layoutable moved to sl wrapper type")
    func updateLayout() {
        self.activation = Activator.update(layout: layout, fromActivation: activation ?? Activation(), forceLayout: false)
    }
}
