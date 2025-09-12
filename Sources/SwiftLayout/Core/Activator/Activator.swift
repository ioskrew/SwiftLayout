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

        let prevInfoHashValues = Set(activation.hierarchyInfos.map(\.hashValue))

        let elements = LayoutElements(layout: layout)

        let hierarchyInfos = elements.hierarchyInfos
        updateViews(activation: activation, hierarchyInfos: hierarchyInfos)

        let constraints = elements.viewConstraints
        updateConstraints(activation: activation, constraints: constraints)

        if forceLayout {
            layoutIfNeeded(hierarchyInfos, prevInfoHashValues)
        }

        didActivate(layout: layout)

        return activation
    }
}

extension Activator {
    static func finalActive<L: Layout>(layout: L, forceLayout: Bool) {
        willActivate(layout: layout)

        let elements = LayoutElements(layout: layout)

        let hierarchyInfos = elements.hierarchyInfos
        updateViews(hierarchyInfos: hierarchyInfos)

        let constraints = elements.viewConstraints
        updateConstraints(constraints: constraints)

        if forceLayout {
            layoutIfNeeded(hierarchyInfos)
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

    static func updateViews(activation: Activation, hierarchyInfos: [HierarchyInfo]) {
        let newInfos = hierarchyInfos
        let newInfosSet = Set(hierarchyInfos)
        let oldInfos = activation.hierarchyInfos

        // remove old views
        for hierarchyInfo in oldInfos where !newInfosSet.contains(hierarchyInfo) {
            hierarchyInfo.removeFromSuperview()
        }

        // add new views
        for hierarchyInfo in newInfos {
            hierarchyInfo.updateTranslatesAutoresizingMaskIntoConstraints()
            hierarchyInfo.addToSuperview()
        }

        activation.hierarchyInfos = hierarchyInfos
    }

    static func updateViews(hierarchyInfos: [HierarchyInfo]) {
        let newInfos = hierarchyInfos

        // add new views
        for hierarchyInfo in newInfos {
            hierarchyInfo.updateTranslatesAutoresizingMaskIntoConstraints()
            hierarchyInfo.addToSuperview()
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

    static func layoutIfNeeded(_ hierarchyInfos: [HierarchyInfo], _ prevInfoHashValues: Set<Int> = []) {
        for hierarchyInfo in hierarchyInfos {
            hierarchyInfo.forceLayoutIfNeeded(prevInfoHashValues)
        }
    }
}
