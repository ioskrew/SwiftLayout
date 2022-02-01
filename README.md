# SwiftLayout
view hierarchy and autolayout DSL library

## 원칙

1. 사용자가 새로 배워야 하는 API는 최소한으로
2. 가능한 기존 API와 인수등을 그대로 혹시 비슷하게 사용할 수 있도록
   - constraint의 relation, multiplier, constant
   - view의 hugging, compression등
3. 코드는 최대한 단순하게

## 규칙

### View Hierarhcy DSL

- view의 부모와 자식의 관계는 아래와 같이 더해진다.
```swift
parent {
    child1
    child2 {
        grandchild1
        ...
    }
    ...
}
```
```swift
let layoutable = parent {
    child
}.active()
```
- 관계 DSL은 `Layoutable`의 구현타입을 반환하며, 해당 layoutable을 레퍼런스로 들고 있지 않으면 부모 자식 관계는 사라진다.

## Version

### 0.1

- View Add Subview의 DSL 추가

```swift
let parent: UIView
let child: UIView
// child.superview == parent
parent {
  child
}
```

### 0.2

- layoutable의 계층은 LayoutTree로 표현하며, Layoutable의 active함수를 호출하면서 만들어진다

- LayoutTree 인스턴스가 메모리에서 사라지면, 해당 계층구조가 들고 있는 모든 view가 superview로부터 제거된다. [^주1]


```swift
let tree = root {
	child
}.active()

// deinit tree or tree.deactive()
// child.superview == nil
```

### 0.3

- LayoutTree구조를 명시적으로 만들지 않고, 각 구현 타입의 추상화된 관계를 통해 암묵적으로 구현한다.

[^주1]: DSL 계층의 최상단의 뷰는 자기 자신을 superview로 부터 제거하지 않는다.

 ### 0.4
 
 - UIView의 constraint 조합을 DSL로 구현한다. (어떻게 하징...?)
