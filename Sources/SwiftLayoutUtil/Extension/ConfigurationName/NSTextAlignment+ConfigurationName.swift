//
//  NSTextAlignment+ConfigurationName.swift
//  
//
//  Created by aiden_h on 2022/07/08.
//

import UIKit

extension NSTextAlignment {
    var configurationName: String {
        switch self {
        case .left: return "left"
        case .center: return "center"
        case .right: return "right"
        case .justified: return "justified"
        case .natural: return "natural"
        @unknown default: return "unknown"
        }
    }
}
