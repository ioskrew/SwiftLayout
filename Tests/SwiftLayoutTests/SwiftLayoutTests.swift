import XCTest
import UIKit
@testable import SwiftLayout

final class SwiftLayoutTests: XCTestCase {
    
    var superview: UIView = UIView().viewTag.superview
    
    var root: UIView = UIView().viewTag.root
    var button: UIButton = UIButton().viewTag.button
    var label: UILabel = UILabel().viewTag.label
    var redView: UIView = {
        let view = UIView().viewTag.redView
        view.backgroundColor = .red
        return view
    }()
    var image: UIImageView = UIImageView().viewTag.image
    
    var deactivable: AnyDeactivatable?
    
    override func setUp() {
        root.removeFromSuperview()
        button.removeFromSuperview()
        label.removeFromSuperview()
        redView.removeFromSuperview()
        image.removeFromSuperview()
    }
}

@dynamicMemberLookup
struct Tag<Taggable> where Taggable: UIAccessibilityIdentification {
    let taggable: Taggable
    
    subscript(dynamicMember tag: String) -> Taggable {
        taggable.accessibilityIdentifier = tag
        return taggable
    }
}

extension UIAccessibilityIdentification {
    var viewTag: Tag<Self> {
        Tag(taggable: self)
    }
}
