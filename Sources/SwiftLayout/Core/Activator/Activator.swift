//
//  Activator.swift
//  
//
//  Created by aiden_h on 2022/02/16.
//

import UIKit
import _SwiftLayoutUtil

enum Activator {
    
    static func active<L: Layout>(layout: L, forceLayout: Bool = false) -> Activation {
        return update(layout: layout, fromActivation: Activation(), forceLayout: forceLayout)
    }
    
    @discardableResult
    static func update<L: Layout>(layout: L, fromActivation activation: Activation, forceLayout: Bool) -> Activation {
        var prevInfos: [ViewInformation: Set<WeakReference<NSLayoutConstraint>>] = [:]
        for viewInfo in activation.viewInfos {
            guard let view = viewInfo.view else { continue }
            prevInfos[viewInfo] = Set(view.constraints.weakens)
        }

        let elements = LayoutElements(layout: layout)
        
        let viewInfos = elements.viewInformations
        updateViews(activation: activation, viewInfos: viewInfos)

        let constraints = elements.viewConstraints
        updateConstraints(activation: activation, constraints: constraints)

        if forceLayout {
            layoutIfNeeded(viewInfos, prevInfos)
        }
        
        return activation
    }
}

extension Activator {
    public static func finalActive<L: Layout>(layout: L, forceLayout: Bool) {
        let elements = LayoutElements(layout: layout)
        
        let viewInfos = elements.viewInformations
        updateViews(viewInfos: viewInfos)
        
        let constraints = elements.viewConstraints
        updateConstraints(constraints: constraints)
        
        if forceLayout {
            layoutIfNeeded(viewInfos)
        }
    }
}

private extension Activator {
    static func updateViews(activation: Activation, viewInfos: [ViewInformation]) {
        let newInfos = viewInfos
        let newInfosSet = Set(newInfos)
        let oldInfos = activation.viewInfos
        
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
        }
        
        activation.viewInfos = viewInfos
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
    
    static func updateConstraints(activation: Activation, constraints: [NSLayoutConstraint]) {
        let news = Set(constraints.weakens)
        let olds = Set(activation.constraints)
        
        NSLayoutConstraint.deactivate(olds.compactMap(\.origin).filter(\.isActive))
        NSLayoutConstraint.activate(news.compactMap(\.origin))
        activation.constraints = news
    }
    
    static func updateConstraints(constraints: [NSLayoutConstraint]) {
        let news = Set(constraints.weakens)
        NSLayoutConstraint.activate(news.compactMap(\.origin))
    }
    
    static func layoutIfNeeded(_ viewInfos: [ViewInformation], _ prevInfos: [ViewInformation: Set<WeakReference<NSLayoutConstraint>>] = [:]) {
        for viewInfo in viewInfos {
            if viewInfo.superview == nil, let view = viewInfo.view {
                view.setNeedsLayout()
                view.layoutIfNeeded()
            }
            if prevInfos[viewInfo] == nil {
                // for newly add to superview
                viewInfo.view?.layer.removeAnimation(forKey: "bounds.size")
                viewInfo.view?.layer.removeAnimation(forKey: "position")
            }
        }
    }
}
