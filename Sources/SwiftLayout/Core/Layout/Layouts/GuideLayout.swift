import SwiftLayoutPlatform

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

    ///
    /// Add anchors coordinator to this layout guide.
    ///
    /// ``Anchors`` express **NSLayoutConstraint**  can be applied through this method.
    /// ```swift
    /// // The constraints of the layout guide can be expressed as follows.
    ///
    /// layoutGuide.anchors {
    ///     Anchors(.top).equalTo(rootView, constant: 10)
    ///     Anchors(.centerX).equalTo(rootView)
    ///     Anchors(.width, .height).equalTo(rootView).setMultiplier(0.5)
    /// }
    ///
    /// // The following code performs the same role as the code above.
    ///
    /// NSLayoutConstraint.activate([
    ///     layoutGuide.topAnchor.constraint(equalTo: rootView.topAnchor, constant: 10),
    ///     layoutGuide.centerXAnchor.constraint(equalTo: rootView.centerXAnchor),
    ///     layoutGuide.widthAnchor.constraint(equalTo: rootView.widthAnchor, multiplier: 0.5),
    ///     layoutGuide.heightAnchor.constraint(equalTo: rootView.heightAnchor, multiplier: 0.5)
    /// ])
    /// ```
    ///
    /// - Parameter build: An ``AnchorsBuilder`` closure that creates ``Anchors`` to be applied to this layout guide.
    /// - Returns: The layout itself with the anchors coordinator added.
    ///
    public func anchors(@AnchorsBuilder _ build: () -> Anchors) -> Self {
        let anchors = self.anchors
        anchors.append(build())
        return Self(guide, anchors: anchors)
    }

    ///
    /// Set the **identifier** of the layout guide.
    ///
    /// - Parameter identifier: A string that uniquely identifies the layout guide.
    /// - Returns: The layout itself with the identifier applied.
    ///
    public func identifying(_ identifier: String) -> Self {
        SwiftLayoutPlatformHelper.setGuideIdentifier(guide, identifier)
        return self
    }
}
