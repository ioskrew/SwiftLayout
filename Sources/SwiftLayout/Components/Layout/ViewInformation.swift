//
//  ViewPair.swift
//  
//
//  Created by oozoofrog on 2022/02/14.
//

import Foundation
import UIKit

public final class ViewInformation: Hashable {
    
    public static func == (lhs: ViewInformation, rhs: ViewInformation) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public init(superview: UIView?, view: UIView?, identifier: String?, animationDisabled: Bool) {
        self.superview = superview
        self.view = view
        self.identifier = identifier
        self.animationDisabled = animationDisabled
    }
    
    private(set) public weak var superview: UIView?
    private(set) public weak var view: UIView?
    public let identifier: String?
    
    public let animationDisabled: Bool
    
    var capturedFrame: CGRect = .zero
    var isNewlyAdded: Bool = false
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(superview)
        hasher.combine(view)
        hasher.combine(identifier)
    }
    
    func addSuperview() {
        guard let view = view else {
            return
        }
        if superview == view.superview {
            isNewlyAdded = false
        } else {
            superview?.addSubview(view)
            isNewlyAdded = true
        }
    }
    
    func removeFromSuperview() {
        guard superview == view?.superview else { return }
        view?.removeFromSuperview()
    }
    
    func updatingSuperview(_ superview: UIView?) -> Self {
        .init(superview: superview, view: view, identifier: identifier, animationDisabled: animationDisabled)
    }
    
    func captureCurrentFrame() {
        capturedFrame = view?.frame ?? .zero
    }
    
    func animation() {
        guard superview != nil && capturedFrame != .zero && !(animationDisabled && isNewlyAdded) else { return }
        guard let newFrame = view?.frame else { return }
        view?.frame = capturedFrame
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: { [weak view] in
            view?.frame = newFrame
        }, completion: nil)
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
