# SwiftLayout
view hierarchy and autolayout DSL library

## 원칙

1. 사용자가 새로 배워야 하는 API는 최소한으로
2. 가능한 기존 API와 인수등을 그대로 혹시 비슷하게 사용할 수 있도록
   - constraint의 relation, multiplier, constant
   - view의 hugging, compression등
3. 코드는 최대한 단순하게

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

