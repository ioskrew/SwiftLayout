import Foundation
import UIKit

extension ConfigurableProperties {
    
    func registUILabel() {
        regist(
            UILabel.self,
            defaultReferenceView: UILabel(),
            propertiesHandler: uiLabelDefaultConfigurableProperties
        )
    }
    
    private func uiLabelDefaultConfigurableProperties(defaultReferenceView label: UILabel) -> [ConfigurableProperty] {
        return [
            .property(keypath: \.adjustsFontForContentSizeCategory, defaultReferenceView: label) { "$0.adjustsFontForContentSizeCategory = \($0)" },
            .property(keypath: \.adjustsFontSizeToFitWidth, defaultReferenceView: label) { "$0.adjustsFontSizeToFitWidth = \($0)" },
            .property(keypath: \.allowsDefaultTighteningForTruncation, defaultReferenceView: label) { "$0.allowsDefaultTighteningForTruncation = \($0)" },
            .property(keypath: \.baselineAdjustment, defaultReferenceView: label) { "$0.baselineAdjustment = \($0.configuration)" },
            .property(keypath: \.font, defaultReferenceView: label) { "$0.font = \($0.configuration)" },
            .property(keypath: \.highlightedTextColor, defaultReferenceView: label) { "$0.highlightedTextColor = \($0.configuration)" },
            .property(keypath: \.isEnabled, defaultReferenceView: label) { "$0.isEnabled = \($0)" },
            .property(keypath: \.isHighlighted, defaultReferenceView: label) { "$0.isHighlighted = \($0)" },
            .property(keypath: \.lineBreakMode, defaultReferenceView: label) { "$0.lineBreakMode = \($0.configuration)" },
            .property(keypath: \.minimumScaleFactor, defaultReferenceView: label) { "$0.minimumScaleFactor = \($0)" },
            .property(keypath: \.numberOfLines, defaultReferenceView: label) { "$0.numberOfLines = \($0)" },
            .property(keypath: \.shadowColor, defaultReferenceView: label) { "$0.shadowColor = \($0.configuration)" },
            .property(keypath: \.shadowOffset, defaultReferenceView: label) { "$0.shadowOffset = CGSize(width: \($0.width), height: \($0.height))" },
            .property(keypath: \.text, defaultReferenceView: label) { "$0.text = \($0.configuration)"},
            .property(keypath: \.textAlignment, defaultReferenceView: label) { "$0.textAlignment = \($0.configuration)" },
            .property(keypath: \.textColor, defaultReferenceView: label) { "$0.textColor = \($0.configuration)" },
        ]
    }
}
