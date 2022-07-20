//
//  Optional+Configuration.swift
//  
//
//  Created by aiden_h on 2022/07/15.
//

import Foundation
import UIKit

extension Optional where Wrapped == String {
    var configuration: String {
        return self.map { "\"\($0)\"" } ?? "nil"
    }
}

extension Optional where Wrapped == UIImage {
    var configuration: String {
        guard self != nil else {
            return "nil"
        }

        return "// Modified! Check it manually."
    }
}

extension Optional where Wrapped == UIFont {
    var configuration: String {
        guard let self = self else {
            return "nil"
        }

        return "// Modified! Check it manually. (fontName: \(self.fontName), pointSize: \(self.pointSize))"
    }
}


extension Optional where Wrapped == UIColor {
    var configuration: String {
        guard let self = self else {
            return "nil"
        }

        var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)

        let hexCode = String(format: "%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))

        return "// Modified! Check it manually. (hex: #\(hexCode), alpha: \(a))"
    }
}
