//
//  Layout.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import UIKit

public protocol Layout: CustomDebugStringConvertible {}

extension Layout {
    public func active(_ options: LayoutOptions = []) -> Deactivable {
        Activator.active(layout: self, options: options)
    }
    
    public var anyLayout: AnyLayout {
        AnyLayout(self)
    }
    public func anchors(@AnchorsBuilder _ build: () -> [Constraint]) -> AnchorsLayout<Self> {
        AnchorsLayout(layout: self, anchors: build())
    }
    
    public func sublayout<L: Layout>(@LayoutBuilder _ build: () -> L) -> SublayoutLayout<Self, L> {
        SublayoutLayout(self, build())
    }
    
    public func subviews<L: Layout>(@LayoutBuilder _ build: () -> L) -> some Layout {
        sublayout(build)
    }
}

public extension Layout where Self: UIView {
    func callAsFunction<L: Layout>(@LayoutBuilder _ build: () -> L) -> some Layout {
        ViewLayout(self, sublayout: build())
    }
    
    func identifying(_ identifier: String) -> some Layout {
        let layout = ViewLayout(self, sublayout: EmptyLayout())
        layout.identifier = identifier
        return layout
    }
}

extension UIView: Layout {}
extension Optional: Layout where Wrapped: Layout {}
