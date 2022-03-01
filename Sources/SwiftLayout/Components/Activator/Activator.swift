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
        return update(layout: layout, fromDeactivation: Deactivation(), options: options)
    }
    
    @discardableResult
    static func update<L: Layout>(layout: L, fromDeactivation deactivation: Deactivation, options: LayoutOptions) -> Deactivation {
        let viewInfos = layout.viewInformations
        let viewInfoSet = ViewInformationSet(infos: viewInfos)
        
        updateViews(deactivation: deactivation, viewInfos: viewInfos)
        for viewInfo in viewInfos {
            viewInfo.captureCurrentFrame()
        }
        
        let constraints = layout.viewConstraints(viewInfoSet)
        
        if options.contains(.usingAnimation) {
            prepareAnimation(viewInfos: viewInfos)
        }
        
        if options.contains(.usingAnimation) {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [.beginFromCurrentState, .curveEaseInOut], animations: {
                self.updateConstraints(deactivation: deactivation, constraints: constraints)
                viewInfoSet.rootview?.layoutIfNeeded()
                for viewInfo in viewInfos {
                    viewInfo.animation()
                }
            }, completion: nil)
        } else {
            updateConstraints(deactivation: deactivation, constraints: constraints)
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
    
    static func prepareAnimation(viewInfos: [ViewInformation]) {
        let animationViewInfos = viewInfos.filter { view in
            !view.isNewlyAdded
        }
        animationViewInfos.forEach({ $0.captureCurrentFrame() })
    }
}
