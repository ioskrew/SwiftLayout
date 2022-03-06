//
//  UIVIew+Layout.swift
//  
//
//  Created by aiden_h on 2022/02/21.
//

import UIKit

extension UIView {
    public func callAsFunction<L: Layout>(@LayoutBuilder _ build: () -> L) -> some Layout {
        ViewLayout(self, sublayout: build())
    }
    
    public func anchors(@AnchorsBuilder _ build: () -> Anchors) -> some Layout {
        AnchorsLayout(layout: ViewLayout(self, sublayout: EmptyLayout()), anchors: build())
    }
    
    public func sublayout<L: Layout>(@LayoutBuilder _ build: () -> L) -> some Layout {
        SublayoutLayout(ViewLayout(self, sublayout: EmptyLayout()), build())
    }
    
    @available(*, deprecated, message: "using sublayout instead of this")
    public func subviews<L: Layout>(@LayoutBuilder _ build: () -> L) -> some Layout {
        self.sublayout(build)
    }
}

public protocol _ViewConfig {}
extension UIView: _ViewConfig {}
extension _ViewConfig where Self: UIView {
    public func config(_ config: (Self) -> Void) -> Self {
        config(self)
        return self
    }
    
    public func identifying(_ accessibilityIdentifier: String) -> Self {
        self.accessibilityIdentifier = accessibilityIdentifier
        return self
    }
    
    @discardableResult
    public func updateIdentifiers(rootObject: AnyObject? = nil) -> Self {
        IdentifierUpdater.nameOnly.update(rootObject ?? self)
        return self
    }
}
