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
    public func active() -> Activation {
        Activator.active(layout: self)
    }
    
    public func update(fromActivation activation: Activation) -> Activation {
        Activator.update(layout: self, fromActivation: activation)
    }
    
    public func finalActive() {
        Activator.finalActive(layout: self)
    }
    
    public var anyLayout: AnyLayout {
        AnyLayout(self)
    }
    
    public func anchors(@AnchorsBuilder _ build: () -> Anchors) -> AnchorsLayout<Self> {
        AnchorsLayout(layout: self, anchors: build())
    }
    
    public func sublayout<L: Layout>(@LayoutBuilder _ build: () -> L) -> SublayoutLayout<Self, L> {
        SublayoutLayout(self, build())
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
