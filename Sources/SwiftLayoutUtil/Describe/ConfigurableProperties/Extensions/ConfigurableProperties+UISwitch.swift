import Foundation
import UIKit

extension ConfigurableProperties {
    
    func registUISwitch() {
        regist(
            UISwitch.self,
            defaultReferenceView: UISwitch(),
            propertiesHandler: uiSwitchDefaultConfigurableProperties
        )
    }
    
    private func uiSwitchDefaultConfigurableProperties(defaultReferenceView uiSwitch: UISwitch) -> [ConfigurableProperty] {
        var configurableProperties: [ConfigurableProperty] = [
            .property(keypath: \.isOn, defaultReferenceView: uiSwitch, describer: { "$0.isOn = \($0)" })
        ]
        
        if #available(iOS 14.0, *) {
            configurableProperties.append(.property(keypath: \.preferredStyle, defaultReferenceView: uiSwitch, describer: { "$0.preferredStyle = \($0.configuration)" } ))
        }

        return configurableProperties
    }
}
