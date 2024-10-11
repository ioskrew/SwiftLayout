//
//  ViewPair.swift
//  
//
//  Created by oozoofrog on 2022/02/14.
//

import UIKit

final class ViewInformation: Hashable {

    init(superview: UIView?, view: UIView?, option: LayoutOption) {
        self.superview = superview
        self.view = view
        self.option = option
    }

    private(set) public weak var superview: UIView?
    private(set) public weak var view: UIView?
    var option: LayoutOption
    @MainActor var identifier: String? { view?.accessibilityIdentifier }

    @MainActor
    func addSuperview() {
        guard let view else {
            return
        }
        superview?.addSubview(view)

        if let stackSuperView = superview as? UIStackView, option.contains(.isNotArranged) == false {
            stackSuperView.addArrangedSubview(view)
        }
    }

    @MainActor
    func removeFromSuperview() {
        guard superview == view?.superview else { return }
        view?.removeFromSuperview()
    }
}

// MARK: - Hashable
extension ViewInformation {

    static func == (lhs: ViewInformation, rhs: ViewInformation) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(superview)
        hasher.combine(view)
    }
}
