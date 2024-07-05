//
//  Layoutable.swift
//
//
//  Created by oozoofrog on 2022/02/06.
//

public protocol Layoutable: AnyObject, LayoutMethodAccessible {
    associatedtype LayoutBody: Layout

    var activation: Activation? { get set }

    @LayoutBuilder var layout: LayoutBody { get }
}

public extension LayoutMethodWrapper where Base: Layoutable {
    func updateLayout(forceLayout: Bool = false) {
        base.activation = Activator.update(
            layout: base.layout,
            fromActivation: base.activation ?? Activation(),
            forceLayout: forceLayout
        )
    }
}
