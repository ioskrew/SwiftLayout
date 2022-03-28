//
//  AnimatableLayoutProperty.swift
//
//
//  Created by aiden_h on 2022/03/28.
//

import UIKit

@propertyWrapper
public final class AnimatableLayoutProperty<Value> {

    private var stored : Value
    private var duration: TimeInterval
    private var delay: TimeInterval
    private var options: UIView.AnimationOptions
    private var completion: ((Bool) -> Void)?
    
    public init(
        wrappedValue: Value,
        duration: TimeInterval,
        delay: TimeInterval = .zero,
        options: UIView.AnimationOptions = [],
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
            
            UIView.animate(
                withDuration: instance[keyPath: storageKeyPath].duration,
                delay: instance[keyPath: storageKeyPath].delay,
                options: instance[keyPath: storageKeyPath].options,
                animations: { [weak instance] in
                    instance?.sl.updateLayout()
                },
                completion: instance[keyPath: storageKeyPath].completion
            )
        }
    }
    
    @available(*, unavailable, message: "This property wrapper can only be applied to Layoutable")
    public var wrappedValue: Value {
      get { fatalError() }
      set { fatalError() }
    }
}
