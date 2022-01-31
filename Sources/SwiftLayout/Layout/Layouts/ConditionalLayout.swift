//
//  ConditionalLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/01.
//

import Foundation

struct ConditionalLayout<TrueLayout, FalseLayout>: LayoutConditional where TrueLayout: LayoutAttachable, FalseLayout: LayoutAttachable {
    
    var layout: LayoutAttachable
    
    var layouts: [LayoutAttachable] { [layout] }
    
}
