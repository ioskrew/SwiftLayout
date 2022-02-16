//
//  Activator.swift
//  
//
//  Created by aiden_h on 2022/02/16.
//

import Foundation
import UIKit

enum Activator {
    static func active(layout: LayoutImp) -> Deactivation {
        return update(layout: layout)
    }

    @discardableResult
    static func update(layout: LayoutImp, fromDeactivation deactivation: Deactivation = Deactivation(), animated: Bool = false) -> Deactivation {
        let viewInfos = layout.viewInformations
        let viewInfoSet = ViewInformationSet(infos: viewInfos)
        
        deactivate(deactivation: deactivation, withViewInformationSet: viewInfoSet)
        
        let constrains = layout.viewConstraints(viewInfoSet)
        
        activate(viewInfos: viewInfos, constrains: constrains)
        
        deactivation.viewInfos = viewInfoSet
        deactivation.constraints = ConstraintsSet(constraints: constrains)
        
        if animated, let root = viewInfos.first(where: { $0.superview == nil })?.view {
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
