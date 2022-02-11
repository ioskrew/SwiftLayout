//
//  File.swift
//  
//
//  Created by aiden_h on 2022/02/10.
//

import Foundation

public protocol Deactivable {
    var layout: Layout { get }
    func deactive()
}

extension Deactivable {
    public func isNew(_ layout: Layout) -> Bool {
        return self.layout.hashable != layout.hashable
    }
}
