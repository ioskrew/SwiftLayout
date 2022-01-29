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

- view의 부모와 자식의 관계는 아래와 같이 이루어진다.
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

- 관계 DSL은 `Layoutable`을 반환하며, 해당 layoutable을 레퍼런스로 들고 있지 않으면 부모 자식 관계는 사라진다.

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

