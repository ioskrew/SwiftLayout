//
//  NSLineBreakMode+Configuration.swift
//  
//
//  Created by aiden_h on 2022/07/08.
//

import UIKit

extension NSLineBreakMode {
    var configuration: String {
        switch self {
        case .byWordWrapping: return ".byWordWrapping"
        case .byCharWrapping: return ".byCharWrapping"
        case .byClipping: return ".byClipping"
        case .byTruncatingHead: return ".byTruncatingHead"
        case .byTruncatingTail: return ".byTruncatingTail"
        case .byTruncatingMiddle: return ".byTruncatingMiddle"
        @unknown default: return ".unknown"
        }
    }
}
