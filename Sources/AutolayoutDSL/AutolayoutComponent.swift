
import Foundation
import UIKit

public protocol AutolayoutComponent {
    func constraints() -> [NSLayoutConstraint]
    func active()

    func views() -> [UIView]
    func prepare()
}

extension AutolayoutComponent {
    
    public func constraints() -> [NSLayoutConstraint] { [] }
    
    public func active() {
        NSLayoutConstraint.activate(constraints())
    }
    
    public func views() -> [UIView] {
        []
    }
    
    public func prepare() {
        views().forEach({ $0.translatesAutoresizingMaskIntoConstraints = false })
    }
    
}

extension AutolayoutComponent {
    
    func addViews(_ component: AutolayoutComponent) {
        let parent = views().first
        for child in component.views() {
            parent?.addSubview(child)
        }
    }
    
    func bindLeadingToTrailing(_ trailingComponent: AutolayoutComponent) -> [NSLayoutConstraint] {
        guard let leading = views().first?.leadingAnchor else { return [] }
        guard let trailing = trailingComponent.views().last?.trailingAnchor else { return [] }
        
        return [leading.constraint(equalTo: trailing)]
    }
    
    func bindLeadingToLeading(_ leadingComponent: AutolayoutComponent) -> [NSLayoutConstraint] {
        guard let leading1 = views().first?.leadingAnchor else { return [] }
        guard let leading2 = leadingComponent.views().first?.leadingAnchor else { return [] }
        
        return [leading1.constraint(equalTo: leading2)]
    }
    
    func bindTrailingToLeading(_ leadingComponent: AutolayoutComponent) -> [NSLayoutConstraint] {
        leadingComponent.bindLeadingToTrailing(self)
    }
    
    func bindTrailingToTrailing(_ leadingComponent: AutolayoutComponent) -> [NSLayoutConstraint] {
        guard let trailing1 = views().last?.trailingAnchor else { return [] }
        guard let trailing2 = leadingComponent.views().last?.trailingAnchor else { return [] }
        
        return [trailing1.constraint(equalTo: trailing2)]
    }
    
    func bindTopToBottom(_ bottomComponent: AutolayoutComponent) -> [NSLayoutConstraint] {
        guard let top = views().first?.topAnchor else { return [] }
        guard let bottom = bottomComponent.views().last?.bottomAnchor else { return [] }
        
        return [top.constraint(equalTo: bottom)]
    }
    
    func bindTopToTop(_ topComponent: AutolayoutComponent) -> [NSLayoutConstraint] {
        guard let top1 = views().first?.topAnchor else { return [] }
        guard let top2 = topComponent.views().first?.topAnchor else { return [] }
        
        return [top1.constraint(equalTo: top2)]
    }
    
    func bindBottomToTop(_ topComponent: AutolayoutComponent) -> [NSLayoutConstraint] {
        topComponent.bindTopToBottom(self)
    }

    func bindBottomToBottom(_ bottomComponent: AutolayoutComponent) -> [NSLayoutConstraint] {
        guard let bottom1 = views().last?.bottomAnchor else { return [] }
        guard let bottom2 = bottomComponent.views().last?.bottomAnchor else { return [] }
        
        return [bottom1.constraint(equalTo: bottom2)]
    }
}
