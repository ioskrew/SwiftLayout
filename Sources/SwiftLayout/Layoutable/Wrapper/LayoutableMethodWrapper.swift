//
//  LayoutableMethodWrapper.swift
//  
//
//  Created by oozoofrog on 2022/03/13.
//

public final class LayoutableMethodWrapper<L: Layoutable> {
    let layoutable: L
    
    init(_ layoutable: L) {
        self.layoutable = layoutable
    }
    
    public func updateLayout(forceLayout: Bool = false) {
        layoutable.activation = Activator.update(layout: layoutable.layout,
                                                 fromActivation: layoutable.activation ?? Activation(),
                                                 forceLayout: forceLayout)
    }
}
