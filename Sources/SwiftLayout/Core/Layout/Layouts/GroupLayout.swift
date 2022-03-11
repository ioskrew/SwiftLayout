//
//  GroupLayout.swift
//  
//
//  Created by oozoofrog on 2022/03/01.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public struct GroupLayout<L: Layout>: Layout {
    
    let layout: L
    
    public init(@LayoutBuilder _ handler: () -> L) {
        self.layout = handler()
    }
    
    public var debugDescription: String {
        "GroupLayout"
    }
    
    public var sublayouts: [Layout] {
        [layout]
    }
}
