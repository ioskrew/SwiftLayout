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
    
    @available(*, deprecated, renamed: "self.sl.layout()", message: "updateLayout of Layoutable moved to sl wrapper type")
    func updateLayout()
}

public extension Layoutable {
    
    @available(*, deprecated, renamed: "self.sl.layout()", message: "updateLayout of Layoutable moved to sl wrapper type")
    func updateLayout() {
        self.activation = Activator.update(layout: layout, fromActivation: activation ?? Activation(), layoutIfNeededForcefully: false)
    }
    
    var sl: LayoutableMethodWrapper<Self> { .init(self) }
}
