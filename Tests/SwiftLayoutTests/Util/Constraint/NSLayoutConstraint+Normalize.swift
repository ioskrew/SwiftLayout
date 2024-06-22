//
//  File.swift
//  
//
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    var normalizedDescription: String {
        self.debugDescription
            .replacingOccurrences(
                of: "NSLayoutConstraint:0x[0-9a-f]+",
                with: "NSLayoutConstraint",
                options: .regularExpression
            )
            .replacingOccurrences(
                of: "(inactive|active)",
                with: "",
                options: .regularExpression
            )
    }
}
