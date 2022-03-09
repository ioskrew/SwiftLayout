import Foundation
import UIKit

public struct ViewLayout<V: UIView, SubLayout: Layout>: Layout {
    
    let innerView: V
    var sublayout: SubLayout
    var coordinators: [Coordinator]
    
    init(_ view: V, sublayout: SubLayout) {
        self.innerView = view
        self.sublayout = sublayout
        self.coordinators = []
    }
    
    public var view: UIView? {
        self.innerView
    }
    
    public var sublayouts: [Layout] {
        [sublayout] + coordinators.compactMap(\.sublayout)
    }
    
    public var anchors: Anchors? {
        coordinators.compactMap(\.anchors).reduce(Anchors(), +)
    }

    public var debugDescription: String {
        innerView.tagDescription + ": [\(sublayout.debugDescription)]"
    }
}

extension ViewLayout {
    
    public func anchors(@AnchorsBuilder _ build: () -> Anchors) -> Self {
        var viewLayout = self
        viewLayout.coordinators.append(.anchors(build()))
        return viewLayout
    }
    
    public func sublayout<L: Layout>(@LayoutBuilder _ build: () -> L) -> Self {
        var viewLayout = self
        viewLayout.coordinators.append(.sublayout(build()))
        return viewLayout
    }
    
    public func identifying(_ accessibilityIdentifier: String) -> Self {
        innerView.accessibilityIdentifier = accessibilityIdentifier
        return self
    }
}

extension ViewLayout {
    
    enum Coordinator {
        case sublayout(_ layout: Layout)
        case anchors(_ anchors: Anchors)
        
        var sublayout: Layout? {
            switch self {
            case .sublayout(let layout):
                return layout
            default:
                return nil
            }
        }
        
        var anchors: Anchors? {
            switch self {
            case .anchors(let anchors):
                return anchors
            default:
                return nil
            }
        }
    }
}
