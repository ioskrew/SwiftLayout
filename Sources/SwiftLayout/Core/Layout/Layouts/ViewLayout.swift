import Foundation

public struct ViewLayout<V: SLView, SubLayout: Layout>: Layout {
    
    let innerView: V
    var sublayout: SubLayout
    var coordinators: [Coordinator]
    
    init(_ view: V, sublayout: SubLayout) {
        self.innerView = view
        self.sublayout = sublayout
        self.coordinators = []
    }
    
    public var view: SLView? {
        self.innerView
    }
    
    public var sublayouts: [Layout] {
        [sublayout] + coordinators.compactMap(\.sublayout)
    }
    
    public var anchors: Anchors? {
        coordinators.compactMap(\.anchors).reduce(Anchors(), +)
    }

    public var debugDescription: String {
        innerView.tagDescription + ": [\(sublayout.debugDescription)]"
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
        var viewLayout = self
        viewLayout.coordinators.append(.anchors(build()))
        return viewLayout
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
        var viewLayout = self
        viewLayout.coordinators.append(.sublayout(build()))
        return viewLayout
    }
    
    ///
    /// Set  **accessibilityIdentifier** of view.
    ///
    /// - Parameter accessibilityIdentifier: A string containing the identifier of the element.
    /// - Returns: The layout itself with the accessibilityIdentifier applied
    ///
    public func identifying(_ accessibilityIdentifier: String) -> Self {
        innerView.slIdentifier = accessibilityIdentifier
        return self
    }
}

extension ViewLayout {
    
    enum Coordinator {
        case sublayout(_ layout: Layout)
        case anchors(_ anchors: Anchors)
        
        var sublayout: Layout? {
            switch self {
            case .sublayout(let layout):
                return layout
            default:
                return nil
            }
        }
        
        var anchors: Anchors? {
            switch self {
            case .anchors(let anchors):
                return anchors
            default:
                return nil
            }
        }
    }
}
