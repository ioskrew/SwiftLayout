//
//  ConstraintTests.swift
//  
//
//  Created by oozoofrog on 2022/02/04.
//

import XCTest
@testable import SwiftLayout

class ConstraintTests: XCTestCase {
    
    var deactivatable: AnyDeactivatable = .init()
    
    var root = UIView().viewTag.root
    var child = UIView().viewTag.child
    var red = UIView().viewTag.red
    var blue = UIView().viewTag.blue
    var green = UIView().viewTag.green
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        root = UIView().viewTag.root
        child = UIView().viewTag.child
        red = UIView().viewTag.red
        blue = UIView().viewTag.blue
        green = UIView().viewTag.green
    }
    
    override func tearDownWithError() throws {
        deactivatable.deactive()
    }
    
    func testAnchorConstraint() {
        let root = UIView()
        let child = UIView()
        root.addSubview(child)
        child.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = Anchor(child).top.leading.trailing.bottom.constraints(item: child, toItem: root)
        
        NSLayoutConstraint.activate(constraints)
        
        root.frame = CGRect(origin: .zero, size: .init(width: 200, height: 200))
        root.layoutIfNeeded()
        XCTAssertEqual(child.frame.size, .init(width: 200, height: 200))
        root.removeConstraints(constraints)
        
        constraints = Anchor.top.leading.bottom.width.constant(98).toNone.constraints(item: child, toItem: root)
        NSLayoutConstraint.activate(constraints)
        root.setNeedsLayout()
        root.layoutIfNeeded()
        XCTAssertEqual(child.frame.size, .init(width: 98, height: 200))
    }
    
    public struct Anchor: Constraint {
        
        internal init(_ item: AnyObject? = nil, items: [ConstraintTests.Anchor.Item] = []) {
            self.item = item
            self.items = items
        }
        
        let item: AnyObject?
        
        var items: [Item] = []
        
        @Attribute(.top)            public static var top: Anchor
        @Attribute(.bottom)         public static var bottom: Anchor
        @Attribute(.leading)        public static var leading: Anchor
        @Attribute(.trailing)       public static var trailing: Anchor
        @Attribute(.left)           public static var left: Anchor
        @Attribute(.right)          public static var right: Anchor
        @Attribute(.width)          public static var width: Anchor
        @Attribute(.height)         public static var height: Anchor
        @Attribute(.centerX)        public static var centerX: Anchor
        @Attribute(.centerY)        public static var centerY: Anchor
        @Attribute(.firstBaseline)  public static var firstBaseline: Anchor
        @Attribute(.lastBaseline)   public static var lastBaseline: Anchor
        
        public var top: Anchor              { self.appendAttribute(item, .top) }
        public var bottom: Anchor           { self.appendAttribute(item, .bottom) }
        public var leading: Anchor          { self.appendAttribute(item, .leading) }
        public var trailing: Anchor         { self.appendAttribute(item, .trailing) }
        public var left: Anchor             { self.appendAttribute(item, .left) }
        public var right: Anchor            { self.appendAttribute(item, .right) }
        public var width: Anchor            { self.appendAttribute(item, .width) }
        public var height: Anchor           { self.appendAttribute(item, .height) }
        public var centerX: Anchor          { self.appendAttribute(item, .centerX) }
        public var centerY: Anchor          { self.appendAttribute(item, .centerY) }
        public var firstBaseline: Anchor    { self.appendAttribute(item, .firstBaseline) }
        public var lastBaseline: Anchor     { self.appendAttribute(item, .lastBaseline) }
        
        public func appendAttribute(_ item: AnyObject? = nil, _ attribute: NSLayoutConstraint.Attribute) -> Self {
            var a = self
            a.items.append(.init(item: item, attribute: attribute))
            return a
        }
        
        public func constant(_ constant: CGFloat) -> Self {
            var a = self
            if var last = a.items.last {
                last.constant = constant
                a.items.removeLast()
                a.items.append(last)
            }
            return a
        }
        
        public enum To {
            case item(AnyObject)
            case constant(CGFloat)
            case itemConstant(AnyObject, CGFloat)
        }
        
        public func to(_ relation: NSLayoutConstraint.Relation, to: To, all: Bool = false) -> Self {
            var a = self
            
            func update(_ updateItem: Item) -> Item {
                var updateItem = updateItem
                updateItem.relation = relation
                switch to {
                case let .item(item):
                    updateItem.toItem = item
                case let .itemConstant(item, constant):
                    updateItem.toItem = item
                    updateItem.constant = constant
                case let .constant(constant):
                    updateItem.constant = constant
                    updateItem.toNeeds = false
                }
                return updateItem
            }
            
            if all {
                a.items = a.items.map(update)
            } else {
                if let last = a.items.last {
                    let updated = update(last)
                    a.items.removeLast()
                    a.items.append(updated)
                }
            }
            return a
        }
        
        public func equalTo(_ toItem: AnyObject) -> Self {
            to(.equal, to: .item(toItem))
        }
        
        public func greaterThanOrEqualTo(_ toItem: AnyObject) -> Self {
            to(.greaterThanOrEqual, to: .item(toItem))
        }
        
        public func lessThanOrEqualTo(_ toItem: AnyObject) -> Self {
            to(.lessThanOrEqual, to: .item(toItem))
        }
        
        public func equalToConstant(_ constant: CGFloat) -> Self {
            to(.equal, to: .constant(constant))
        }
        
        public func equalToAll(_ toItem: AnyObject) -> Self {
            to(.equal, to: .item(toItem), all: true)
        }
        
        public var toNone: Self {
            var a = self
            if var last = a.items.last {
                last.toNeeds = false
                a.items.removeLast()
                a.items.append(last)
            }
            return a
        }
        
        public func constraints(item fromItem: AnyObject, toItem: AnyObject?) -> [NSLayoutConstraint] {
            var constraints: [NSLayoutConstraint] = []
            for item in items {
                constraints.append(NSLayoutConstraint(item: item.item ?? fromItem,
                                                      attribute: item.attribute,
                                                      relatedBy: item.relation,
                                                      toItem: item.toItem(toItem),
                                                      attribute: item.toAttribute(item.attribute),
                                                      multiplier: item.multiplier,
                                                      constant: item.constant))
            }
            return constraints
        }
        
        @propertyWrapper
        public struct Attribute {
            public var wrappedValue: Anchor
            
            public init(_ attribute: NSLayoutConstraint.Attribute) {
                wrappedValue = Anchor(items: [.init(attribute: attribute)])
            }
        }
        
        struct Item {
            var item: AnyObject?
            var attribute: NSLayoutConstraint.Attribute
            var relation: NSLayoutConstraint.Relation = .equal
            var toNeeds: Bool = true
            var toItem: AnyObject?
            var toAttribute: NSLayoutConstraint.Attribute?
            
            var constant: CGFloat = 0.0
            var multiplier: CGFloat = 1.0
            
            func toItem(_ toItem: AnyObject?) -> AnyObject? {
                guard toNeeds else { return nil }
                return self.toItem ?? toItem
            }
            
            func toAttribute(_ attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint.Attribute {
                guard toNeeds else { return .notAnAttribute }
                return toAttribute ?? attribute
            }
        }
        
    }
    
    func testConstraintToLayout() {
        
        let layout: some Layout = root {
            child.constraint {
                ConstraintBuilder.Binding(firstAttribute: .top, firstItem: child, secondAttribute: .top, secondItem: root, relation: .equal)
                ConstraintBuilder.Binding(firstAttribute: .leading, firstItem: child, secondAttribute: .leading, secondItem: root, relation: .equal)
                ConstraintBuilder.Binding(firstAttribute: .trailing, firstItem: child, secondAttribute: .trailing, secondItem: root, relation: .equal)
                ConstraintBuilder.Binding(firstAttribute: .bottom, firstItem: child, secondAttribute: .bottom, secondItem: root, relation: .equal)
                
                ConstraintBuilder.Binding(firstAttribute: .centerY, firstItem: child, secondAttribute: .centerY, secondItem: root, relation: .equal)
                ConstraintBuilder.Binding(firstAttribute: .centerX, firstItem: child, secondAttribute: .centerX, secondItem: root, relation: .equal)
            }
        }
        
        deactivatable = layout.active()
        XCTAssertEqual(child.superview, root)
        XCTAssertEqual(root.constraints.count, 6)
        for attrib in [NSLayoutConstraint.Attribute.top, .leading, .trailing, .bottom, .centerX, .centerY] {
            XCTAssertNotNil(root.constraints.filter(child, firstAttribute: attrib, relation: .equal, toItem: root))
        }
        
        deactivatable.deactive()
        XCTAssertNil(child.superview)
        XCTAssertEqual(root.constraints.count, 0)
    }
    
    func testSyntaticSugarOfBindingForConstraint() {
        context("child의 ConstraintBuilder.Binding의") {
            context("first item이 없는 경우") {
                deactivatable = root {
                    child.constraint {
                        ConstraintBuilder.Binding(firstAttribute: .top, secondAttribute: .top, secondItem: root)
                    }
                }.active()
                context("first item은 child가 된다") {
                    XCTAssertEqual(child.superview, root)
                    XCTAssertEqual(root.constraints.count, 1)
                    XCTAssertNotNil(root.constraints.filter(child, firstAttribute: .top, toItem: root))
                }
                deactivatable = AnyDeactivatable()
                XCTAssertNil(child.superview)
                XCTAssertEqual(child.constraints.count, 0)
            }
            context("first item이 있고, second item이 없는 경우") {
                deactivatable = root {
                    child.constraint {
                        ConstraintBuilder.Binding(firstAttribute: .top, firstItem: child, secondAttribute: .top)
                    }
                }.active()
                context("second item은 root가 된다") {
                    XCTAssertEqual(child.superview, root)
                    XCTAssertEqual(root.constraints.count, 1)
                    XCTAssertNotNil(root.constraints.filter(child, firstAttribute: .top, toItem: root))
                }
                deactivatable = AnyDeactivatable()
            }
            context("first item과 second item이 없는 경우") {
                deactivatable = root {
                    child.constraint {
                        ConstraintBuilder.Binding(firstAttribute: .top, secondAttribute: .top)
                    }
                }.active()
                context("first item은 child, second item은 root가 된다") {
                    XCTAssertEqual(child.superview, root)
                    XCTAssertEqual(root.constraints.count, 1)
                    XCTAssertNotNil(root.constraints.filter(child, firstAttribute: .top, toItem: root))
                }
                deactivatable = AnyDeactivatable()
            }
        }
    }
    
    func testConstraintWithAnchors() {
        root.addSubview(child)
        root.addSubview(red)
        
        NSLayoutConstraint.activate([
            child.topAnchor.constraint(equalTo: root.topAnchor),
            child.leadingAnchor.constraint(equalTo: root.leadingAnchor),
            child.trailingAnchor.constraint(equalTo: red.leadingAnchor),
            child.bottomAnchor.constraint(equalTo: root.bottomAnchor),
            red.topAnchor.constraint(equalTo: root.topAnchor),
            red.trailingAnchor.constraint(equalTo: root.trailingAnchor),
            red.bottomAnchor.constraint(equalTo: root.bottomAnchor)
        ])
       
        // root가 constraint를 다 가져감
        XCTAssertEqual(root.constraints.count, 7)
        for attr in [NSLayoutConstraint.Attribute.top, .leading, .bottom] {
            XCTAssertNotNil(root.constraints.filter(child, firstAttribute: attr, toItem: root).first)
        }
        XCTAssertNotNil(root.constraints.filter(child, firstAttribute: .trailing, toItem: red, toAttribute: .leading).first, root.constraints.description)
        for attr in [NSLayoutConstraint.Attribute.top, .trailing, .bottom] {
            XCTAssertNotNil(root.constraints.filter(red, firstAttribute: attr, toItem: root).first)
        }
    }
    
    func testConstraintDSL() {
        deactivatable = root {
            child.constraint(.top, .leading, .bottom).constraint(.trailing, to: (red, .leading))
            red.constraint(.top, .trailing, .bottom)
        }.active()
        
        // root가 constraint를 다 가져감
        XCTAssertEqual(root.constraints.count, 7)
        for attr in [NSLayoutConstraint.Attribute.top, .leading, .bottom] {
            XCTAssertNotNil(root.constraints.filter(child, firstAttribute: attr, toItem: root).first)
        }
        XCTAssertNotNil(root.constraints.filter(child, firstAttribute: .trailing, toItem: red, toAttribute: .leading).first)
        for attr in [NSLayoutConstraint.Attribute.top, .trailing, .bottom] {
            XCTAssertNotNil(root.constraints.filter(red, firstAttribute: attr, toItem: root).first)
        }
    }
    
    func testLayoutInConstraint() {
        deactivatable = root {
            child.constraint(.top, .bottom, .leading, .trailing).layout {
                red.constraint(.centerX, .centerY)
            }
        }.active()
        
        XCTAssertEqual(red.superview, child)
        XCTAssertEqual(child.superview, root)
        
        for attr in [NSLayoutConstraint.Attribute.top, .leading, .trailing, .bottom] {
            XCTAssertNotNil(root.constraints.filter(child, firstAttribute: attr, toItem: root).first)
        }
        print(root.constraints)
        XCTAssertNotNil(child.constraints.filter(red, firstAttribute: .centerX, toItem: child).first)
        XCTAssertNotNil(child.constraints.filter(red, firstAttribute: .centerY, toItem: child).first)
    }
    
}

extension Collection where Element: NSLayoutConstraint {
    func filter(_ item: NSObject, firstAttribute: NSLayoutConstraint.Attribute,
                relation: NSLayoutConstraint.Relation = .equal,
                toItem: NSObject?, toAttribute: NSLayoutConstraint.Attribute? = nil) -> [Element] {
        filter { constraint in
            guard constraint.relation == relation else { return false }
            if let toItem = toItem {
                guard constraint.firstAttribute == firstAttribute else { return false }
                guard constraint.secondAttribute == toAttribute ?? firstAttribute else { return false }
                return item.isEqual(constraint.firstItem) && toItem.isEqual(constraint.secondItem)
            } else {
                guard constraint.firstAttribute == firstAttribute else { return false }
                return item.isEqual(constraint.firstItem)
            }
            
        }
    }
}
