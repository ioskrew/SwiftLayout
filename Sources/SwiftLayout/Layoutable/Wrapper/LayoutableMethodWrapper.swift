//
//  LayoutableMethodWrapper.swift
//  
//
//  Created by oozoofrog on 2022/03/13.
//

import Foundation

public final class LayoutableMethodWrapper<L: Layoutable> {
    private weak var layoutable: L?
    
    init(_ layoutable: L) {
        self.layoutable = layoutable
    }
    
    public func updateLayout() {
        guard let layoutable = layoutable else {
            return
        }
        layoutable.activation = Activator.update(layout: layoutable.layout,
                                                 fromActivation: layoutable.activation ?? Activation())
    }
}

extension Layoutable {
    public var sl: LayoutableMethodWrapper<Self> { .init(self) }
}
