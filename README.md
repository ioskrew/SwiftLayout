# SwiftLayout
DSL library that implements hierarhcy of views and constraints declaratively

## 문서
- 테스트 케이스와 샘플만으로도 사용법을 배울 수 있도록 개선하고 있습니다.

## 원칙

1. 사용자가 새로 배워야 하는 API는 최소한으로
2. 가능한 기존 API와 인수등을 그대로 혹시 비슷하게 사용할 수 있도록
   - constraint의 relation, multiplier, constant
   - view의 hugging, compression등
3. 코드는 최대한 단순하게

## View, Constraint Hierarhcy DSL
```swift
let root: UIView
let red: UIView
let blue: UIView
root {
    red.anchors {
        if redUp {
            Anchors(.top, .leading. trailing) // equal to root
            Anchors(.bottom).equalTo(blue, attribute: .top) // equal to top of blue
        } else {
            Anchors(.leading, .trailing, .bottom) // equal to root
            Anchors(.top).equalTo(blue, attribute: .bottom) // equal to bottom of blue
        }
        Anchors(.height).equalTo(blue, attribute: .height)
    }.subviews {
        button.anchors {
            Anchors(.centerX, .centerY)
        }
    }
    blue.anchors {
        if redUp {
            Anchors(.leading, .trailing, .bottom)
        } else {
            Anchors(.top, .leading, .trailing)
        }
    }
}
```
- 각 DSL의 closure는 `Layout`의 구현타입을 반환하며, 해당 layoutable을 레퍼런스로 들고 있지 않으면 부모 자식 관계는 사라진다.

## Preview

LayoutBuilding을 구현하는 UIView 혹은 UIViewController 구현체는 SwiftUI의 preview를

아래와 같이 간단하게 구현할 수 있습니다.

```swift
final class SomeView: UIView, LayoutBuilding { ... }
/// for preview or using in SwiftUI
extension SomeView: LayoutViewRepresentable {}

struct SomeView_Previews: PreviewProvider {
  SomeView(frame: .zero)
  	.previewDevice(...)...
}

/// for UIViewController
final class SomeViewController: UIViewController, LayoutBuilding { ... }
/// for preview or using in SwiftUI
extension SomeViewController: LayoutViewControllerRepresentable {}

struct SomeViewController_Previews: PreviewProvider {
  SomeViewController(nibName: nil, bundle: nil)
  	.previewDevice(...)...
}
```





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

### 0.5

- Constraint 고도화

### 0.6

- SwiftUI 피처 추가
- constraint 활성화 개선

### 0.7
- Anchors(Constraint) update

### 0.9
- hiding activation from out of library
