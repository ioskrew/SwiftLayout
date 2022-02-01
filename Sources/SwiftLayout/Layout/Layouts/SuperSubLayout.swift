//
//  SuperSubLayout.swift
//  
//
//  Created by oozoofrog on 2022/01/31.
//

import Foundation
import UIKit

public struct SuperSubLayout<Superview, Sub>: LayoutAttachable, LayoutContainable, UIViewContainable where Superview: UIView, Sub: LayoutAttachable {
    
    internal init(superview: Superview, subLayout: Sub) {
        self.view = superview
        self.subLayout = subLayout
    }
    
    public let view: Superview
    let subLayout: Sub
    
    public var layouts: [LayoutAttachable] { [subLayout] }

}

extension SuperSubLayout: CustomDebugStringConvertible {
    public var debugDescription: String {
        "SuperSubLayout<\(view.tagDescription), \(subLayout.tagDescription)>"
    }
}
