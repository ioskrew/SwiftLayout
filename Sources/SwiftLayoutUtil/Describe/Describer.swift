//
//  Describer.swift
//  
//
//  Created by oozoofrog on 2022/03/28.
//

import Foundation

struct Describer: CustomStringConvertible {
    
    init(_ viewToken: ViewToken, _ constraintTokens: [AnchorToken]) {
        self.viewToken = viewToken
        self.constraintTokens = constraintTokens
    }
    
    var description: String {
        describing.descriptions().joined(separator: "\n")
    }
    
    private let viewToken: ViewToken
    private let constraintTokens: [AnchorToken]
    
    private var describing: ViewDescriber {
        describingFromToken(viewToken)
    }
    
    private func describingFromToken(_ viewToken: ViewToken) -> ViewDescriber {
        ViewDescriber(viewToken: viewToken,
                      constraintTokens: constraintTokensForViewToken(viewToken),
                      subdescribes: viewToken.subviews.map(describingFromToken))
    }
    
    private func constraintTokensForViewToken(_ viewToken: ViewToken) -> [AnchorToken] {
        constraintTokens.filter({ $0.firstTag == viewToken.viewTag })
    }
    
}
