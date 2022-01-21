//
//  File.swift
//  
//
//  Created by oozoofrog on 2022/01/18.
//

import Foundation
import UIKit

public extension UIView {
    
    @discardableResult
    func callAsFunction(@ViewNodeBuilder _ content: () -> ViewNodable) -> ViewNode {
        _ViewNode(parent: .view(self), child: .child(content().node))
    }

    @discardableResult
    func layout(@ViewNodeBuilder _ content: () -> ViewNode) -> ViewNode {
        _ViewNode(parent: .root(self), child: .child(content().node))
    }
    
}
