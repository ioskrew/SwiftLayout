import Foundation
import UIKit

extension ConfigurableProperties {
    
    func registUIView() {
        regist(
            UIView.self,
            defaultReferenceView: UIView(),
            propertiesHandler: uiViewDefaultConfigurableProperties
        )
    }
    
    private func uiViewDefaultConfigurableProperties(defaultReferenceView view: UIView) -> [ConfigurableProperty] {
        let viewProperties: [ConfigurableProperty] = [
            .property(keypath: \.alpha, defaultReferenceView: view) { "$0.alpha = \($0)" },
            .property(keypath: \.autoresizesSubviews, defaultReferenceView: view) { "$0.autoresizesSubviews = \($0)" },
            .property(keypath: \.backgroundColor, defaultReferenceView: view) { "$0.backgroundColor = \($0.configuration)" },
            .property(keypath: \.clearsContextBeforeDrawing, defaultReferenceView: view) { "$0.clearsContextBeforeDrawing = \($0)" },
            .property(keypath: \.clipsToBounds, defaultReferenceView: view) { "$0.clipsToBounds = \($0)" },
            .property(keypath: \.contentMode, defaultReferenceView: view) { "$0.contentMode = \($0.configuration)"},
            .property(keypath: \.isHidden, defaultReferenceView: view) { "$0.isHidden = \($0)" },
            .property(keypath: \.isMultipleTouchEnabled, defaultReferenceView: view) { "$0.isMultipleTouchEnabled = \($0)"},
            .property(keypath: \.isOpaque, defaultReferenceView: view) { "$0.isOpaque = \($0)" },
            .property(keypath: \.isUserInteractionEnabled, defaultReferenceView: view) { "$0.isUserInteractionEnabled = \($0)"},
            .property(keypath: \.semanticContentAttribute, defaultReferenceView: view) { "$0.semanticContentAttribute = \($0.configuration)"},
            .property(keypath: \.tag, defaultReferenceView: view) { "$0.tag = \($0)" },
            .property(keypath: \.tintColor, defaultReferenceView: view) { "$0.tintColor = \($0.configuration)" },
        ]

        let accessibilityProperties: [ConfigurableProperty] = [
            .property(keypath: \.accessibilityHint, defaultReferenceView: view) { "$0.accessibilityHint = \($0.configuration)"},
            .property(keypath: \.accessibilityIdentifier, defaultReferenceView: view) { "$0.accessibilityIdentifier = \($0.configuration)"},
            .property(keypath: \.accessibilityLabel, defaultReferenceView: view) { "$0.accessibilityLabel = \($0.configuration)"},
            .property(keypath: \.accessibilityTraits, defaultReferenceView: view) { "$0.accessibilityTraits = \($0.configuration)"},
            .property(keypath: \.isAccessibilityElement, defaultReferenceView: view) { "$0.isAccessibilityElement = \($0)"},
        ]

        return viewProperties + accessibilityProperties
    }
}
