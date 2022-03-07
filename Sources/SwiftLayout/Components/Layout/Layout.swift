//
//  Layout.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import UIKit

public typealias TraverseHandler = (_ information: ViewInformation) -> Bool
public typealias ConstraintHandler = (_ information: ViewInformation?, _ constraints: Anchors) -> Void

public protocol Layout: CustomDebugStringConvertible {
    func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler)
    func traverse(_ superview: UIView?, constraintHndler handler: ConstraintHandler)
}

extension Layout {
    
    ///
    /// Activate this layout.
    ///
    /// - Returns: A ``Activation`` instance, which you use when you update or deactivate layout. Deallocation of the result will deactivate layout.
    ///
    public func active() -> Activation {
        Activator.active(layout: self)
    }
    
    ///
    /// Update layout changes from the activation of the previously activated layout.
    ///
    /// - Parameter activation: The activation of the previously activated layout. It is used to identify changes in layout.
    /// - Returns: A ``Activation`` instance, which you use when you update or deactivate layout. Deallocation of the result will deactivate layout.
    ///
    public func update(fromActivation activation: Activation) -> Activation {
        Activator.update(layout: self, fromActivation: activation)
    }
    
    ///
    /// Activate this layout permanently.
    /// Until the view is released according to the lifecycle of the app
    ///
    public func finalActive() {
        Activator.finalActive(layout: self)
    }
    
    ///
    /// Wraps this layout with a type eraser.
    ///
    /// - Returns: An ``AnyLayout`` wrapping this layout.
    ///
    public var anyLayout: AnyLayout {
        AnyLayout(self)
    }
    
    ///
    /// Create an ``AnchorsLayout`` containing the  ``Anchors`` of this layout.
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
    /// - Returns: An ``AnchorsLayout`` that wraps this layout and contains the anchors .
    ///
    public func anchors(@AnchorsBuilder _ build: () -> Anchors) -> AnchorsLayout<Self> {
        AnchorsLayout(layout: self, anchors: build())
    }
    
    ///
    /// Create a ``SublayoutLayout`` containing the sublayouts of this layout.
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
    /// - Returns: An ``SublayoutLayout`` that wraps this layout and contains sublayouts .
    ///
    public func sublayout<L: Layout>(@LayoutBuilder _ build: () -> L) -> SublayoutLayout<Self, L> {
        SublayoutLayout(self, build())
    }
    
    ///
    /// Find the view object for this layout and set its **accessibilityIdentifier**.
    ///
    /// - Parameter accessibilityIdentifier: A string containing the identifier of the element.
    /// - Returns: The layout itself with the accessibilityIdentifier applied
    ///
    public func identifying(_ accessibilityIdentifier: String) -> some Layout {
        firstViewInformation(nil)?.view?.accessibilityIdentifier = accessibilityIdentifier
        return self
    }
    
    ///
    /// Set the **accessibilityIdentifier** of all view objects included in the layout hierarchy to the property name of the object that has each views.
    ///
    /// - Parameter rootObject: root object for referencing property names
    /// - Returns: The layout itself with the **accessibilityIdentifier** applied
    ///
    public func updateIdentifiers(rootObject: AnyObject) -> some Layout {
        IdentifierUpdater.nameOnly.update(rootObject)
        return self
    }
}

extension Layout {
    func firstViewInformation(_ superview: UIView?) -> ViewInformation? {
        var information: ViewInformation?
        traverse(superview) { currentViewInformation in
            information = currentViewInformation
            return false
        }
        return information
    }
    
    var viewInformations: [ViewInformation] {
        var informations: [ViewInformation] = []
        traverse(nil) { information in
            informations.append(information)
            return true
        }
        return informations
    }
    
    func viewConstraints(_ viewInfoSet: ViewInformationSet) -> [NSLayoutConstraint] {
        var layoutConstraints: [NSLayoutConstraint] = []
        traverse(nil) { information, constraints in
            guard let subview = information?.view else {
                return
            }

            layoutConstraints.append(contentsOf: constraints.constraints(item: subview, toItem: information?.superview, viewInfoSet: viewInfoSet))
        }
        return layoutConstraints
    }
    
    func viewConstraints() -> [NSLayoutConstraint] {
        self.viewConstraints(.init())
    }
}
