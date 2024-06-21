//
//  AnchorsImplementationTests.swift
//  
//
//  Created by aiden_h on 2022/04/03.
//

import Testing
import UIKit
@testable import SwiftLayout

@MainActor
struct AnchorsImplementationTests {
    var superview: UIView = UIView()
    var subview: UIView = UIView()
    var siblingview: UIView = UIView()
    
    var tags: [UIView: String] {
        [
            superview: "superview",
            subview: "subview",
            siblingview: "siblingview"
        ]
    }
}

// MARK: - Attribute
extension AnchorsImplementationTests {
    @Test(
        "Anchors attribute - xAxis",
        arguments: zip(
            AnchorsXAxisAttribute.allCases,
            NSLayoutConstraint.Attribute.allCasesForXAis
        )
    )
    func xAxisAttribute(_ anchorsAttribute: AnchorsXAxisAttribute, _ attribute: NSLayoutConstraint.Attribute) {
        #expect(anchorsAttribute.attribute == attribute)
        #expect(anchorsAttribute == AnchorsXAxisAttribute(attribute: attribute))
    }

    @Test(
        "Anchors attribute - yAxis",
        arguments: zip(
            AnchorsYAxisAttribute.allCases,
            NSLayoutConstraint.Attribute.allCasesForYAis
        )
    )
    func yAxisAttribute(_ anchorsAttribute: AnchorsYAxisAttribute, _ attribute: NSLayoutConstraint.Attribute) {
        #expect(anchorsAttribute.attribute == attribute)
        #expect(anchorsAttribute == AnchorsYAxisAttribute(attribute: attribute))
    }

    @Test(
        "Anchors attribute - Dimension",
        arguments: zip(
            AnchorsDimensionAttribute.allCases,
            NSLayoutConstraint.Attribute.allCasesForDimension
        )
    )
    func dimensionAttribute(_ anchorsAttribute: AnchorsDimensionAttribute, _ attribute: NSLayoutConstraint.Attribute) {
        #expect(anchorsAttribute.attribute == attribute)
        #expect(anchorsAttribute == AnchorsDimensionAttribute(attribute: attribute))
    }
}

// MARK: - Expression
extension AnchorsImplementationTests {
    @Test("epression x axis constraints", arguments: AnchorsXAxisAttribute.allCases)
    func epressionXAxisConstraints(_ attribute: AnchorsXAxisAttribute) {
        let constant: CGFloat = 11.0
        func toAttribute(attribute: AnchorsXAxisAttribute) -> AnchorsXAxisAttribute {
            switch attribute {
            case .left, .right, .leftMargin, .rightMargin:
                return .left
            default:
                return .leading
            }
        }
        
        @AnchorsBuilder
        var anchors: Anchors {
            AnchorsExpression(xAxis: attribute)
            
            AnchorsExpression(xAxis: attribute).equalToSuper()
            AnchorsExpression(xAxis: attribute).equalToSuper(attribute: toAttribute(attribute: attribute))
            AnchorsExpression(xAxis: attribute).equalToSuper(attribute: toAttribute(attribute: attribute), constant: constant)
            AnchorsExpression(xAxis: attribute).equalToSuper(attribute: toAttribute(attribute: attribute), inwardOffset: constant)
            
            AnchorsExpression(xAxis: attribute).greaterThanOrEqualToSuper()
            AnchorsExpression(xAxis: attribute).greaterThanOrEqualToSuper(attribute: toAttribute(attribute: attribute))
            AnchorsExpression(xAxis: attribute).greaterThanOrEqualToSuper(attribute: toAttribute(attribute: attribute), constant: constant)
            AnchorsExpression(xAxis: attribute).greaterThanOrEqualToSuper(attribute: toAttribute(attribute: attribute), inwardOffset: constant)
            
            AnchorsExpression(xAxis: attribute).lessThanOrEqualToSuper()
            AnchorsExpression(xAxis: attribute).lessThanOrEqualToSuper(attribute: toAttribute(attribute: attribute))
            AnchorsExpression(xAxis: attribute).lessThanOrEqualToSuper(attribute: toAttribute(attribute: attribute), constant: constant)
            AnchorsExpression(xAxis: attribute).lessThanOrEqualToSuper(attribute: toAttribute(attribute: attribute), inwardOffset: constant)
            
            AnchorsExpression(xAxis: attribute).equalTo(siblingview)
            AnchorsExpression(xAxis: attribute).equalTo(siblingview, attribute: toAttribute(attribute: attribute))
            AnchorsExpression(xAxis: attribute).equalTo(siblingview, attribute: toAttribute(attribute: attribute), constant: constant)
            AnchorsExpression(xAxis: attribute).equalTo(siblingview, attribute: toAttribute(attribute: attribute), inwardOffset: constant)
            
            AnchorsExpression(xAxis: attribute).greaterThanOrEqualTo(siblingview)
            AnchorsExpression(xAxis: attribute).greaterThanOrEqualTo(siblingview, attribute: toAttribute(attribute: attribute))
            AnchorsExpression(xAxis: attribute).greaterThanOrEqualTo(siblingview, attribute: toAttribute(attribute: attribute), constant: constant)
            AnchorsExpression(xAxis: attribute).greaterThanOrEqualTo(siblingview, attribute: toAttribute(attribute: attribute), inwardOffset: constant)
            
            AnchorsExpression(xAxis: attribute).lessThanOrEqualTo(siblingview)
            AnchorsExpression(xAxis: attribute).lessThanOrEqualTo(siblingview, attribute: toAttribute(attribute: attribute))
            AnchorsExpression(xAxis: attribute).lessThanOrEqualTo(siblingview, attribute: toAttribute(attribute: attribute), constant: constant)
            AnchorsExpression(xAxis: attribute).lessThanOrEqualTo(siblingview, attribute: toAttribute(attribute: attribute), inwardOffset: constant)
            
            switch attribute {
            case .left, .right, .leftMargin, .rightMargin:
                AnchorsExpression(xAxis: attribute)
            default:
                AnchorsExpression(xAxis: attribute).equalTo(siblingview.leadingAnchor)
                AnchorsExpression(xAxis: attribute).equalTo(siblingview.leadingAnchor, constant: constant)
                AnchorsExpression(xAxis: attribute).equalTo(siblingview.leadingAnchor, inwardOffset: constant)
                AnchorsExpression(xAxis: attribute).greaterThanOrEqualTo(siblingview.leadingAnchor)
                AnchorsExpression(xAxis: attribute).greaterThanOrEqualTo(siblingview.leadingAnchor, constant: constant)
                AnchorsExpression(xAxis: attribute).greaterThanOrEqualTo(siblingview.leadingAnchor, inwardOffset: constant)
                AnchorsExpression(xAxis: attribute).lessThanOrEqualTo(siblingview.leadingAnchor)
                AnchorsExpression(xAxis: attribute).lessThanOrEqualTo(siblingview.leadingAnchor, constant: constant)
                AnchorsExpression(xAxis: attribute).lessThanOrEqualTo(siblingview.leadingAnchor, inwardOffset: constant)
            }
        }

        let constrints = anchors.constraints(item: subview, toItem: superview)
        var expected = [
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: superview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),

            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: superview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: superview, attribute: toAttribute(attribute: attribute).attribute, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: superview, attribute: toAttribute(attribute: attribute).attribute, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: superview, attribute: toAttribute(attribute: attribute).attribute, multiplier: 1.0, constant: constant * attribute.inwardDirectionFactor),

            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: superview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: superview, attribute: toAttribute(attribute: attribute).attribute, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: superview, attribute: toAttribute(attribute: attribute).attribute, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: superview, attribute: toAttribute(attribute: attribute).attribute, multiplier: 1.0, constant: constant * attribute.inwardDirectionFactor),

            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: superview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: superview, attribute: toAttribute(attribute: attribute).attribute, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: superview, attribute: toAttribute(attribute: attribute).attribute, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: superview, attribute: toAttribute(attribute: attribute).attribute, multiplier: 1.0, constant: constant * attribute.inwardDirectionFactor),

            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: siblingview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: siblingview, attribute: toAttribute(attribute: attribute).attribute, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: siblingview, attribute: toAttribute(attribute: attribute).attribute, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: siblingview, attribute: toAttribute(attribute: attribute).attribute, multiplier: 1.0, constant: constant * attribute.inwardDirectionFactor),

            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: siblingview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: siblingview, attribute: toAttribute(attribute: attribute).attribute, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: siblingview, attribute: toAttribute(attribute: attribute).attribute, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: siblingview, attribute: toAttribute(attribute: attribute).attribute, multiplier: 1.0, constant: constant * attribute.inwardDirectionFactor),

            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: siblingview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: siblingview, attribute: toAttribute(attribute: attribute).attribute, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: siblingview, attribute: toAttribute(attribute: attribute).attribute, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: siblingview, attribute: toAttribute(attribute: attribute).attribute, multiplier: 1.0, constant: constant * attribute.inwardDirectionFactor),
        ]

        switch attribute {
        case .left, .right, .leftMargin, .rightMargin:
            expected += [
                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: superview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),
            ]
        default:
            expected += [
                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: siblingview, attribute: .leading, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: siblingview, attribute: .leading, multiplier: 1.0, constant: constant),
                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: siblingview, attribute: .leading, multiplier: 1.0, constant: constant * attribute.inwardDirectionFactor),
                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: siblingview, attribute: .leading, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: siblingview, attribute: .leading, multiplier: 1.0, constant: constant),
                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: siblingview, attribute: .leading, multiplier: 1.0, constant: constant * attribute.inwardDirectionFactor),
                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: siblingview, attribute: .leading, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: siblingview, attribute: .leading, multiplier: 1.0, constant: constant),
                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: siblingview, attribute: .leading, multiplier: 1.0, constant: constant * attribute.inwardDirectionFactor),
            ]
        }

        #expect(isEqual(constrints, expected, tags))
    }
    
    @Test("epression y axis constraints", arguments: AnchorsYAxisAttribute.allCases)
    func expressionYAxisConstraints(_ attribute: AnchorsYAxisAttribute) {
        let constant: CGFloat = 11.0

        @AnchorsBuilder
        var anchors: Anchors {
            AnchorsExpression(yAxis: attribute)
            
            AnchorsExpression(yAxis: attribute).equalToSuper()
            AnchorsExpression(yAxis: attribute).equalToSuper(attribute: .top)
            AnchorsExpression(yAxis: attribute).equalToSuper(attribute: .top, constant: constant)
            AnchorsExpression(yAxis: attribute).equalToSuper(attribute: .top, inwardOffset: constant)
            
            AnchorsExpression(yAxis: attribute).greaterThanOrEqualToSuper()
            AnchorsExpression(yAxis: attribute).greaterThanOrEqualToSuper(attribute: .top)
            AnchorsExpression(yAxis: attribute).greaterThanOrEqualToSuper(attribute: .top, constant: constant)
            AnchorsExpression(yAxis: attribute).greaterThanOrEqualToSuper(attribute: .top, inwardOffset: constant)
            
            AnchorsExpression(yAxis: attribute).lessThanOrEqualToSuper()
            AnchorsExpression(yAxis: attribute).lessThanOrEqualToSuper(attribute: .top)
            AnchorsExpression(yAxis: attribute).lessThanOrEqualToSuper(attribute: .top, constant: constant)
            AnchorsExpression(yAxis: attribute).lessThanOrEqualToSuper(attribute: .top, inwardOffset: constant)
            
            AnchorsExpression(yAxis: attribute).equalTo(siblingview)
            AnchorsExpression(yAxis: attribute).equalTo(siblingview, attribute: .top)
            AnchorsExpression(yAxis: attribute).equalTo(siblingview, attribute: .top, constant: constant)
            AnchorsExpression(yAxis: attribute).equalTo(siblingview, attribute: .top, inwardOffset: constant)
            
            AnchorsExpression(yAxis: attribute).greaterThanOrEqualTo(siblingview)
            AnchorsExpression(yAxis: attribute).greaterThanOrEqualTo(siblingview, attribute: .top)
            AnchorsExpression(yAxis: attribute).greaterThanOrEqualTo(siblingview, attribute: .top, constant: constant)
            AnchorsExpression(yAxis: attribute).greaterThanOrEqualTo(siblingview, attribute: .top, inwardOffset: constant)
            
            AnchorsExpression(yAxis: attribute).lessThanOrEqualTo(siblingview)
            AnchorsExpression(yAxis: attribute).lessThanOrEqualTo(siblingview, attribute: .top)
            AnchorsExpression(yAxis: attribute).lessThanOrEqualTo(siblingview, attribute: .top, constant: constant)
            AnchorsExpression(yAxis: attribute).lessThanOrEqualTo(siblingview, attribute: .top, inwardOffset: constant)
            
            AnchorsExpression(yAxis: attribute).equalTo(siblingview.topAnchor)
            AnchorsExpression(yAxis: attribute).equalTo(siblingview.topAnchor, constant: constant)
            AnchorsExpression(yAxis: attribute).equalTo(siblingview.topAnchor, inwardOffset: constant)
            AnchorsExpression(yAxis: attribute).greaterThanOrEqualTo(siblingview.topAnchor)
            AnchorsExpression(yAxis: attribute).greaterThanOrEqualTo(siblingview.topAnchor, constant: constant)
            AnchorsExpression(yAxis: attribute).greaterThanOrEqualTo(siblingview.topAnchor, inwardOffset: constant)
            AnchorsExpression(yAxis: attribute).lessThanOrEqualTo(siblingview.topAnchor)
            AnchorsExpression(yAxis: attribute).lessThanOrEqualTo(siblingview.topAnchor, constant: constant)
            AnchorsExpression(yAxis: attribute).lessThanOrEqualTo(siblingview.topAnchor, inwardOffset: constant)
        }

        let constraints = anchors.constraints(item: subview, toItem: superview)
        let expected = [
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: superview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),

            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: superview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: constant * attribute.inwardDirectionFactor),

            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: superview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: superview, attribute: .top, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: superview, attribute: .top, multiplier: 1.0, constant: constant * attribute.inwardDirectionFactor),

            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: superview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: superview, attribute: .top, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: superview, attribute: .top, multiplier: 1.0, constant: constant * attribute.inwardDirectionFactor),

            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: siblingview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: constant * attribute.inwardDirectionFactor),

            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: siblingview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: constant * attribute.inwardDirectionFactor),

            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: siblingview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: constant * attribute.inwardDirectionFactor),

            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: constant * attribute.inwardDirectionFactor),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: constant * attribute.inwardDirectionFactor),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: constant * attribute.inwardDirectionFactor),
        ]

        #expect(isEqual(constraints, expected, tags))
    }

    @Test("epression dimension constraints", arguments: AnchorsDimensionAttribute.allCases)
    func expressionDimensionConstraints(_ attribute: AnchorsDimensionAttribute) {
        let constant: CGFloat = 11.0
        
        @AnchorsBuilder
        var anchors: Anchors {
            AnchorsExpression(dimensions: attribute)

            AnchorsExpression(dimensions: attribute).equalToSuper()
            AnchorsExpression(dimensions: attribute).equalToSuper(attribute: .width)
            AnchorsExpression(dimensions: attribute).equalToSuper(attribute: .width, constant: constant)

            AnchorsExpression(dimensions: attribute).greaterThanOrEqualToSuper()
            AnchorsExpression(dimensions: attribute).greaterThanOrEqualToSuper(attribute: .width)
            AnchorsExpression(dimensions: attribute).greaterThanOrEqualToSuper(attribute: .width, constant: constant)

            AnchorsExpression(dimensions: attribute).lessThanOrEqualToSuper()
            AnchorsExpression(dimensions: attribute).lessThanOrEqualToSuper(attribute: .width)
            AnchorsExpression(dimensions: attribute).lessThanOrEqualToSuper(attribute: .width, constant: constant)

            AnchorsExpression(dimensions: attribute).equalTo(siblingview)
            AnchorsExpression(dimensions: attribute).equalTo(siblingview, attribute: .width)
            AnchorsExpression(dimensions: attribute).equalTo(siblingview, attribute: .width, constant: constant)

            AnchorsExpression(dimensions: attribute).greaterThanOrEqualTo(siblingview)
            AnchorsExpression(dimensions: attribute).greaterThanOrEqualTo(siblingview, attribute: .width)
            AnchorsExpression(dimensions: attribute).greaterThanOrEqualTo(siblingview, attribute: .width, constant: constant)

            AnchorsExpression(dimensions: attribute).lessThanOrEqualTo(siblingview)
            AnchorsExpression(dimensions: attribute).lessThanOrEqualTo(siblingview, attribute: .width)
            AnchorsExpression(dimensions: attribute).lessThanOrEqualTo(siblingview, attribute: .width, constant: constant)
            
            AnchorsExpression(dimensions: attribute).equalTo(constant: constant)
            AnchorsExpression(dimensions: attribute).greaterThanOrEqualTo(constant: constant)
            AnchorsExpression(dimensions: attribute).lessThanOrEqualTo(constant: constant)
            
            AnchorsExpression(dimensions: attribute).equalTo(siblingview.widthAnchor)
            AnchorsExpression(dimensions: attribute).equalTo(siblingview.widthAnchor, constant: constant)
            AnchorsExpression(dimensions: attribute).greaterThanOrEqualTo(siblingview.widthAnchor)
            AnchorsExpression(dimensions: attribute).greaterThanOrEqualTo(siblingview.widthAnchor, constant: constant)
            AnchorsExpression(dimensions: attribute).lessThanOrEqualTo(siblingview.widthAnchor)
            AnchorsExpression(dimensions: attribute).lessThanOrEqualTo(siblingview.widthAnchor, constant: constant)
        }

        let constraints = anchors.constraints(item: subview, toItem: superview)
        let expected = [
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: superview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),

            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: superview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 1.0, constant: constant),

            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: superview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: superview, attribute: .width, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: superview, attribute: .width, multiplier: 1.0, constant: constant),

            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: superview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: superview, attribute: .width, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: superview, attribute: .width, multiplier: 1.0, constant: constant),

            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: siblingview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: siblingview, attribute: .width, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: siblingview, attribute: .width, multiplier: 1.0, constant: constant),

            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: siblingview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: siblingview, attribute: .width, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: siblingview, attribute: .width, multiplier: 1.0, constant: constant),

            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: siblingview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: siblingview, attribute: .width, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: siblingview, attribute: .width, multiplier: 1.0, constant: constant),

            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: constant),

            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: siblingview, attribute: .width, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: siblingview, attribute: .width, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: siblingview, attribute: .width, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: siblingview, attribute: .width, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: siblingview, attribute: .width, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: siblingview, attribute: .width, multiplier: 1.0, constant: constant),
        ]

        #expect(isEqual(constraints, expected, tags))
    }
    
    @Test
    func expressionConstantAndMultiplier() {
        let constant: CGFloat = 11.0
        let multiplier: CGFloat = 0.5
        
        @AnchorsBuilder
        var anchors: Anchors {
            AnchorsExpression(xAxis: .leading).equalToSuper(attribute: .trailing, constant: constant)
            AnchorsExpression(xAxis: .leading).equalToSuper(attribute: .trailing, constant: constant).multiplier(multiplier)
            AnchorsExpression(xAxis: .leading).equalTo(siblingview, attribute: .trailing, constant: constant)
            AnchorsExpression(xAxis: .leading).equalTo(siblingview, attribute: .trailing, constant: constant).multiplier(multiplier)
            
            AnchorsExpression(yAxis: .top).equalToSuper(attribute: .bottom, constant: constant)
            AnchorsExpression(yAxis: .top).equalToSuper(attribute: .bottom, constant: constant).multiplier(multiplier)
            AnchorsExpression(yAxis: .top).equalTo(siblingview, attribute: .bottom, constant: constant)
            AnchorsExpression(yAxis: .top).equalTo(siblingview, attribute: .bottom, constant: constant).multiplier(multiplier)
            
            AnchorsExpression(dimensions: .width).equalTo(constant: constant)
            AnchorsExpression(dimensions: .width).equalTo(constant: constant).multiplier(multiplier)
            AnchorsExpression(dimensions: .width).equalToSuper(attribute: .height, constant: constant)
            AnchorsExpression(dimensions: .width).equalToSuper(attribute: .height, constant: constant).multiplier(multiplier)
            AnchorsExpression(dimensions: .width).equalTo(siblingview, attribute: .height, constant: constant)
            AnchorsExpression(dimensions: .width).equalTo(siblingview, attribute: .height, constant: constant).multiplier(multiplier)
        }
        
        let constraints = anchors.constraints(item: subview, toItem: superview)
        let expected = [
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: multiplier, constant: constant),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: siblingview, attribute: .trailing, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: siblingview, attribute: .trailing, multiplier: multiplier, constant: constant),
            
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: multiplier, constant: constant),
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: siblingview, attribute: .bottom, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: siblingview, attribute: .bottom, multiplier: multiplier, constant: constant),
            
            NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: multiplier, constant: constant),
            NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: multiplier, constant: constant),
            NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: siblingview, attribute: .height, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: siblingview, attribute: .height, multiplier: multiplier, constant: constant),
        ]

        #expect(isEqual(constraints, expected, tags))
    }
    
    @Test
    func expressionConstantAndPriority() {
        let constant: CGFloat = 11.0
        let priority: UILayoutPriority = .defaultLow
        
        @AnchorsBuilder
        var anchors: Anchors {
            AnchorsExpression(xAxis: .leading).equalToSuper(attribute: .trailing, constant: constant)
            AnchorsExpression(xAxis: .leading).equalToSuper(attribute: .trailing, constant: constant).priority(priority)
            AnchorsExpression(xAxis: .leading).equalTo(siblingview, attribute: .trailing, constant: constant)
            AnchorsExpression(xAxis: .leading).equalTo(siblingview, attribute: .trailing, constant: constant).priority(priority)
            
            AnchorsExpression(yAxis: .top).equalToSuper(attribute: .bottom, constant: constant)
            AnchorsExpression(yAxis: .top).equalToSuper(attribute: .bottom, constant: constant).priority(priority)
            AnchorsExpression(yAxis: .top).equalTo(siblingview, attribute: .bottom, constant: constant)
            AnchorsExpression(yAxis: .top).equalTo(siblingview, attribute: .bottom, constant: constant).priority(priority)
            
            AnchorsExpression(dimensions: .width).equalTo(constant: constant)
            AnchorsExpression(dimensions: .width).equalTo(constant: constant).priority(priority)
            AnchorsExpression(dimensions: .width).equalToSuper(attribute: .height, constant: constant)
            AnchorsExpression(dimensions: .width).equalToSuper(attribute: .height, constant: constant).priority(priority)
            AnchorsExpression(dimensions: .width).equalTo(siblingview, attribute: .height, constant: constant)
            AnchorsExpression(dimensions: .width).equalTo(siblingview, attribute: .height, constant: constant).priority(priority)
        }
        
        let constraints = anchors.constraints(item: subview, toItem: superview)
        let expected: [NSLayoutConstraint] = [
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: siblingview, attribute: .trailing, multiplier: 1.0, constant: constant),

            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: siblingview, attribute: .bottom, multiplier: 1.0, constant: constant),

            NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 1.0, constant: constant),
            NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: siblingview, attribute: .height, multiplier: 1.0, constant: constant),
        ].flatMap { constraint -> [NSLayoutConstraint] in
            let priorityed = NSLayoutConstraint(
                item: constraint.firstItem!, attribute: constraint.firstAttribute,
                relatedBy: constraint.relation,
                toItem: constraint.secondItem, attribute: constraint.secondAttribute,
                multiplier: constraint.multiplier, constant: constraint.constant
            )
            priorityed.priority = priority
            return [constraint, priorityed]
        }

        #expect(isEqual(constraints, expected, tags))
    }
    
    @Test
    func expressionChainingXAxis() {
        @AnchorsBuilder
        var anchors: Anchors {
            AnchorsExpression<AnchorsXAxisAttribute>().centerX.leading.trailing.left.right.centerXWithinMargins.leftMargin.rightMargin.leadingMargin.trailingMargin
        }
        let constraints = anchors.constraints(item: subview, toItem: superview)
        let expected = [
            NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .centerXWithinMargins, relatedBy: .equal, toItem: superview, attribute: .centerXWithinMargins, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leftMargin, relatedBy: .equal, toItem: superview, attribute: .leftMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .rightMargin, relatedBy: .equal, toItem: superview, attribute: .rightMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leadingMargin, relatedBy: .equal, toItem: superview, attribute: .leadingMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .trailingMargin, relatedBy: .equal, toItem: superview, attribute: .trailingMargin, multiplier: 1.0, constant: 0.0),
        ]

        #expect(isEqual(constraints, expected, tags))
    }

    @Test
    func expressionChainingYAxis() {
            @AnchorsBuilder
        var anchors: Anchors {
            AnchorsExpression<AnchorsYAxisAttribute>().centerY.top.bottom.firstBaseline.lastBaseline.centerYWithinMargins.topMargin.bottomMargin


        }
        let constraints = anchors.constraints(item: subview, toItem: superview)
        let expected = [
            NSLayoutConstraint(item: subview, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .firstBaseline, relatedBy: .equal, toItem: superview, attribute: .firstBaseline, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .lastBaseline, relatedBy: .equal, toItem: superview, attribute: .lastBaseline, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .centerYWithinMargins, relatedBy: .equal, toItem: superview, attribute: .centerYWithinMargins, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .topMargin, relatedBy: .equal, toItem: superview, attribute: .topMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .bottomMargin, relatedBy: .equal, toItem: superview, attribute: .bottomMargin, multiplier: 1.0, constant: 0.0),
        ]

        #expect(isEqual(constraints, expected, tags))
    }
        
    @Test
    func expressionChainingDimensionAxis() {
        @AnchorsBuilder
        var anchors: Anchors {
            AnchorsExpression<AnchorsDimensionAttribute>().height.width
        }
        let constraints = anchors.constraints(item: subview, toItem: superview)
        let expected = [
            NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 1.0, constant: 0.0),

        ]

        #expect(isEqual(constraints, expected, tags))
    }

    @Test
    func mixedExpressionFromAnchorsExpressionXAxis() {
        @AnchorsBuilder
        var anchors: Anchors {
            AnchorsExpression<AnchorsXAxisAttribute>().centerY
            AnchorsExpression<AnchorsXAxisAttribute>().top
            AnchorsExpression<AnchorsXAxisAttribute>().bottom
            AnchorsExpression<AnchorsXAxisAttribute>().firstBaseline
            AnchorsExpression<AnchorsXAxisAttribute>().lastBaseline
            AnchorsExpression<AnchorsXAxisAttribute>().centerYWithinMargins
            AnchorsExpression<AnchorsXAxisAttribute>().topMargin
            AnchorsExpression<AnchorsXAxisAttribute>().bottomMargin
            AnchorsExpression<AnchorsXAxisAttribute>().height
            AnchorsExpression<AnchorsXAxisAttribute>().width
        }
        let constraints = anchors.constraints(item: subview, toItem: superview)
        let expected = [
            NSLayoutConstraint(item: subview, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .firstBaseline, relatedBy: .equal, toItem: superview, attribute: .firstBaseline, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .lastBaseline, relatedBy: .equal, toItem: superview, attribute: .lastBaseline, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .centerYWithinMargins, relatedBy: .equal, toItem: superview, attribute: .centerYWithinMargins, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .topMargin, relatedBy: .equal, toItem: superview, attribute: .topMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .bottomMargin, relatedBy: .equal, toItem: superview, attribute: .bottomMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 1.0, constant: 0.0),
        ]

        #expect(isEqual(constraints, expected, tags))
    }

    @Test
    func mixedExpressionFromAnchorsExpressionYAxis() {
        @AnchorsBuilder
        var anchors: Anchors {
            AnchorsExpression<AnchorsYAxisAttribute>().centerX
            AnchorsExpression<AnchorsYAxisAttribute>().leading
            AnchorsExpression<AnchorsYAxisAttribute>().trailing
            AnchorsExpression<AnchorsYAxisAttribute>().left
            AnchorsExpression<AnchorsYAxisAttribute>().right
            AnchorsExpression<AnchorsYAxisAttribute>().centerXWithinMargins
            AnchorsExpression<AnchorsYAxisAttribute>().leftMargin
            AnchorsExpression<AnchorsYAxisAttribute>().rightMargin
            AnchorsExpression<AnchorsYAxisAttribute>().leadingMargin
            AnchorsExpression<AnchorsYAxisAttribute>().trailingMargin
            AnchorsExpression<AnchorsYAxisAttribute>().height
            AnchorsExpression<AnchorsYAxisAttribute>().width
        }
        let constraints = anchors.constraints(item: subview, toItem: superview)
        let expected = [
            NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .centerXWithinMargins, relatedBy: .equal, toItem: superview, attribute: .centerXWithinMargins, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leftMargin, relatedBy: .equal, toItem: superview, attribute: .leftMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .rightMargin, relatedBy: .equal, toItem: superview, attribute: .rightMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leadingMargin, relatedBy: .equal, toItem: superview, attribute: .leadingMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .trailingMargin, relatedBy: .equal, toItem: superview, attribute: .trailingMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 1.0, constant: 0.0),
        ]

        #expect(isEqual(constraints, expected, tags))
    }

    @Test
    func mixedExpressionFromAnchorsExpressionDimensionAxis() {
        @AnchorsBuilder
        var anchors: Anchors {
            AnchorsExpression<AnchorsDimensionAttribute>().centerX
            AnchorsExpression<AnchorsDimensionAttribute>().leading
            AnchorsExpression<AnchorsDimensionAttribute>().trailing
            AnchorsExpression<AnchorsDimensionAttribute>().left
            AnchorsExpression<AnchorsDimensionAttribute>().right
            AnchorsExpression<AnchorsDimensionAttribute>().centerXWithinMargins
            AnchorsExpression<AnchorsDimensionAttribute>().leftMargin
            AnchorsExpression<AnchorsDimensionAttribute>().rightMargin
            AnchorsExpression<AnchorsDimensionAttribute>().leadingMargin
            AnchorsExpression<AnchorsDimensionAttribute>().trailingMargin
            AnchorsExpression<AnchorsDimensionAttribute>().centerY
            AnchorsExpression<AnchorsDimensionAttribute>().top
            AnchorsExpression<AnchorsDimensionAttribute>().bottom
            AnchorsExpression<AnchorsDimensionAttribute>().firstBaseline
            AnchorsExpression<AnchorsDimensionAttribute>().lastBaseline
            AnchorsExpression<AnchorsDimensionAttribute>().centerYWithinMargins
            AnchorsExpression<AnchorsDimensionAttribute>().topMargin
            AnchorsExpression<AnchorsDimensionAttribute>().bottomMargin
        }
        let constraints = anchors.constraints(item: subview, toItem: superview)
        let expected = [
            NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .centerXWithinMargins, relatedBy: .equal, toItem: superview, attribute: .centerXWithinMargins, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leftMargin, relatedBy: .equal, toItem: superview, attribute: .leftMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .rightMargin, relatedBy: .equal, toItem: superview, attribute: .rightMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leadingMargin, relatedBy: .equal, toItem: superview, attribute: .leadingMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .trailingMargin, relatedBy: .equal, toItem: superview, attribute: .trailingMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .firstBaseline, relatedBy: .equal, toItem: superview, attribute: .firstBaseline, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .lastBaseline, relatedBy: .equal, toItem: superview, attribute: .lastBaseline, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .centerYWithinMargins, relatedBy: .equal, toItem: superview, attribute: .centerYWithinMargins, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .topMargin, relatedBy: .equal, toItem: superview, attribute: .topMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .bottomMargin, relatedBy: .equal, toItem: superview, attribute: .bottomMargin, multiplier: 1.0, constant: 0.0),
        ]

        #expect(isEqual(constraints, expected, tags))
    }

    @Test
    func mixedExpressionConstraints() {
        let constant: CGFloat = 11.0
        let attributes: [any AnchorsAttribute] = [
            AnchorsXAxisAttribute.centerX,
            AnchorsXAxisAttribute.leading,
            AnchorsXAxisAttribute.trailing,
            AnchorsXAxisAttribute.left,
            AnchorsXAxisAttribute.right,
            AnchorsXAxisAttribute.centerXWithinMargins,
            AnchorsXAxisAttribute.leftMargin,
            AnchorsXAxisAttribute.rightMargin,
            AnchorsXAxisAttribute.leadingMargin,
            AnchorsXAxisAttribute.trailingMargin,
            AnchorsYAxisAttribute.centerY,
            AnchorsYAxisAttribute.top,
            AnchorsYAxisAttribute.bottom,
            AnchorsYAxisAttribute.firstBaseline,
            AnchorsYAxisAttribute.lastBaseline,
            AnchorsYAxisAttribute.centerYWithinMargins,
            AnchorsYAxisAttribute.topMargin,
            AnchorsYAxisAttribute.bottomMargin,
            AnchorsDimensionAttribute.height,
            AnchorsDimensionAttribute.width,
        ]

        for attribute in attributes {
            let mixedExpression: AnchorsMixedExpression = AnchorsMixedExpression(from: AnchorsExpression<AnchorsXAxisAttribute>(), appendedAttribute: attribute)
            
            @AnchorsBuilder
            var anchors: Anchors {
                mixedExpression.equalToSuper()
                mixedExpression.equalToSuper(constant: constant)
                mixedExpression.equalToSuper(inwardOffset: constant)

                mixedExpression.greaterThanOrEqualToSuper()
                mixedExpression.greaterThanOrEqualToSuper(constant: constant)
                mixedExpression.greaterThanOrEqualToSuper(inwardOffset: constant)

                mixedExpression.lessThanOrEqualToSuper()
                mixedExpression.lessThanOrEqualToSuper(constant: constant)
                mixedExpression.lessThanOrEqualToSuper(inwardOffset: constant)

                mixedExpression.equalTo(siblingview)
                mixedExpression.equalTo(siblingview, constant: constant)
                mixedExpression.equalTo(siblingview, inwardOffset: constant)

                mixedExpression.greaterThanOrEqualTo(siblingview)
                mixedExpression.greaterThanOrEqualTo(siblingview, constant: constant)
                mixedExpression.greaterThanOrEqualTo(siblingview, inwardOffset: constant)

                mixedExpression.lessThanOrEqualTo(siblingview)
                mixedExpression.lessThanOrEqualTo(siblingview, constant: constant)
                mixedExpression.lessThanOrEqualTo(siblingview, inwardOffset: constant)
            }
            
            let constrints = anchors.constraints(item: subview, toItem: superview)
            let expected = [
                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: superview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: superview, attribute: attribute.attribute, multiplier: 1.0, constant: constant),
                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: superview, attribute: attribute.attribute, multiplier: 1.0, constant: constant * attribute.inwardDirectionFactor),

                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: superview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: superview, attribute: attribute.attribute, multiplier: 1.0, constant: constant),
                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: superview, attribute: attribute.attribute, multiplier: 1.0, constant: constant * attribute.inwardDirectionFactor),

                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: superview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: superview, attribute: attribute.attribute, multiplier: 1.0, constant: constant),
                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: superview, attribute: attribute.attribute, multiplier: 1.0, constant: constant * attribute.inwardDirectionFactor),

                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: siblingview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: siblingview, attribute: attribute.attribute, multiplier: 1.0, constant: constant),
                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .equal, toItem: siblingview, attribute: attribute.attribute, multiplier: 1.0, constant: constant * attribute.inwardDirectionFactor),

                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: siblingview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: siblingview, attribute: attribute.attribute, multiplier: 1.0, constant: constant),
                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .greaterThanOrEqual, toItem: siblingview, attribute: attribute.attribute, multiplier: 1.0, constant: constant * attribute.inwardDirectionFactor),

                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: siblingview, attribute: attribute.attribute, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: siblingview, attribute: attribute.attribute, multiplier: 1.0, constant: constant),
                NSLayoutConstraint(item: subview, attribute: attribute.attribute, relatedBy: .lessThanOrEqual, toItem: siblingview, attribute: attribute.attribute, multiplier: 1.0, constant: constant * attribute.inwardDirectionFactor),
            ]

            #expect(isEqual(constrints, expected, tags))
        }
    }

    @Test
    func mixedExpressionChaining() {
        @AnchorsBuilder
        var anchors: Anchors {
            AnchorsMixedExpression(from: AnchorsExpression<AnchorsXAxisAttribute>(), appendedAttribute: AnchorsXAxisAttribute.centerX)
                .centerX
                .leading
                .trailing
                .left
                .right
                .centerXWithinMargins
                .leftMargin
                .rightMargin
                .leadingMargin
                .trailingMargin
                .centerY
                .top
                .bottom
                .firstBaseline
                .lastBaseline
                .centerYWithinMargins
                .topMargin
                .bottomMargin
                .height
                .width
        }
        let constraints = anchors.constraints(item: subview, toItem: superview)
        let expected = [
            NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0),

            NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .centerXWithinMargins, relatedBy: .equal, toItem: superview, attribute: .centerXWithinMargins, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leftMargin, relatedBy: .equal, toItem: superview, attribute: .leftMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .rightMargin, relatedBy: .equal, toItem: superview, attribute: .rightMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leadingMargin, relatedBy: .equal, toItem: superview, attribute: .leadingMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .trailingMargin, relatedBy: .equal, toItem: superview, attribute: .trailingMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .firstBaseline, relatedBy: .equal, toItem: superview, attribute: .firstBaseline, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .lastBaseline, relatedBy: .equal, toItem: superview, attribute: .lastBaseline, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .centerYWithinMargins, relatedBy: .equal, toItem: superview, attribute: .centerYWithinMargins, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .topMargin, relatedBy: .equal, toItem: superview, attribute: .topMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .bottomMargin, relatedBy: .equal, toItem: superview, attribute: .bottomMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 1.0, constant: 0.0),
        ]

        #expect(isEqual(constraints, expected, tags))
    }

    @Test
    func expressionSafeArea() {
        @AnchorsBuilder
        var anchors: Anchors {
            for attribute in AnchorsXAxisAttribute.allCases {
                AnchorsExpression(xAxis: attribute).equalTo(superview.safeAreaLayoutGuide)
            }
            for attribute in AnchorsYAxisAttribute.allCases {
                AnchorsExpression(yAxis: attribute).equalTo(superview.safeAreaLayoutGuide)
            }
            for attribute in AnchorsDimensionAttribute.allCases {
                AnchorsExpression(dimensions: attribute).equalTo(superview.safeAreaLayoutGuide)
            }
        }
        
        let constraints = anchors.constraints(item: subview, toItem: superview)
        let expected = AnchorsXAxisAttribute.allCases.map {
            NSLayoutConstraint(item: subview, attribute: $0.attribute, relatedBy: .equal, toItem: superview.safeAreaLayoutGuide, attribute: $0.attribute, multiplier: 1.0, constant: 0.0)
        } + AnchorsYAxisAttribute.allCases.map {
            NSLayoutConstraint(item: subview, attribute: $0.attribute, relatedBy: .equal, toItem: superview.safeAreaLayoutGuide, attribute: $0.attribute, multiplier: 1.0, constant: 0.0)
        } + AnchorsDimensionAttribute.allCases.map {
            NSLayoutConstraint(item: subview, attribute: $0.attribute, relatedBy: .equal, toItem: superview.safeAreaLayoutGuide, attribute: $0.attribute, multiplier: 1.0, constant: 0.0)
        }
        
        #expect(isEqual(constraints, expected, tags))
    }
}

// MARK: - static
extension AnchorsImplementationTests {
    @Test
    func staticsSingle() {
        @AnchorsBuilder
        var anchors: Anchors {
            Anchors.centerX
            Anchors.leading
            Anchors.trailing
            Anchors.left
            Anchors.right
            Anchors.centerXWithinMargins
            Anchors.leftMargin
            Anchors.rightMargin
            Anchors.leadingMargin
            Anchors.trailingMargin
            Anchors.centerY
            Anchors.top
            Anchors.bottom
            Anchors.firstBaseline
            Anchors.lastBaseline
            Anchors.centerYWithinMargins
            Anchors.topMargin
            Anchors.bottomMargin
            Anchors.height
            Anchors.width
        }
        let constraints = anchors.constraints(item: subview, toItem: superview)
        let expected = [
            NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .centerXWithinMargins, relatedBy: .equal, toItem: superview, attribute: .centerXWithinMargins, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leftMargin, relatedBy: .equal, toItem: superview, attribute: .leftMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .rightMargin, relatedBy: .equal, toItem: superview, attribute: .rightMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leadingMargin, relatedBy: .equal, toItem: superview, attribute: .leadingMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .trailingMargin, relatedBy: .equal, toItem: superview, attribute: .trailingMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .firstBaseline, relatedBy: .equal, toItem: superview, attribute: .firstBaseline, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .lastBaseline, relatedBy: .equal, toItem: superview, attribute: .lastBaseline, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .centerYWithinMargins, relatedBy: .equal, toItem: superview, attribute: .centerYWithinMargins, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .topMargin, relatedBy: .equal, toItem: superview, attribute: .topMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .bottomMargin, relatedBy: .equal, toItem: superview, attribute: .bottomMargin, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 1.0, constant: 0.0),
        ]
        
        #expect(isEqual(constraints, expected, tags))
    }
    
    @Test
    func staticsMultipleHorizontal() {
        let offset: CGFloat = 13
        
        @AnchorsBuilder
        var anchors: Anchors {
            Anchors.horizontal.equalToSuper()
            Anchors.horizontal.equalToSuper(inwardOffset: 13)
            Anchors.horizontal.equalTo(siblingview)
            Anchors.horizontal.equalTo(siblingview, inwardOffset: 13)
        }
        let constraints = anchors.constraints(item: subview, toItem: superview)
        let expected = [
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: offset),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: -offset),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: siblingview, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: siblingview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: siblingview, attribute: .leading, multiplier: 1.0, constant: offset),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: siblingview, attribute: .trailing, multiplier: 1.0, constant: -offset),
        ]
        
        #expect(isEqual(constraints, expected, tags))
    }
    
    @Test
    func staticsMultipleVertical() {
        let offset: CGFloat = 13
        
        @AnchorsBuilder
        var anchors: Anchors {
            Anchors.vertical.equalToSuper()
            Anchors.vertical.equalToSuper(inwardOffset: offset)
            Anchors.vertical.equalTo(siblingview)
            Anchors.vertical.equalTo(siblingview, inwardOffset: offset)
        }
        let constraints = anchors.constraints(item: subview, toItem: superview)
        let expected = [
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: offset),
            NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: -offset),
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: siblingview, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: offset),
            NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: siblingview, attribute: .bottom, multiplier: 1.0, constant: -offset),
        ]
        
        #expect(isEqual(constraints, expected, tags))
    }
    
    @Test
    func staticsMultipleAllSides() {
        let offset: CGFloat = 13
        
        @AnchorsBuilder
        var anchors: Anchors {
            Anchors.allSides.equalToSuper()
            Anchors.allSides.equalToSuper(inwardOffset: offset)
            Anchors.allSides.equalTo(siblingview)
            Anchors.allSides.equalTo(siblingview, inwardOffset: offset)
        }
        let constraints = anchors.constraints(item: subview, toItem: superview)
        let expected = [
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: offset),
            NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: -offset),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: offset),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: -offset),
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: siblingview, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: siblingview, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: siblingview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: offset),
            NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: siblingview, attribute: .bottom, multiplier: 1.0, constant: -offset),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: siblingview, attribute: .leading, multiplier: 1.0, constant: offset),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: siblingview, attribute: .trailing, multiplier: 1.0, constant: -offset),
        ]
        
        #expect(isEqual(constraints, expected, tags))
    }
    
    @Test
    func staticsMultipleCap() {
        let offset: CGFloat = 13
        
        @AnchorsBuilder
        var anchors: Anchors {
            Anchors.cap.equalToSuper()
            Anchors.cap.equalToSuper(inwardOffset: offset)
            Anchors.cap.equalTo(siblingview)
            Anchors.cap.equalTo(siblingview, inwardOffset: offset)
        }
        let constraints = anchors.constraints(item: subview, toItem: superview)
        let expected = [
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: offset),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: offset),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: -offset),
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: siblingview, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: siblingview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: siblingview, attribute: .top, multiplier: 1.0, constant: offset),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: siblingview, attribute: .leading, multiplier: 1.0, constant: offset),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: siblingview, attribute: .trailing, multiplier: 1.0, constant: -offset),
        ]
        
        #expect(isEqual(constraints, expected, tags))
    }
    
    @Test
    func staticsMultipleShoe() {
        let offset: CGFloat = 13
        
        @AnchorsBuilder
        var anchors: Anchors {
            Anchors.shoe.equalToSuper()
            Anchors.shoe.equalToSuper(inwardOffset: offset)
            Anchors.shoe.equalTo(siblingview)
            Anchors.shoe.equalTo(siblingview, inwardOffset: offset)
        }
        let constraints = anchors.constraints(item: subview, toItem: superview)
        let expected = [
            NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: -offset),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: offset),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: -offset),
            NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: siblingview, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: siblingview, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: siblingview, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: siblingview, attribute: .bottom, multiplier: 1.0, constant: -offset),
            NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: siblingview, attribute: .leading, multiplier: 1.0, constant: offset),
            NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: siblingview, attribute: .trailing, multiplier: 1.0, constant: -offset),
        ]
        
        #expect(isEqual(constraints, expected, tags))
    }
    
    @Test
    func staticsMultipleSize() {
        let width: CGFloat = 11
        let height: CGFloat = 37
        
        @AnchorsBuilder
        var anchors: Anchors {
            Anchors.size.equalToSuper()
            Anchors.size.equalTo(CGSize(width: width, height: height))
            Anchors.size.equalTo(width: width, height: height)
            Anchors.size.equalTo(siblingview, widthOffset: width, heightOffset: height)
        }
        let constraints = anchors.constraints(item: subview, toItem: superview)
        let expected = [
            NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: width),
            NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: height),
            NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: width),
            NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: height),
            NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: siblingview, attribute: .width, multiplier: 1.0, constant: width),
            NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: siblingview, attribute: .height, multiplier: 1.0, constant: height),
        ]
        
        #expect(isEqual(constraints, expected, tags))
    }
    
    @Test
    func staticsMultipleCenter() {
        let offsetX: CGFloat = 11
        let offsetY: CGFloat = 37
        
        @AnchorsBuilder
        var anchors: Anchors {
            Anchors.center.equalToSuper()
            Anchors.center.equalToSuper(xOffset: offsetX, yOffset: offsetY)
            Anchors.center.equalTo(siblingview)
            Anchors.center.equalTo(siblingview, xOffset: offsetX, yOffset: offsetY)
        }
        let constraints = anchors.constraints(item: subview, toItem: superview)
        let expected = [
            NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: offsetX),
            NSLayoutConstraint(item: subview, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: offsetY),
            NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: siblingview, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .centerY, relatedBy: .equal, toItem: siblingview, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: siblingview, attribute: .centerX, multiplier: 1.0, constant: offsetX),
            NSLayoutConstraint(item: subview, attribute: .centerY, relatedBy: .equal, toItem: siblingview, attribute: .centerY, multiplier: 1.0, constant: offsetY),
        ]
        
        #expect(isEqual(constraints, expected, tags))
    }
    
    @Test
    func staticsMultipleWithMultiplier() {
        let width: CGFloat = 11
        let height: CGFloat = 37
        let offsetX: CGFloat = 11
        let offsetY: CGFloat = 37
        let multiplier: CGFloat = 0.25
        
        @AnchorsBuilder
        var anchors: Anchors {
            Anchors.size.equalTo(siblingview, widthOffset: width, heightOffset: height).multiplier(multiplier)
            Anchors.center.equalToSuper(xOffset: offsetX, yOffset: offsetY).multiplier(multiplier)
        }
        let constraints = anchors.constraints(item: subview, toItem: superview)
        let expected = [
            NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: siblingview, attribute: .width, multiplier: multiplier, constant: width),
            NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: siblingview, attribute: .height, multiplier: multiplier, constant: height),
            NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: multiplier, constant: offsetX),
            NSLayoutConstraint(item: subview, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: multiplier, constant: offsetY),
        ]
        
        #expect(isEqual(constraints, expected, tags))
    }
    
    @Test
    func staticsMultipleWithPriority() {
        let width: CGFloat = 11
        let height: CGFloat = 37
        let offsetX: CGFloat = 11
        let offsetY: CGFloat = 37
        let priority: UILayoutPriority = .defaultLow
        
        @AnchorsBuilder
        var anchors: Anchors {
            Anchors.size.equalTo(siblingview, widthOffset: width, heightOffset: height).priority(priority)
            Anchors.center.equalToSuper(xOffset: offsetX, yOffset: offsetY).priority(priority)
        }
        let constraints = anchors.constraints(item: subview, toItem: superview)
        let expected = [
            NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: siblingview, attribute: .width, multiplier: 1.0, constant: width),
            NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: siblingview, attribute: .height, multiplier: 1.0, constant: height),
            NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: offsetX),
            NSLayoutConstraint(item: subview, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: offsetY),
        ].map { constraint -> NSLayoutConstraint in
            constraint.priority = priority
            return constraint
        }
        
        #expect(isEqual(constraints, expected, tags))
    }
}
