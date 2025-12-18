//
//  AnimatableLayoutProperty.swift
//
//
//  Created by aiden_h on 2022/03/28.
//

import SwiftLayoutPlatform

/// A property wrapper that automatically animates layout changes when the value changes.
///
/// Use `AnimatableLayoutProperty` to create properties that trigger animated layout updates:
///
/// ```swift
/// class MyView: SLView, Layoutable {
///     var activation: Activation?
///
///     @AnimatableLayoutProperty(duration: 0.3)
///     var isExpanded = false
///
///     var layout: some Layout {
///         self.sl.sublayout {
///             contentView.sl.anchors {
///                 Anchors.horizontal.equalToSuper()
///                 if isExpanded {
///                     Anchors.height.equalTo(constant: 200)
///                 } else {
///                     Anchors.height.equalTo(constant: 50)
///                 }
///             }
///         }
///     }
/// }
///
/// // Changing the value animates the layout
/// myView.isExpanded = true
/// ```
///
/// > Warning: This property wrapper must only be used in types conforming to ``Layoutable``.
@MainActor
@propertyWrapper
public final class AnimatableLayoutProperty<Value> {

    private var stored: Value
    private var duration: TimeInterval
    private var delay: TimeInterval
    private var options: SLAnimationOptions
    private var completion: ((Bool) -> Void)?

    public init(
        wrappedValue: Value,
        duration: TimeInterval,
        delay: TimeInterval = .zero,
        options: SLAnimationOptions = [],
        completion: ((Bool) -> Void)? = nil
    ) {
        self.stored = wrappedValue
        self.duration = duration
        self.delay = delay
        self.options = options
        self.completion = completion
    }

    public static subscript<Instance: Layoutable> (
        _enclosingInstance instance: Instance,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<Instance, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<Instance, AnimatableLayoutProperty>
    ) -> Value {
        get {
            instance[keyPath: storageKeyPath].stored
        }
        set {
            instance[keyPath: storageKeyPath].stored = newValue

            SwiftLayoutPlatformHelper.animate(
                duration: instance[keyPath: storageKeyPath].duration,
                delay: instance[keyPath: storageKeyPath].delay,
                options: instance[keyPath: storageKeyPath].options,
                animations: { [weak instance] in
                    instance?.sl.updateLayout(.forced)
                },
                completion: instance[keyPath: storageKeyPath].completion
            )
        }
    }

    @available(*, unavailable, message: "This property wrapper can only be applied to Layoutable")
    public var wrappedValue: Value {
        get { fatalError("This property wrapper can only be applied to Layoutable") }
        set { fatalError("This property wrapper can only be applied to Layoutable") }
    }
}
