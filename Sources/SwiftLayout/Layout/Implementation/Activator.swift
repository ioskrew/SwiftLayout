//
//  Activator.swift
//  
//
//  Created by aiden_h on 2022/02/16.
//

import Foundation
import UIKit

enum Activator {
    static func active(layout: LayoutImp, options: LayoutOptions = []) -> Deactivation {
        return update(layout: layout, options: options)
    }

    @discardableResult
    static func update(layout: LayoutImp, fromDeactivation deactivation: Deactivation = Deactivation(), animated: Bool = false) -> Deactivation {
        update(layout: layout, fromDeactivation: deactivation, options: .usingAnimation)
    }
    
    @discardableResult
    static func update(layout: LayoutImp, fromDeactivation deactivation: Deactivation = Deactivation(), options: LayoutOptions) -> Deactivation {
        let viewInfos = layout.viewInformations
        let viewInfoSet = ViewInformationSet(infos: viewInfos)
        
        deactivate(deactivation: deactivation, withViewInformationSet: viewInfoSet)
        
        let constrains = layout.viewConstraints(viewInfoSet)
        
        if options.contains(.accessibilityIdentifiers) {
            if let rootobject = options.objectForAccessibilityIdentifier ?? viewInfoSet.rootview {
                AccessibilityIdentifierUpdater(rootobject).update()
            }
        }
        
        
        activate(viewInfos: viewInfos, constrains: constrains)
        
        deactivation.viewInfos = viewInfoSet
        deactivation.constraints = ConstraintsSet(constraints: constrains)
        
        if options.contains(.usingAnimation), let root = viewInfos.first(where: { $0.superview == nil })?.view {
            UIView.animate(withDuration: 0.25) {
                root.layoutIfNeeded()
                viewInfos.forEach { information in
                    information.animation()
                }
            }
        }
        
        return deactivation
    }
}

private extension Activator {
    static func deactivate(deactivation: Deactivation, withViewInformationSet viewInfoSet: ViewInformationSet) {
        deactivation.deactiveConstraints()
        
        for existedView in deactivation.viewInfos.infos where !viewInfoSet.infos.contains(existedView) {
            existedView.removeFromSuperview()
        }
    }
    
    static func activate(viewInfos: [ViewInformation], constrains: [NSLayoutConstraint]) {
        for viewInfo in viewInfos {
            viewInfo.addSuperview()
        }
        
        NSLayoutConstraint.activate(constrains)
    }
}
