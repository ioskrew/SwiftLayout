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
    public func anchors(@AnchorsBuilder _ build: () -> [Constraint]) -> AnchorsLayout<Self> {
        AnchorsLayout(layout: self, anchors: build())
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
    
    func sublayout<L: Layout>(@LayoutBuilder _ build: () -> L) -> some Layout {
        ViewLayout(self, sublayout: build())
    }
    
    func subviews<L: Layout>(@LayoutBuilder _ build: () -> L) -> some Layout {
        sublayout(build)
    }
}

public extension Layout {
    
    func sublayout<L: Layout>(@LayoutBuilder _ build: () -> L) -> some Layout {
        EmptyLayout()
    }
    
    func subviews<L: Layout>(@LayoutBuilder _ build: () -> L) -> some Layout {
        EmptyLayout()
    }
    
    func active(_ options: LayoutOptions = []) -> Deactivable {
        Activator.active(layout: self, options: options)
    }
}

extension UIView: Layout {}
extension Optional: Layout where Wrapped: Layout {}
