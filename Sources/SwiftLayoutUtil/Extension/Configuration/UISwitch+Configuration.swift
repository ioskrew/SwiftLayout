import UIKit

@available(iOS 14.0, *)
extension UISwitch.Style {
    var configuration: String {
        switch self {
        case .automatic: return ".automatic"
        case .checkbox: return ".checkbox"
        case .sliding: return ".sliding"
        @unknown default: return ".unknown"
        }
    }
}
