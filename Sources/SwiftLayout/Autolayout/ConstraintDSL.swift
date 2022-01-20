
import Foundation
import UIKit

public protocol ConstraintDSLContent {
    var constraints: [NSLayoutConstraint] { get }
}

struct _ConstraintDSLContent: ConstraintDSLContent {
    
    internal init(constraints: [NSLayoutConstraint]) {
        self.constraints = constraints
    }
    
    internal init(contents: [ConstraintDSLContent]) {
        self.constraints = contents.flatMap(\.constraints)
    }
    
    let constraints: [NSLayoutConstraint]
}

@resultBuilder
public struct ConstraintBuilder {
    public static func buildBlock(_ components: ConstraintDSLContent...) -> Constraints {
        ConstraintsContainer(constraints: components.flatMap(\.constraints))
    }
    
    public static func buildArray(_ components: [ConstraintDSLContent]) -> Constraints {
        ConstraintsContainer(constraints: components.flatMap(\.constraints))
    }
    
    public static func buildEither(first component: ConstraintDSLContent) -> Constraints {
        ConstraintsContainer(constraints: component.constraints)
    }
    
    public static func buildEither(second component: ConstraintDSLContent) -> Constraints {
        ConstraintsContainer(constraints: component.constraints)
    }
    
}

public protocol Constraints: ConstraintDSLContent {
    var constraints: [NSLayoutConstraint] { get }
}

struct ConstraintsContainer: Constraints {
    let constraints: [NSLayoutConstraint]
}
