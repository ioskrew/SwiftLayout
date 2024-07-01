import UIKit

public struct ViewLayout<V: UIView>: Layout {

    private let innerView: V

    public private(set) var sublayouts: [any Layout]

    public private(set) var anchors: Anchors

    public var option: LayoutOption? { LayoutOption.none }

    typealias OnActivateBlock = (V) -> Void

    private let onActivateBlock: OnActivateBlock?

    init(_ view: V, sublayouts: [any Layout] = [], anchors: Anchors = Anchors(), onActivate: OnActivateBlock? = nil) {
        self.innerView = view
        self.sublayouts = sublayouts
        self.anchors = anchors
        self.onActivateBlock = onActivate
    }

    public var view: UIView? {
        self.innerView
    }

    public func layoutWillActivate() {
        self.onActivateBlock?(innerView)
    }
}

extension ViewLayout {

    ///
    /// Add anchors coordinator to this layout
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
    /// - Returns: The layout itself  with anchors coordinator added
    ///
    public func anchors(@AnchorsBuilder _ build: () -> Anchors) -> Self {
        let anchors = self.anchors
        anchors.append(build())
        return Self(innerView, sublayouts: sublayouts, anchors: anchors, onActivate: onActivateBlock)
    }

    ///
    /// Add sublayout coordinator to this layout
    ///
    /// Sublayouts contained within the builder block are added to the view hierarchy through **addSubview(_:)** to the view object of the current layout.
    /// ```swift
    /// // The hierarchy of views can be expressed as follows,
    /// // and means that UILabel is a subview of UIView.
    ///
    /// UIView().sublayout {
    ///     UILabel()
    /// }
    /// ```
    ///
    /// - Parameter build: A ``LayoutBuilder`` that  create sublayouts of this layout.
    /// - Returns: The layout itself with sublayout coordinator added
    ///
    public func sublayout<L: Layout>(@LayoutBuilder _ build: () -> L) -> Self {
        var sublayouts = self.sublayouts
        sublayouts.append(build())
        return Self(innerView, sublayouts: sublayouts, anchors: anchors, onActivate: onActivateBlock)
    }

    ///
    /// Add an action to this layout to always perform before every activation, including updates.
    ///
    /// ```swift
    /// // Create an instant view within the layout block
    /// // and modify the properties of the view as follows
    ///
    /// var layout: some Layout {
    ///     UILabel().sl.onActivate { view in
    ///         view.backgroundColor = .blue
    ///         view.text = "hello"
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter onActivate: A perform block for this layout.
    /// - Returns: The layout itself with onActivate action added
    ///
    public func onActivate(_ perform: @escaping (V) -> Void) -> Self {
        Self(innerView, sublayouts: sublayouts, anchors: anchors, onActivate: perform)
    }

    ///
    /// Set  **accessibilityIdentifier** of view.
    ///
    /// - Parameter accessibilityIdentifier: A string containing the identifier of the element.
    /// - Returns: The layout itself with the accessibilityIdentifier applied
    ///
    public func identifying(_ accessibilityIdentifier: String) -> Self {
        innerView.accessibilityIdentifier = accessibilityIdentifier
        return self
    }
}
