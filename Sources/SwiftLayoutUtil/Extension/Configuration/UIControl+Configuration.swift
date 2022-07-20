//
//  UIControl+Configuration.swift
//  
//
//  Created by aiden_h on 2022/07/14.
//

import UIKit

extension UIControl.ContentHorizontalAlignment {
    var configuration: String {
        switch self {
        case .center: return ".center"
        case .left: return ".left"
        case .right: return ".right"
        case .fill: return ".fill"
        case .leading: return ".leading"
        case .trailing: return ".trailing"
        @unknown default: return ".unknown"
        }
    }
}


extension UIControl.ContentVerticalAlignment {
    var configuration: String {
        switch self {
        case .center: return ".center"
        case .top: return ".top"
        case .bottom: return ".bottom"
        case .fill: return ".fill"
        @unknown default: return ".unknown"
        }
    }
}
