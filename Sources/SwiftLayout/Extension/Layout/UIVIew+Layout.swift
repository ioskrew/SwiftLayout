//
//  UIVIew+Layout.swift
//  
//
//  Created by aiden_h on 2022/02/21.
//

public protocol _SLViewExtension {}
extension SLView: _SLViewExtension {}
extension _SLViewExtension where Self: SLView {

    ///
    /// Create a ``ViewLayout`` containing this view and the sublayouts.
    ///
    /// Sublayouts contained within the builder block are added to the view hierarchy through **addSubview(_:)** to the view.
    ///
    /// - Parameter build: A ``LayoutBuilder`` that  create sublayouts of this view.
    /// - Returns: An ``ViewLayout`` that wraps this view and contains sublayouts .
    ///
    public func callAsFunction<L: Layout>(@LayoutBuilder _ build: () -> L) -> ViewLayout<Self, L> {
        ViewLayout(self, sublayout: build())
    }
    
    ///
    /// Create a ``ViewLayout`` containing this view and the sublayouts and add anchors coordinator to this layout
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
    /// - Returns: An ``ViewLayout`` that wraps this view and contains the anchors  coordinator.
    ///
    public func anchors(@AnchorsBuilder _ build: () -> Anchors) -> ViewLayout<Self, EmptyLayout> {
        ViewLayout(self, sublayout: EmptyLayout()).anchors(build)
    }
    
    ///
    /// Create a ``ViewLayout`` containing the sublayouts of this view.
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
    /// - Returns: An ``ViewLayout`` that wraps this view and contains sublayouts .
    ///
    public func sublayout<L: Layout>(@LayoutBuilder _ build: () -> L) -> ViewLayout<Self, EmptyLayout> {
        ViewLayout(self, sublayout: EmptyLayout()).sublayout(build)
    }
    
    ///
    /// Provides a block that can change the properties of the view within the layout block.
    ///
    /// ```swift
    /// // Create an instant view within the layout block
    /// // and modify the properties of the view as follows
    ///
    /// var layout: some Layout {
    ///     UILabel().config { view in
    ///         view.backgroundColor = .blue
    ///         view.text = "hello"
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter config: A configuration block for this view.
    /// - Returns: The view itself with the configuration applied
    ///
    public func config(_ config: (Self) -> Void) -> Self {
        config(self)
        return self
    }
    
    ///
    /// Set its **accessibilityIdentifier**.
    ///
    /// - Parameter accessibilityIdentifier: A string containing the identifier of the element.
    /// - Returns: The view itself with the accessibilityIdentifier applied
    ///
    public func identifying(_ accessibilityIdentifier: String) -> Self {
        self.slIdentifier = accessibilityIdentifier
        return self
    }
    
    ///
    /// Set the **accessibilityIdentifier** of all view objects included in the layout hierarchy to the property name of the object that has each views.
    ///
    /// - Parameter rootObject: root object for referencing property names
    /// - Returns: The view itself with the **accessibilityIdentifier** applied
    ///
    @discardableResult
    public func updateIdentifiers(rootObject: AnyObject? = nil) -> Self {
        IdentifierUpdater.nameOnly.update(rootObject ?? self)
        return self
    }
}
