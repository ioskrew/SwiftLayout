//
//  Layout.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import UIKit

public typealias TraverseHandler = (_ information: ViewInformation) -> Bool
public typealias ConstraintHandler = (_ information: ViewInformation?, _ constraints: [Constraint]) -> Void

public protocol Layout: CustomDebugStringConvertible {
    func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler)
    func traverse(_ superview: UIView?, constraintHndler handler: ConstraintHandler)
}

extension Layout {
    public func active(_ options: LayoutOptions = []) -> AnyDeactivable {
        AnyDeactivable(Activator.active(layout: self, options: options))
    }
    
    public func update(fromDeactivable deactivable: Deactivable, _ options: LayoutOptions = []) -> AnyDeactivable {
        if let deactivation = deactivable.deactivation {
            Activator.update(layout: self, fromDeactivation: deactivation, options: options)
            return AnyDeactivable(deactivation)
        } else {
            return AnyDeactivable(Activator.active(layout: self, options: options))
        }
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
