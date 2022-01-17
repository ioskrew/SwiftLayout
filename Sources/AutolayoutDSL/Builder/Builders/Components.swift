
import Foundation
import UIKit

extension Builder {
    public struct Components: Constraint {
        let components: [Constraint]
        
        public init(_ components: [Constraint]) {
            self.components = components
        }
    }
}
