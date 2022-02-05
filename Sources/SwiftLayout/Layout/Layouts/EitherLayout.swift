//
//  ConditionalLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/01.
//

import Foundation
import UIKit

public final class EitherLayout<First, Second>: LayoutAttachable, LayoutContainable where First: LayoutAttachable, Second: LayoutAttachable {
    
    internal init(layout: LayoutAttachable, constraints: Set<NSLayoutConstraint> = []) {
        self.layout = layout
        self.constraints = constraints
    }
    
    var layout: LayoutAttachable
    
    public var layouts: [LayoutAttachable] { [layout] }
    public var constraints: Set<NSLayoutConstraint> = []
    
    public func setConstraint(_ constraints: [NSLayoutConstraint]) {
        self.constraints = []
    }
    
}
