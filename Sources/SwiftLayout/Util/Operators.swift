//
//  Operators.swift
//  
//
//  Created by maylee on 2022/01/30.
//

import Foundation

postfix operator +

postfix func +<S: StringProtocol>(lhs: S) -> (_ rhs: S) -> String {
    { rhs in
        lhs.appending(rhs)
    }
}

func typeString<T>(of value: T) -> String {
    String(describing: type(of: value))
}
