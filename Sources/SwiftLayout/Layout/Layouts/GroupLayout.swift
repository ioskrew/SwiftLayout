//
//  GroupLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/01.
//

import Foundation
import UIKit

public final class GroupLayout<SomeLayout>: LayoutAttachable, LayoutContainable where SomeLayout: LayoutAttachable {
    
    public let layouts: [LayoutAttachable]
    public var constraints: Set<NSLayoutConstraint> = []
    
    public init(@LayoutBuilder _ layout: () -> SomeLayout) {
        layouts = [layout()]
    }
    
    public func setConstraint(_ constraints: [NSLayoutConstraint]) {
        self.constraints = Set(constraints)
    }
}
