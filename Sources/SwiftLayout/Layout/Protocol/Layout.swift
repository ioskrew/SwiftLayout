//
//  Layout.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import UIKit

public protocol Layout: CustomDebugStringConvertible {}

extension Layout {
    public var anyLayout: AnyLayout {
        AnyLayout(self)
    }
}

public extension Layout where Self: UIView {
    func callAsFunction<L: Layout>(@LayoutBuilder _ build: () -> L) -> ViewLayout<Self, L> {
        ViewLayout(self, sublayout: build())
    }
    
    func identifying(_ identifier: String) -> some Layout {
        let layout = ViewLayout(self, sublayout: EmptyLayout())
        layout.identifier = identifier
        return layout
    }
}

public extension Layout {
    
    func sublayout<L: Layout>(@LayoutBuilder _ build: () -> L) -> some Layout {
        SublayoutLayout(self, build())
    }
    
    func subviews<L: Layout>(@LayoutBuilder _ build: () -> L) -> some Layout {
        SublayoutLayout(self, build())
    }
    
    func active(_ options: LayoutOptions = []) -> Deactivable {
        Activator.active(layout: self, options: options)
    }
    
    func anchors(@AnchorsBuilder _ build: () -> [Constraint]) -> some Layout {
        AnchorsLayout(layout: self, anchors: build())
    }
}

extension UIView: Layout {}
