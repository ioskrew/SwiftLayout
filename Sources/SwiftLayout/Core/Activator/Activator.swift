//
//  Activator.swift
//
//
//  Created by aiden_h on 2022/02/16.
//

import UIKit

@MainActor
enum Activator {
    static func active<L: Layout>(layout: L, forceLayout: Bool = false) -> Activation {
        return update(layout: layout, fromActivation: Activation(), forceLayout: forceLayout)
    }

    static func update<L: Layout>(layout: L, fromActivation activation: Activation, forceLayout: Bool) -> Activation {
        willActivate(layout: layout)

        let prevInfoHashValues = Set(activation.viewInfos.map(\.hashValue))

        let elements = LayoutElements(layout: layout)

        let viewInfos = elements.viewInformations
        updateViews(activation: activation, viewInfos: viewInfos)

        let constraints = elements.viewConstraints
        updateConstraints(activation: activation, constraints: constraints)

        if forceLayout {
            layoutIfNeeded(viewInfos, prevInfoHashValues)
        }

        didActivate(layout: layout)

        return activation
    }
}

extension Activator {
    static func finalActive<L: Layout>(layout: L, forceLayout: Bool) {
        willActivate(layout: layout)

        let elements = LayoutElements(layout: layout)

        let viewInfos = elements.viewInformations
        updateViews(viewInfos: viewInfos)

        let constraints = elements.viewConstraints
        updateConstraints(constraints: constraints)

        if forceLayout {
            layoutIfNeeded(viewInfos)
        }

        didActivate(layout: layout)
    }
}

private extension Activator {
    static func willActivate<L: Layout>(layout: L) {
        layout.layoutWillActivate()
    }

    static func didActivate<L: Layout>(layout: L) {
        layout.layoutDidActivate()
    }

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
        let news = Set(ofWeakConstraintsFrom: constraints)
        let olds = activation.constraints.filter { $0.origin != nil }

        let needToDeactivate = olds.subtracting(news)
        let needToActivate = news.subtracting(olds)

        NSLayoutConstraint.deactivate(needToDeactivate.compactMap(\.origin).filter(\.isActive))
        NSLayoutConstraint.activate(needToActivate.compactMap(\.origin))

        activation.constraints = olds.subtracting(needToDeactivate).union(needToActivate)
    }

    static func updateConstraints(constraints: [NSLayoutConstraint]) {
        let news = Set(ofWeakConstraintsFrom: constraints)
        NSLayoutConstraint.activate(news.compactMap(\.origin))
    }

    static func layoutIfNeeded(_ viewInfos: [ViewInformation], _ prevInfoHashValues: Set<Int> = []) {
        for viewInfo in viewInfos {
            if viewInfo.superview == nil, let view = viewInfo.view {
                view.setNeedsLayout()
                view.layoutIfNeeded()
            }
            if !prevInfoHashValues.contains(viewInfo.hashValue) {
                // for newly add to superview
                viewInfo.view?.layer.removeAnimation(forKey: "bounds.size")
                viewInfo.view?.layer.removeAnimation(forKey: "position")
            }
        }
    }
}
