//
//  UIVIew+Layout.swift
//  
//
//  Created by aiden_h on 2022/02/21.
//

import UIKit

extension UIView {
    
    ///
    /// Create a ``ViewLayout`` containing this view and the sublayouts.
    ///
    /// Sublayouts contained within the builder block are added to the view hierarchy through **addSubview(_:)** to the view.
    ///
    /// - Parameter build: A ``LayoutBuilder`` that  create sublayouts of this view.
    /// - Returns: An ``ViewLayout`` that wraps this view and contains sublayouts .
    ///
    public func callAsFunction<L: Layout>(@LayoutBuilder _ build: () -> L) -> some Layout {
        ViewLayout(self, sublayout: build())
    }
    
    ///
    /// Create an ``AnchorsLayout`` containing the  ``Anchors`` of this view.
    ///
    /// ``Anchors`` express **NSLayoutConstraint** and can be applied through this method.
    /// ```swift
    /// // The constraint of the view can be expressed as follows.
    ///
    /// subView.anchors {
    ///     Anchors(.top).equalTo(rootView, constant: 10)
    ///     Anchors(.centerX).equalTo(rootView)
    ///     Anchors(.width, .height).equalTo(rootView).setMultiplier(0.5)
    /// }
    ///
    /// // The following code performs the same role as the code above.
    ///
    /// NSLayoutConstraint.activate([
    ///     subView.topAnchor.constraint(equalTo: rootView.topAnchor, constant: 10),
    ///     subView.centerXAnchor.constraint(equalTo: rootView.centerXAnchor),
    ///     subView.widthAnchor.constraint(equalTo: rootView.widthAnchor, multiplier: 0.5),
    ///     subView.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.5)
    /// ])
    /// ```
    ///
    /// - Parameter build: A ``AnchorsBuilder`` that  create ``Anchors`` to be applied to this layout
    /// - Returns: An ``AnchorsLayout`` that wraps this view and contains the anchors .
    ///
    public func anchors(@AnchorsBuilder _ build: () -> Anchors) -> some Layout {
        AnchorsLayout(layout: ViewLayout(self, sublayout: EmptyLayout()), anchors: build())
    }
    
    ///
    /// Create a ``SublayoutLayout`` containing the sublayouts of this view.
    ///
    /// Sublayouts contained within the builder block are added to the view hierarchy through **addSubview(_:)** to the view.
    /// ```swift
    /// // The hierarchy of views can be expressed as follows,
    /// // and means that UILabel is a subview of UIView.
    ///
    /// UIView().sublayout {
    ///     UILabel()
    /// }
    /// ```
    ///
    /// - Parameter build: A ``LayoutBuilder`` that  create sublayouts of this view.
    /// - Returns: An ``SublayoutLayout`` that wraps this view and contains sublayouts .
    ///
    public func sublayout<L: Layout>(@LayoutBuilder _ build: () -> L) -> some Layout {
        SublayoutLayout(ViewLayout(self, sublayout: EmptyLayout()), build())
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
