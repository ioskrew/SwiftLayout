//
//  UIControl.ContentVerticalAlignment+ConfigurationName.swift
//  
//
//  Created by aiden_h on 2022/07/14.
//

import UIKit

extension UIControl.ContentVerticalAlignment {
    var configurationName: String {
        switch self {
        case .center: return "center"
        case .top: return "top"
        case .bottom: return "bottom"
        case .fill: return "fill"
        @unknown default: return "unknown"
        }
    }
}
