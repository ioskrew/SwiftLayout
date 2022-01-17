
import Foundation
import UIKit

extension Builder {
    public struct Either<First: Constraint, Second: Constraint>: Constraint {
        
        let content: Constraint
        
    }
}
