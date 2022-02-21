//
//  Activator.swift
//  
//
//  Created by aiden_h on 2022/02/16.
//

import Foundation
import UIKit

enum Activator {
    
    static func active<L: Layout>(layout: L, options: LayoutOptions = []) -> Deactivation<AnyLayoutBuilding<L>> {
        return update(layout: layout, fromDeactivation: Deactivation(building: AnyLayoutBuilding(layout)), options: options)
    }
    
    static func active<L: Layout, LB: LayoutBuilding>(layout: L, options: LayoutOptions = [], building: LB) -> Deactivation<LB>  where LB.LayoutBody == L {
        return update(layout: layout, fromDeactivation: Deactivation(building: building), options: options)
    }

    @discardableResult
    static func update<L: Layout, LB: LayoutBuilding>(layout: L, fromDeactivation deactivation: Deactivation<LB>, options: LayoutOptions) -> Deactivation<LB> {
        let viewInfos = layout.viewInformations
        let viewInfoSet = ViewInformationSet(infos: viewInfos)
        
        deactivate(deactivation: deactivation, withViewInformationSet: viewInfoSet)
        
        if options.contains(.automaticIdentifierAssignment) {
            updateIdentifiers(fromBuilding: deactivation.building, viewInfoSet: viewInfoSet)
        }
        
        let constrains = layout.viewConstraints(viewInfoSet)
        
        activate(viewInfos: viewInfos, constrains: constrains)
        
        deactivation.viewInfos = viewInfoSet
        deactivation.constraints = ConstraintsSet(constraints: constrains)
        
        if options.contains(.usingAnimation) {
            animate(viewInfos: viewInfos)
        }
        
        return deactivation
    }
}

private extension Activator {
    static func deactivate<LB: LayoutBuilding>(deactivation: Deactivation<LB>, withViewInformationSet viewInfoSet: ViewInformationSet) {
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
    
    static func updateIdentifiers<LB: LayoutBuilding>(fromBuilding building: LB?, viewInfoSet: ViewInformationSet) {
        guard let rootobject: AnyObject = building ?? viewInfoSet.rootview else {
            assertionFailure("Could not find root view for LayoutOptions.accessibilityIdentifiers. Please use LayoutBuilding.")
            return
        }
        
        IdentifierUpdater(rootobject).update()
    }
    
    static func animate(viewInfos: [ViewInformation]) {
        guard let root = viewInfos.first(where: { $0.superview == nil })?.view else {
            return
        }
        
        UIView.animate(withDuration: 0.25) {
            root.layoutIfNeeded()
            viewInfos.forEach { information in
                information.animation()
            }
        }
    }
}
