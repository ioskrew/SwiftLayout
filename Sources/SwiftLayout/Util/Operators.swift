//
//  Operators.swift
//  
//
//  Created by oozoofrog on 2022/01/30.
//

import Foundation

postfix operator +
prefix operator ==

postfix func +<S: StringProtocol>(lhs: S) -> (_ rhs: S) -> String {
    { rhs in
        lhs.appending(rhs)
    }
}

prefix func ==(rhs: Layout) -> (_ lhs: Layout) -> Bool {
    { lhs in
        lhs.hashable == rhs.hashable
    }
}

func typeString<T>(of value: T) -> String {
    String(describing: type(of: value))
}
