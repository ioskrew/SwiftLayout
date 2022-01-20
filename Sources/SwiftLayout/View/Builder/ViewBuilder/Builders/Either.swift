
import Foundation
import UIKit

extension ViewDSLBuilder {
    struct Either: ViewBuilding {
        let containers: [ViewDSL]
        
        init(_ container: ViewDSL) {
            self.containers = [container]
        }
        
        init(_ view: UIView) {
            self.init(ViewContainer(view))
        }
    }
}
