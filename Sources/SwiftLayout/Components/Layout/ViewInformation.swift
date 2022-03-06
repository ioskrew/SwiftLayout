//
//  ViewPair.swift
//  
//
//  Created by oozoofrog on 2022/02/14.
//

import Foundation
import UIKit

public final class ViewInformation: Hashable, CustomDebugStringConvertible {
    
    public init(superview: UIView?, view: UIView?) {
        self.superview = superview
        self.view = view
    }
    
    private(set) public weak var superview: UIView?
    private(set) public weak var view: UIView?
    public var identifier: String? { view?.accessibilityIdentifier }
    
    func addSuperview() {
        guard let view = view else {
            return
        }
        if superview != view.superview {
            superview?.addSubview(view)
        }
    }
    
    func removeFromSuperview() {
        guard superview == view?.superview else { return }
        view?.removeFromSuperview()
    }
    
    func updatingSuperview(_ superview: UIView?) -> Self {
        .init(superview: superview, view: view)
    }
    
    public var debugDescription: String {
        "\(superview?.tagDescription ?? "nil"):\(view?.tagDescription ?? "nil")"
    }
}

// MARK: - Hashable
extension ViewInformation {
    
    public static func == (lhs: ViewInformation, rhs: ViewInformation) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(superview)
        hasher.combine(view)
    }
}

public struct ViewInformationSet: Hashable {
    
    let infos: Set<ViewInformation>
    var rootview: UIView? { infos.first(where: { $0.superview == nil })?.view }
    
    init(infos: [ViewInformation] = []) {
        self.infos = Set(infos)
    }
    
    subscript(_ identifier: String) -> UIView? {
        infos.first(where: { $0.identifier == identifier })?.view
    }
}
