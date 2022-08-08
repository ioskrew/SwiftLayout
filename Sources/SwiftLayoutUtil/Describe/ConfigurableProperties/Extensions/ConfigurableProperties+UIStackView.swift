import Foundation
import UIKit

extension ConfigurableProperties {
    
    func registUIStackView() {
        regist(
            UIStackView.self,
            defaultReferenceView: UIStackView(),
            propertiesHandler: uiStackViewDefaultConfigurableProperties
        )
    }
    
    private func uiStackViewDefaultConfigurableProperties(defaultReferenceView stackView: UIStackView) -> [ConfigurableProperty] {
        return [
            .property(keypath: \.alignment, defaultReferenceView: stackView) { "$0.alignment = \($0.configuration)"},
            .property(keypath: \.axis, defaultReferenceView: stackView) { "$0.axis = \($0.configuration)"},
            .property(keypath: \.distribution, defaultReferenceView: stackView) { "$0.distribution = \($0.configuration)"},
            .property(keypath: \.isBaselineRelativeArrangement, defaultReferenceView: stackView) { "$0.isBaselineRelativeArrangement = \($0)"},
            .property(keypath: \.spacing, defaultReferenceView: stackView) { "$0.spacing = \($0)"},
        ]
    }
    
}
