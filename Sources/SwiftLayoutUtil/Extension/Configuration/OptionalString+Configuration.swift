//
//  OptionalString+Configuration.swift
//  
//
//  Created by aiden_h on 2022/07/15.
//

import Foundation

extension Optional where Wrapped == String {
    var configuration: String {
        return self.map { "\"\($0)\"" } ?? "nil"
    }
}
