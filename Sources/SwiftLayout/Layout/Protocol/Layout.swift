//
//  Layout.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import UIKit

public typealias TraverseHandler = (_ superview: UIView?, _ subview: UIView, _ identifier: String?, _ animationDisabled: Bool) -> Void
public typealias ConstraintHandler = (_ superview: UIView?, _ subview: UIView, _ constraints: [Constraint], _ viewInfoSet: ViewInformationSet) -> Void

public protocol Layout: CustomDebugStringConvertible {
    func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: TraverseHandler)
    func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: ConstraintHandler)
}

extension Layout {
    public func active(_ options: LayoutOptions = []) -> Deactivable {
        Activator.active(layout: self, options: options)
    }
    
    public var anyLayout: AnyLayout {
        AnyLayout(self)
    }
    public func anchors(@AnchorsBuilder _ build: () -> [Constraint]) -> AnchorsLayout<Self> {
        AnchorsLayout(layout: self, anchors: build())
    }
    
    public func sublayout<L: Layout>(@LayoutBuilder _ build: () -> L) -> SublayoutLayout<Self, L> {
        SublayoutLayout(self, build())
    }
    
    @available(*, deprecated, message: "using sublayout instead of this")
    public func subviews<L: Layout>(@LayoutBuilder _ build: () -> L) -> some Layout {
        sublayout(build)
    }
}

public extension Layout where Self: UIView {
    func callAsFunction<L: Layout>(@LayoutBuilder _ build: () -> L) -> some Layout {
        ViewLayout(self, sublayout: build())
    }
    
    func identifying(_ identifier: String) -> some Layout {
        let layout = ViewLayout(self, sublayout: EmptyLayout())
        layout.identifier = identifier
        return layout
    }
}

extension Layout {
    public var viewInformations: [ViewInformation] {
        var informations: [ViewInformation] = []
        traverse(nil, continueAfterViewLayout: true) { superview, subview, identifier, animationDisabled in
            informations.append(.init(superview: superview, view: subview, identifier: identifier, animationDisabled: animationDisabled))
        }
        return informations
    }
    
    public func viewConstraints(_ viewInfoSet: ViewInformationSet) -> [NSLayoutConstraint] {
        var layoutConstraints: [NSLayoutConstraint] = []
        traverse(nil, viewInfoSet: viewInfoSet) { superview, subview, constraints, viewInfoSet in
            layoutConstraints.append(contentsOf: constraints.constraints(item: subview, toItem: superview, viewInfoSet: viewInfoSet))
        }
        return layoutConstraints
    }
    
    public func viewConstraints() -> [NSLayoutConstraint] {
        self.viewConstraints(.init())
    }
}

extension UIView: Layout {}

extension Optional: Layout where Wrapped: Layout {
    public func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: (UIView?, UIView, String?, Bool) -> Void) {
        self?.traverse(superview, continueAfterViewLayout: continueAfterViewLayout, traverseHandler: handler)
    }
    
    public func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: (UIView?, UIView, [Constraint], ViewInformationSet) -> Void) {
        self?.traverse(superview, viewInfoSet: viewInfoSet, constraintHndler: handler)
    }
}

public extension UIView {
    func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: TraverseHandler) {
        handler(superview, self, self.accessibilityIdentifier, false)
    }
    func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: (UIView?, UIView, [Constraint], ViewInformationSet) -> Void) {}
}
