//
//  Equator.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import Foundation

protocol NoHashableImpl {
    func combineToHasher(_ hasher: inout Hasher)
}

protocol NoHashableEquatable: NoHashableImpl {
    var equator: Equator<Self> { get }
}

extension NoHashableEquatable {
    var equator: Equator<Self> {
        Equator(from: self)
    }
}

struct Equator<NoHashable: NoHashableImpl>: Hashable {
    static func == (lhs: Equator<NoHashable>, rhs: Equator<NoHashable>) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
 
    let from: NoHashable
    
    func hash(into hasher: inout Hasher) {
        from.combineToHasher(&hasher)
    }
    
}

extension Equator: CustomDebugStringConvertible where NoHashable: CustomDebugStringConvertible {
    var debugDescription: String { from.debugDescription }
}
