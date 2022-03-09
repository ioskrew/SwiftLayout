//
//  UIVIew+Layout.swift
//  
//
//  Created by aiden_h on 2022/02/21.
//

import UIKit

public protocol _UIViewExtension {}
extension UIView: _UIViewExtension {}
extension _UIViewExtension where Self: UIView {
    public func callAsFunction<L: Layout>(@LayoutBuilder _ build: () -> L) -> ViewLayout<Self, L> {
        ViewLayout(self, sublayout: build())
    }
    
    public func anchors(@AnchorsBuilder _ build: () -> Anchors) -> ViewLayout<Self, EmptyLayout> {
        ViewLayout(self, sublayout: EmptyLayout()).anchors(build)
    }
    
    public func sublayout<L: Layout>(@LayoutBuilder _ build: () -> L) -> ViewLayout<Self, EmptyLayout> {
        ViewLayout(self, sublayout: EmptyLayout()).sublayout(build)
    }
    
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
