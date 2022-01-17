
import Foundation
import UIKit

extension ViewDSLBuilder {
    struct Components: ViewBuilding {
        let containers: [ViewDSL]
        init(_ containers: [ViewDSL]) {
            self.containers = containers
        }
        
        init(_ views: [UIView]) {
            self.init(views.map(ViewContainer.init))
        }
    }
}
