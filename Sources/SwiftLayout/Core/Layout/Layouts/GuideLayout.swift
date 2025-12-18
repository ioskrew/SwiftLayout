import SwiftLayoutPlatform

/// A layout that wraps a layout guide with optional anchors.
///
/// `GuideLayout` represents a `UILayoutGuide` (or `NSLayoutGuide` on macOS) in the layout hierarchy.
/// Layout guides provide a rectangular area for positioning views without adding extra views
/// to the hierarchy.
///
/// ## Overview
///
/// Create layout guides within a view's sublayout:
///
/// ```swift
/// containerView.sl.sublayout {
///     UILayoutGuide().sl.identifying("spacer").anchors {
///         Anchors.top.equalToSuper()
///         Anchors.horizontal.equalToSuper()
///         Anchors.height.equalTo(constant: 50)
///     }
///
///     contentView.sl.anchors {
///         Anchors.top.equalTo("spacer", attribute: .bottom)
///         Anchors.horizontal.equalToSuper()
///     }
/// }
/// ```
public struct GuideLayout<LayoutGuide: SLLayoutGuide>: Layout {
    private var guide: LayoutGuide
    private let anchors: Anchors

    init(_ guide: LayoutGuide, anchors: Anchors = Anchors()) {
        self.guide = guide
        self.anchors = anchors
    }

    public func layoutComponents(superview: SLView?, option: LayoutOption) -> [LayoutComponent] {
        let component = LayoutComponent(superview: superview, node: GuideNode(guide), anchors: anchors, option: option)

        return [component]
    }

    public func layoutWillActivate() {
    }

    public func layoutDidActivate() {
    }
}
extension GuideLayout {

    /// Adds anchors (constraints) to this layout guide.
    ///
    /// ``Anchors`` express **NSLayoutConstraint** and can be applied through this method.
    ///
    /// ```swift
    /// layoutGuide.sl.anchors {
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
        return Self(guide, anchors: anchors)
    }

    /// Sets the layout guide's `identifier`.
    ///
    /// - Parameter identifier: A string that uniquely identifies the layout guide.
    /// - Returns: The layout with the identifier applied.
    public func identifying(_ identifier: String) -> Self {
        SwiftLayoutPlatformHelper.setGuideIdentifier(guide, identifier)
        return self
    }
}
