//
//  LayoutProperty.swift
//
//
//  Created by oozoofrog on 2022/03/06.
//

/**
 
 a property wrapper that can update states of layout in Layoutable.
 
 update layout in Layoutable always needs call `updateLayout` function of `Layoutable`.
 ``LayoutProperty`` can hide calling it directly:
 
 ```swift
 class FlagView: SLView, Layoutable {
     var activation: Activation?
     @LayoutProperty var showName = true // changing value updates layout with .deferred mode

     // Custom update mode
     @LayoutProperty(mode: .immediate) var otherFlag = false

     var layout: some Layout {
         self {
             if showName {
                 nameLabel
             }
         }
     }
 }
 ```

 > ``LayoutProperty`` must using only in Layoutable, otherwise, cause of crash.
 */
@MainActor
@propertyWrapper
public final class LayoutProperty<Value> {

    private var stored: Value
    private let mode: LayoutUpdateMode

    public init(wrappedValue: Value, mode: LayoutUpdateMode = .deferred) {
        self.stored = wrappedValue
        self.mode = mode
    }

    public static subscript<Instance: Layoutable> (
        _enclosingInstance instance: Instance,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<Instance, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<Instance, LayoutProperty>
    ) -> Value {
        get {
            instance[keyPath: storageKeyPath].stored
        }
        set {
            instance[keyPath: storageKeyPath].stored = newValue
            instance.sl.updateLayout(instance[keyPath: storageKeyPath].mode)
        }
    }

    @available(*, unavailable, message: "This property wrapper can only be applied to Layoutable")
    public var wrappedValue: Value {
        get { fatalError("This property wrapper can only be applied to Layoutable") }
        set { fatalError("This property wrapper can only be applied to Layoutable") }
    }
}
