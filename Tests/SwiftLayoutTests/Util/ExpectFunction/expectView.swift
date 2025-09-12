//
//  expeactView.swift
//

import Foundation
import Testing
import UIKit

@MainActor
func expectView(
    _ view: @autoclosure () throws -> UIView,
    superview: @autoclosure () throws -> UIView?,
    subviews: @autoclosure () throws -> [UIView]?,
    _ sourceLocation: Testing.SourceLocation = #_sourceLocation
) rethrows {
    let view = try view()
    let superview = try superview()
    let subviews = try subviews() ?? []
    if view.superview != superview {
        if let superviewForView = view.superview, let superview = superview {
            Issue.record(
                Comment(rawValue: "view<\(view.testDescription)>.superview(\(superviewForView.testDescription)) is not equal with superview<\(superview.testDescription)>"),
                sourceLocation: sourceLocation
            )
            return
        } else if let superviewForView = view.superview {
            Issue.record(
                Comment(rawValue: "view<\(view.testDescription)>.superview<\(superviewForView.testDescription)> is not equal with superview<nil>"),
                sourceLocation: sourceLocation
            )
            return
        } else if let superview = superview {
            Issue.record(
                Comment(rawValue: "view<\(view.testDescription)>.superview<nil> is not equal with superview<\(superview.testDescription)>"),
                sourceLocation: sourceLocation
            )
            return
        }
    }
    let subviewsInView = view.subviews.map(\.testDescription)
    let subviewsForTest = subviews.map(\.testDescription)
    if !subviewsInView.elementsEqual(subviewsForTest) {
        Issue.record(
            Comment(rawValue: "view<\(view.testDescription)>.subviews(\(subviewsInView.count))[\(subviewsInView.joined(separator: ", "))] is not equal with subviews(\(subviewsForTest.count))[\(subviewsForTest.joined(separator: ", "))]"),
            sourceLocation: sourceLocation
        )
    }
}

@MainActor
func expectLayoutGuides(
    _ view: @autoclosure () throws -> UIView,
    layoutGuides: @autoclosure () throws -> [UILayoutGuide]?,
    _ sourceLocation: Testing.SourceLocation = #_sourceLocation
) rethrows {
    let view = try view()
    let guides = try layoutGuides() ?? []
    let guidesInView = view.layoutGuides.map(\.testDescription)
    let guidesForTest = guides.map(\.testDescription)
    if !guidesInView.elementsEqual(guidesForTest) {
        Issue.record(
            Comment(rawValue: "view<\(view.testDescription)>.layoutGuides(\(guidesInView.count))[\(guidesInView.joined(separator: ", "))] is not equal with layoutGuides(\(guidesForTest.count))[\(guidesForTest.joined(separator: ", "))]"),
            sourceLocation: sourceLocation
        )
    }
}

@MainActor
func expectOwnerView(
    _ guide: @autoclosure () throws -> UILayoutGuide,
    ownerView: @autoclosure () throws -> UIView?,
    _ sourceLocation: Testing.SourceLocation = #_sourceLocation
) rethrows {
    let guide = try guide()
    let owner = try ownerView()
    if guide.owningView !== owner {
        if let owning = guide.owningView, let owner = owner {
            Issue.record(
                Comment(
                    rawValue: "layoutGuide<\(guide.testDescription)>.owningView(\(owning.testDescription)) is not equal with ownerView<\(owner.testDescription)>"
                ),
                sourceLocation: sourceLocation
            )
        } else if let owning = guide.owningView {
            Issue.record(
                Comment(
                    rawValue: "layoutGuide<\(guide.testDescription)>.owningView<\(owning.testDescription)> is not equal with ownerView<nil>"
                ),
                sourceLocation: sourceLocation
            )
        } else if let owner = owner {
            Issue.record(
                Comment(
                    rawValue: "layoutGuide<\(guide.testDescription)>.owningView<nil> is not equal with ownerView<\(owner.testDescription)>"
                ),
                sourceLocation: sourceLocation
            )
        }
    }
}

private extension UIAccessibilityIdentification {
    @MainActor
    var testDescription: String {
        if let identifier = accessibilityIdentifier {
            return "\(type(of: self)): \(identifier)"
        } else {
            return "\(type(of: self)): \(Unmanaged.passUnretained(self).toOpaque())"
        }
    }
}

private extension UILayoutGuide {
    var testDescription: String {
        return "\(type(of: self)): \(identifier)"
    }
}
