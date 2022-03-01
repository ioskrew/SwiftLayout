//
//  Layout.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import UIKit

public typealias TraverseHandler = (_ information: ViewInformation) -> Bool
public typealias ConstraintHandler = (_ superview: UIView?, _ subview: UIView?, _ constraints: [Constraint]) -> Void

public protocol Layout: CustomDebugStringConvertible {
    func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler)
    func traverse(_ superview: UIView?, constraintHndler handler: ConstraintHandler)
}

extension Layout {
    public func active(_ options: LayoutOptions = []) -> AnyDeactivable {
        AnyDeactivable(Activator.active(layout: self, options: options))
    }
    
    public func finalActive(_ options: LayoutOptions = []) {
        Activator.finalActive(layout: self, options: options)
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
    
    public func identifying(_ accessibilityIdentifier: String) -> some Layout {
        firstViewInformation(nil)?.view?.accessibilityIdentifier = accessibilityIdentifier
        return self
    }
}

extension Layout {
    public func firstViewInformation(_ superview: UIView?) -> ViewInformation? {
        var information: ViewInformation?
        traverse(superview) { currentViewInformation in
            information = currentViewInformation
            return false
        }
        return information
    }
    
    public var viewInformations: [ViewInformation] {
        var informations: [ViewInformation] = []
        traverse(nil) { information in
            informations.append(information)
            return true
        }
        return informations
    }
    
    public func viewConstraints(_ viewInfoSet: ViewInformationSet) -> [NSLayoutConstraint] {
        var layoutConstraints: [NSLayoutConstraint] = []
        traverse(nil) { superview, subview, constraints in
            guard let subview = subview else { return }
            if constraints.isEmpty { return }
            layoutConstraints.append(contentsOf: constraints.constraints(item: subview, toItem: superview, viewInfoSet: viewInfoSet))
        }
        return layoutConstraints
    }
    
    public func viewConstraints() -> [NSLayoutConstraint] {
        self.viewConstraints(.init())
    }
}
