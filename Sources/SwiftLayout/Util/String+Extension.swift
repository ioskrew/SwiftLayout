//
//  String+Extension.swift
//  
//
//  Created by maylee on 2022/01/30.
//

import Foundation

extension String {
    func repeated(_ count: Int) -> String {
        Array(repeating: self, count: count).joined()
    }
}
