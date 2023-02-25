//
//  LayoutMethodWrapper.swift
//  
//
//  Created by aiden_h on 2023/02/25.
//

import Foundation

public extension LayoutMethodWrapper where Base: Layoutable {
    @inline(__always)
    internal var layoutable: Base {
        return base
    }

    func updateLayout(forceLayout: Bool = false) {
        layoutable.activation = Activator.update(layout: layoutable.layout,
                                                 fromActivation: layoutable.activation ?? Activation(),
                                                 forceLayout: forceLayout)
    }
}
