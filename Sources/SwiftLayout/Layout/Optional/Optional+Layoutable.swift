//
//  Optional+Layoutable.swift
//  
//
//  Created by oozoofrog on 2022/01/29.
//

import Foundation

extension Optional: Layoutable where Wrapped: Layoutable {
    public func moveToSuperlayoutable(_ layoutable: Layoutable) -> Layoutable {
        switch self {
        case .none:
            return layoutable
        case .some(let wrapped):
            return wrapped.moveToSuperlayoutable(layoutable)
        }
    }
}
