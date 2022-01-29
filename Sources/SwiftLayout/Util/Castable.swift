//
//  Castable.swift
//  
//
//  Created by maylee on 2022/01/29.
//

import Foundation

func cast<T>(_ to: T.Type) -> (Any) -> T? {
    { target in
        target as? T
    }
}
