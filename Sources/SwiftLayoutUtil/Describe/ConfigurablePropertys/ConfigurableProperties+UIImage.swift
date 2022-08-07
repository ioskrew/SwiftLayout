import Foundation
import UIKit

extension ConfigurableProperties {
    
    func registUIImage() {
        regist(UIImageView.self, propertiesHandler: uiImageViewDefaultConfigurablePropertys)
    }
    
    private func uiImageViewDefaultConfigurablePropertys(defaultReferenceView imageView: UIImageView) -> [ConfigurableProperty] {
        return [
            .property(keypath: \.adjustsImageSizeForAccessibilityContentSizeCategory, defaultReferenceView: imageView) { "$0.adjustsImageSizeForAccessibilityContentSizeCategory = \($0)" },
            .property(keypath: \.highlightedImage, defaultReferenceView: imageView) { "$0.highlightedImage = \($0.configuration)"},
            .property(keypath: \.image, defaultReferenceView: imageView) { "$0.image = \($0.configuration)"},
            .property(keypath: \.isHighlighted, defaultReferenceView: imageView) { "$0.isHighlighted = \($0)" },
        ]
    }
    
}
