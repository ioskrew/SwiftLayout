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
 class FlagView: UIView, Layoutable {
     @LayoutProperty var showName = true // changing value do updates layout
     
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

    public init(wrappedValue: Value) {
        stored = wrappedValue
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
            instance.sl.updateLayout()
        }
    }

    @available(*, unavailable, message: "This property wrapper can only be applied to Layoutable")
    public var wrappedValue: Value {
        get { fatalError("This property wrapper can only be applied to Layoutable") }
        set { fatalError("This property wrapper can only be applied to Layoutable") }
    }
}
