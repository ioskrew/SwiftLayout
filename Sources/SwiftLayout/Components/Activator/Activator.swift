//
//  Activator.swift
//  
//
//  Created by aiden_h on 2022/02/16.
//

import Foundation
import UIKit

enum Activator {
    
    static func active<L: Layout>(layout: L, options: LayoutOptions = []) -> Deactivation {
        return update(layout: layout, fromDeactivation: Deactivation())
    }
    
    @discardableResult
    static func update<L: Layout>(layout: L, fromDeactivation deactivation: Deactivation) -> Deactivation {
        
        var prevInfos: [ViewInformation: Set<WeakReference<NSLayoutConstraint>>] = [:]
        for viewInfo in deactivation.viewInfos.infos {
            guard let view = viewInfo.view else { continue }
            prevInfos[viewInfo] = Set(view.constraints.weakens)
        }
        
        let viewInfos = layout.viewInformations
        let viewInfoSet = ViewInformationSet(infos: viewInfos)
        
        updateViews(deactivation: deactivation, viewInfos: viewInfos)
        
        let constraints = layout.viewConstraints(viewInfoSet)
        updateConstraints(deactivation: deactivation, constraints: constraints)
        
        for viewInfo in viewInfos {
            if let constraints = prevInfos[viewInfo] {
                if constraints != viewInfo.view.map({ Set($0.constraints.weakens) }) {
                    viewInfo.view?.layoutIfNeeded()
                }
            } else {
                // for newly add to superview
                viewInfo.view?.layer.removeAnimation(forKey: "bounds.size")
                viewInfo.view?.layer.removeAnimation(forKey: "position")
            }
        }
        
        return deactivation
    }
}

extension Activator {
    public static func finalActive<L: Layout>(layout: L, options: LayoutOptions = []) {
        let viewInfos = layout.viewInformations
        let viewInfoSet = ViewInformationSet(infos: viewInfos)
        
        updateViews(viewInfos: viewInfos)
        
        let constraints = layout.viewConstraints(viewInfoSet)
        
        updateConstraints(constraints: constraints)
    }
}

private extension Activator {
    static func updateViews(deactivation: Deactivation, viewInfos: [ViewInformation]) {
        let newInfos = viewInfos
        let newInfosSet = Set(newInfos)
        let oldInfos = deactivation.viewInfos.infos
        
        // remove old views
        for viewInfo in oldInfos where !newInfosSet.contains(viewInfo) {
            viewInfo.removeFromSuperview()
        }
        
        // add new views
        for viewInfo in newInfos {
            if viewInfo.superview != nil {
                viewInfo.view?.translatesAutoresizingMaskIntoConstraints = false
            }
            viewInfo.addSuperview()
            viewInfo.animation()
        }
        
        deactivation.viewInfos = ViewInformationSet(infos: viewInfos)
    }
    
    static func updateViews(viewInfos: [ViewInformation]) {
        let newInfos = viewInfos
        
        // add new views
        for viewInfo in newInfos {
            if viewInfo.superview != nil {
                viewInfo.view?.translatesAutoresizingMaskIntoConstraints = false
            }
            viewInfo.addSuperview()
        }
    }
    
    static func updateConstraints(deactivation: Deactivation, constraints: [NSLayoutConstraint]) {
        let news = Set(constraints.weakens)
        let olds = Set(deactivation.constraints)
        
        NSLayoutConstraint.deactivate(olds.compactMap(\.origin).filter(\.isActive))
        NSLayoutConstraint.activate(news.sorted().compactMap(\.origin))
        deactivation.constraints = news
    }
    
    static func updateConstraints(constraints: [NSLayoutConstraint]) {
        let news = Set(constraints.weakens)
        NSLayoutConstraint.activate(news.sorted().compactMap(\.origin))
    }
    
}
