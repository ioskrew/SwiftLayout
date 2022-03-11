
import Foundation
import SwiftLayout
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

class TutorialView: UIView {
    let nameLabel = UILabel()
    
    func initViews() {
        self {
            nameLabel
        }.finalActive()
    }
    
}
