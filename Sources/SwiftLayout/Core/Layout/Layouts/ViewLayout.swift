import SwiftLayoutPlatform

/// A layout that wraps a view with optional anchors, sublayouts, and activation callbacks.
///
/// `ViewLayout` is the primary layout type created when using the `.sl` extension methods
/// on views. It represents a view in the layout hierarchy along with its constraints
/// and child layouts.
///
/// ## Overview
///
/// You typically create `ViewLayout` instances through the `.sl` extension:
///
/// ```swift
/// parentView.sl.sublayout {
///     childView.sl.anchors {
///         Anchors.allSides.equalToSuper()
///     }
/// }
/// ```
///
/// ## Method Chaining
///
/// `ViewLayout` supports fluent method chaining:
///
/// ```swift
/// view.sl
///     .identifying("myView")
///     .onActivate { $0.backgroundColor = .red }
///     .anchors { Anchors.center.equalToSuper() }
///     .sublayout { childView }
/// ```
public struct ViewLayout<V: SLView, Sublayout: Layout>: Layout {
    private var view: V
    private let sublayout: Sublayout
    private let anchors: Anchors

    typealias OnActivateBlock = (V) -> Void

    private let onActivateBlock: OnActivateBlock?

    init(_ view: V, sublayout: Sublayout, anchors: Anchors = Anchors(), onActivate: OnActivateBlock? = nil) {
        self.view = view
        self.sublayout = sublayout
        self.anchors = anchors
        self.onActivateBlock = onActivate
    }

    public func layoutComponents(superview: SLView?, option: LayoutOption) -> [LayoutComponent] {
        let component = LayoutComponent(superview: superview, node: ViewNode(view), anchors: anchors, option: option)
        let sublayoutComponents: [LayoutComponent] = sublayout.layoutComponents(superview: view, option: .none)

        return [component] + sublayoutComponents
    }

    public func layoutWillActivate() {
        onActivateBlock?(view)

        sublayout.layoutWillActivate()
    }

    public func layoutDidActivate() {
        sublayout.layoutDidActivate()
    }
}
extension ViewLayout {

    /// Adds anchors (constraints) to this layout.
    ///
    /// ``Anchors`` express **NSLayoutConstraint** and can be applied through this method.
    ///
    /// ```swift
    /// subView.sl.anchors {
    ///     Anchors.top.equalTo(rootView, constant: 10)
    ///     Anchors.centerX.equalTo(rootView)
    ///     Anchors.size.equalTo(rootView).multiplier(0.5)
    /// }
    /// ```
    ///
    /// - Parameter build: An ``AnchorsBuilder`` closure that creates ``Anchors`` to be applied.
    /// - Returns: The layout with anchors added.
    public func anchors(@AnchorsBuilder _ build: () -> Anchors) -> Self {
        let anchors = self.anchors
        anchors.append(build())
        return Self(view, sublayout: sublayout, anchors: anchors, onActivate: onActivateBlock)
    }

    /// Adds sublayouts (child views) to this layout.
    ///
    /// Sublayouts are added to the view hierarchy through `addSubview(_:)`.
    ///
    /// ```swift
    /// parentView.sl.sublayout {
    ///     childView.sl.anchors {
    ///         Anchors.allSides.equalToSuper()
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter build: A ``LayoutBuilder`` closure that creates sublayouts.
    /// - Returns: The layout with sublayouts added.
    public func sublayout<L: Layout>(@LayoutBuilder _ build: () -> L) -> ViewLayout<V, TupleLayout2<Sublayout, L>> {
        let sublayout = TupleLayout2(self.sublayout, build())
        return ViewLayout<V, TupleLayout2<Sublayout, L>>(view, sublayout: sublayout, anchors: anchors, onActivate: onActivateBlock)
    }

    /// Adds an action to perform before every activation, including updates.
    ///
    /// ```swift
    /// var layout: some Layout {
    ///     label.sl.onActivate { label in
    ///         label.backgroundColor = .blue
    ///         label.text = "hello"
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter perform: A closure to execute before activation.
    /// - Returns: The layout with the onActivate action added.
    public func onActivate(_ perform: @escaping (V) -> Void) -> Self {
        Self(view, sublayout: sublayout, anchors: anchors, onActivate: perform)
    }

    /// Sets the view's `accessibilityIdentifier`.
    ///
    /// - Parameter accessibilityIdentifier: A string identifier for the view.
    /// - Returns: The layout with the identifier applied.
    public func identifying(_ accessibilityIdentifier: String) -> Self {
        SwiftLayoutPlatformHelper.setViewIdentifier(view, accessibilityIdentifier)
        return self
    }
}
