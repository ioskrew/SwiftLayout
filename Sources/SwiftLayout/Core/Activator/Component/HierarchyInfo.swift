//
//  HierarchyInfo.swift
//
//
//  Created by oozoofrog on 2022/02/14.
//

import UIKit

final class HierarchyInfo: Hashable {
    init(superview: UIView?, node: any HierarchyNodable, option: LayoutOption) {
        self.superview = superview
        self.node = node
        self.option = option
    }

    private(set) public weak var superview: UIView?
    private(set) public var node: any HierarchyNodable
    var option: LayoutOption

    @MainActor var identifier: String? { node.nodeIdentifier }

    @MainActor
    func updateTranslatesAutoresizingMaskIntoConstraints() {
        if superview != nil {
            node.updateTranslatesAutoresizingMaskIntoConstraints()
        }
    }

    @MainActor
    func addToSuperview() {
        node.addToSuperview(superview, option: option)
    }

    @MainActor
    func removeFromSuperview() {
        node.removeFromSuperview(superview)
    }

    @MainActor
    func forceLayoutIfNeeded( _ prevInfoHashValues: Set<Int>) {
        if superview == nil {
            node.forceLayout()
        }
        if !prevInfoHashValues.contains(hashValue) {
            node.removeSizeAndPositionAnimation()
        }
    }
}

// MARK: - Hashable
extension HierarchyInfo {

    static func == (lhs: HierarchyInfo, rhs: HierarchyInfo) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(superview)
        hasher.combine(node.baseObjectIdentifier)
    }
}
