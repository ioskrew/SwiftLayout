//
//  UISemanticContentAttribute+ConfigurationName.swift
//  
//
//  Created by aiden_h on 2022/07/08.
//

import UIKit

extension UISemanticContentAttribute {
    var configurationName: String {
        switch self {
        case .unspecified: return ".unspecified"
        case .playback: return ".playback"
        case .spatial: return ".spatial"
        case .forceLeftToRight: return ".forceLeftToRight"
        case .forceRightToLeft: return ".forceRightToLeft"
        @unknown default: return ".unknown"
        }
    }
}
